#!/bin/bash

# 🎯 Performance Testing Suite for Docker & YAML Mastery
# Tests performance across different project configurations

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎯 Docker & YAML Mastery - Performance Testing Suite${NC}"

# Configuration
RESULTS_DIR="performance-results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="$RESULTS_DIR/performance_report_$TIMESTAMP.json"

# Test configurations
declare -A TEST_CONFIGS=(
    ["p1"]="http://localhost:3000"
    ["p2"]="http://localhost:3000"
    ["p6"]="http://localhost:8000"
    ["p10"]="http://localhost:9021"
    ["p14"]="http://localhost:3000"
)

# Create results directory
mkdir -p "$RESULTS_DIR"

# Initialize report
cat > "$REPORT_FILE" << EOF
{
    "timestamp": "$TIMESTAMP",
    "tests": []
}
EOF

run_load_test() {
    local project=$1
    local url=$2
    local test_name="${project}_load_test"
    
    echo -e "${YELLOW}Running load test for $project...${NC}"
    
    # Create k6 test script
    cat > "/tmp/${test_name}.js" << EOF
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    stages: [
        { duration: '2m', target: 100 }, // Ramp up
        { duration: '5m', target: 100 }, // Stay at 100 users
        { duration: '2m', target: 200 }, // Ramp up to 200 users
        { duration: '5m', target: 200 }, // Stay at 200 users
        { duration: '2m', target: 0 },   // Ramp down
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% of requests must complete below 500ms
        http_req_failed: ['rate<0.05'],   // Less than 5% of requests should fail
    },
};

export default function () {
    let response = http.get('$url');
    check(response, {
        'status is 200': (r) => r.status === 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });
    sleep(1);
}
EOF

    # Run k6 test
    k6 run --out json="/tmp/${test_name}_results.json" "/tmp/${test_name}.js"
    
    # Process results
    local avg_response_time=$(jq '.metrics.http_req_duration.values.avg' "/tmp/${test_name}_results.json")
    local error_rate=$(jq '.metrics.http_req_failed.values.rate' "/tmp/${test_name}_results.json")
    local rps=$(jq '.metrics.http_reqs.values.rate' "/tmp/${test_name}_results.json")
    
    # Add to report
    jq --arg project "$project" \
       --arg avg_time "$avg_response_time" \
       --arg error_rate "$error_rate" \
       --arg rps "$rps" \
       '.tests += [{
           "project": $project,
           "avg_response_time_ms": ($avg_time | tonumber),
           "error_rate": ($error_rate | tonumber),
           "requests_per_second": ($rps | tonumber),
           "status": (if ($error_rate | tonumber) < 0.05 then "PASS" else "FAIL" end)
       }]' "$REPORT_FILE" > "/tmp/report.json" && mv "/tmp/report.json" "$REPORT_FILE"
}

run_docker_performance_test() {
    local project=$1
    
    echo -e "${YELLOW}Running Docker performance test for $project...${NC}"
    
    cd "$project"
    
    # Measure build time
    start_time=$(date +%s)
    docker-compose build --no-cache > /dev/null 2>&1
    build_time=$(($(date +%s) - start_time))
    
    # Measure startup time
    start_time=$(date +%s)
    docker-compose up -d > /dev/null 2>&1
    
    # Wait for services to be ready
    sleep 30
    
    startup_time=$(($(date +%s) - start_time))
    
    # Measure resource usage
    local memory_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" | tail -n +2 | awk '{sum += $1} END {print sum}')
    local cpu_usage=$(docker stats --no-stream --format "table {{.CPUPerc}}" | tail -n +2 | awk '{gsub(/%/, "", $1); sum += $1} END {print sum}')
    
    # Stop services
    docker-compose down > /dev/null 2>&1
    
    # Add to report
    jq --arg project "$project" \
       --arg build_time "$build_time" \
       --arg startup_time "$startup_time" \
       --arg memory "$memory_usage" \
       --arg cpu "$cpu_usage" \
       '.docker_performance += [{
           "project": $project,
           "build_time_seconds": ($build_time | tonumber),
           "startup_time_seconds": ($startup_time | tonumber),
           "memory_usage_mb": ($memory | tonumber),
           "cpu_usage_percent": ($cpu | tonumber)
       }]' "$REPORT_FILE" > "/tmp/report.json" && mv "/tmp/report.json" "$REPORT_FILE"
    
    cd ..
}

run_compose_file_analysis() {
    local project=$1
    
    echo -e "${YELLOW}Analyzing Docker Compose file for $project...${NC}"
    
    local compose_file="$project/docker-compose.yml"
    
    if [[ ! -f "$compose_file" ]]; then
        return
    fi
    
    # Count services
    local service_count=$(yq eval '.services | length' "$compose_file")
    
    # Count volumes
    local volume_count=$(yq eval '.volumes | length' "$compose_file" 2>/dev/null || echo "0")
    
    # Count networks
    local network_count=$(yq eval '.networks | length' "$compose_file" 2>/dev/null || echo "0")
    
    # Check for health checks
    local health_checks=$(yq eval '.services[].healthcheck | select(. != null) | length' "$compose_file" 2>/dev/null || echo "0")
    
    # Check for resource limits
    local resource_limits=$(yq eval '.services[].deploy.resources | select(. != null) | length' "$compose_file" 2>/dev/null || echo "0")
    
    # Security analysis
    local exposed_ports=$(yq eval '.services[].ports[] | select(. != null)' "$compose_file" 2>/dev/null | wc -l)
    local privileged_containers=$(yq eval '.services[].privileged | select(. == true)' "$compose_file" 2>/dev/null | wc -l)
    
    # Add to report
    jq --arg project "$project" \
       --arg services "$service_count" \
       --arg volumes "$volume_count" \
       --arg networks "$network_count" \
       --arg health_checks "$health_checks" \
       --arg resource_limits "$resource_limits" \
       --arg exposed_ports "$exposed_ports" \
       --arg privileged "$privileged_containers" \
       '.compose_analysis += [{
           "project": $project,
           "service_count": ($services | tonumber),
           "volume_count": ($volumes | tonumber),
           "network_count": ($networks | tonumber),
           "health_checks": ($health_checks | tonumber),
           "resource_limits": ($resource_limits | tonumber),
           "exposed_ports": ($exposed_ports | tonumber),
           "privileged_containers": ($privileged | tonumber),
           "complexity_score": (($services | tonumber) + ($volumes | tonumber) + ($networks | tonumber))
       }]' "$REPORT_FILE" > "/tmp/report.json" && mv "/tmp/report.json" "$REPORT_FILE"
}

generate_performance_dashboard() {
    echo -e "${YELLOW}Generating performance dashboard...${NC}"
    
    cat > "$RESULTS_DIR/dashboard.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker & YAML Mastery - Performance Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <header class="text-center mb-8">
            <h1 class="text-3xl font-bold text-blue-600">🎯 Performance Dashboard</h1>
            <p class="text-gray-600">Docker & YAML Mastery Performance Metrics</p>
        </header>
        
        <div class="grid md:grid-cols-2 gap-6 mb-8">
            <div class="bg-white p-6 rounded-lg shadow">
                <h3 class="text-xl font-semibold mb-4">Response Time (ms)</h3>
                <canvas id="responseTimeChart"></canvas>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow">
                <h3 class="text-xl font-semibold mb-4">Build Time (seconds)</h3>
                <canvas id="buildTimeChart"></canvas>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow">
                <h3 class="text-xl font-semibold mb-4">Memory Usage (MB)</h3>
                <canvas id="memoryChart"></canvas>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow">
                <h3 class="text-xl font-semibold mb-4">Complexity Score</h3>
                <canvas id="complexityChart"></canvas>
            </div>
        </div>
        
        <div class="bg-white p-6 rounded-lg shadow">
            <h3 class="text-xl font-semibold mb-4">Performance Summary</h3>
            <div id="performanceSummary"></div>
        </div>
    </div>
    
    <script>
        // Load performance data and create charts
        fetch('performance_report_latest.json')
            .then(response => response.json())
            .then(data => {
                createCharts(data);
                createSummary(data);
            });
            
        function createCharts(data) {
            // Implementation would load actual data and create charts
            console.log('Performance data:', data);
        }
        
        function createSummary(data) {
            // Create summary table
            const summaryDiv = document.getElementById('performanceSummary');
            summaryDiv.innerHTML = '<p>Performance metrics loaded successfully!</p>';
        }
    </script>
</body>
</html>
EOF
    
    # Create latest symlink
    ln -sf "performance_report_$TIMESTAMP.json" "$RESULTS_DIR/performance_report_latest.json"
}

run_security_performance_test() {
    echo -e "${YELLOW}Running security performance tests...${NC}"
    
    # Test image scanning performance
    start_time=$(date +%s)
    trivy fs . --quiet > /dev/null 2>&1
    scan_time=$(($(date +%s) - start_time))
    
    # Test vulnerability count
    vuln_count=$(trivy fs . --format json 2>/dev/null | jq '.Results[].Vulnerabilities | length' | awk '{sum+=$1} END {print sum}')
    
    # Add to report
    jq --arg scan_time "$scan_time" \
       --arg vuln_count "$vuln_count" \
       '.security_performance = {
           "scan_time_seconds": ($scan_time | tonumber),
           "vulnerability_count": ($vuln_count | tonumber),
           "security_score": (100 - ($vuln_count | tonumber))
       }' "$REPORT_FILE" > "/tmp/report.json" && mv "/tmp/report.json" "$REPORT_FILE"
}

# Main function
main() {
    echo -e "${GREEN}Starting comprehensive performance testing...${NC}"
    
    # Initialize report structure
    jq '. + {"docker_performance": [], "compose_analysis": []}' "$REPORT_FILE" > "/tmp/report.json" && mv "/tmp/report.json" "$REPORT_FILE"
    
    # Test each project
    for project in "${!TEST_CONFIGS[@]}"; do
        if [[ -d "$project" ]]; then
            echo -e "${BLUE}Testing project: $project${NC}"
            
            # Docker performance test
            run_docker_performance_test "$project"
            
            # Compose file analysis
            run_compose_file_analysis "$project"
            
            # Load test (if URL provided)
            if [[ -n "${TEST_CONFIGS[$project]}" ]]; then
                cd "$project"
                docker-compose up -d > /dev/null 2>&1
                sleep 30
                
                run_load_test "$project" "${TEST_CONFIGS[$project]}"
                
                docker-compose down > /dev/null 2>&1
                cd ..
            fi
        fi
    done
    
    # Security performance test
    run_security_performance_test
    
    # Generate dashboard
    generate_performance_dashboard
    
    echo -e "${GREEN}✅ Performance testing completed!${NC}"
    echo -e "${YELLOW}Report: $REPORT_FILE${NC}"
    echo -e "${YELLOW}Dashboard: $RESULTS_DIR/dashboard.html${NC}"
}

# Help function
show_help() {
    cat << EOF
🎯 Performance Testing Suite

Usage: $0 [OPTIONS]

Options:
    --project PROJECT     Test specific project only
    --quick              Run quick tests only
    --load-only          Run load tests only
    --docker-only        Run Docker performance tests only
    --report-only        Generate report from existing data
    --help               Show this help

Examples:
    $0                   # Run all tests
    $0 --project p6      # Test only p6
    $0 --quick           # Quick test suite
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            SINGLE_PROJECT="$2"
            shift 2
            ;;
        --quick)
            QUICK_MODE=true
            shift
            ;;
        --load-only)
            LOAD_ONLY=true
            shift
            ;;
        --docker-only)
            DOCKER_ONLY=true
            shift
            ;;
        --report-only)
            generate_performance_dashboard
            exit 0
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run main function
main
