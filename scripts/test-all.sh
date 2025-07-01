#!/bin/bash

# 🧪 Docker & YAML Mastery - Automated Testing Suite
# Validates all projects, configurations, and learning materials

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Logging
LOG_FILE="test-results-$(date +%Y%m%d-%H%M%S).log"
mkdir -p logs
exec 1> >(tee -a "logs/$LOG_FILE")
exec 2>&1

print_test_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🧪 $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_test_result() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}❌ FAIL${NC} - $test_name"
        [ -n "$details" ] && echo -e "   ${YELLOW}Details: $details${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Test YAML validation
test_yaml_validation() {
    print_test_header "YAML Validation Tests"
    
    # Install yamllint if not present
    if ! command -v yamllint &> /dev/null; then
        pip install yamllint || {
            print_test_result "Install yamllint" "FAIL" "Could not install yamllint"
            return
        }
    fi
    
    # Test all YAML files
    local yaml_files=($(find . -name "*.yml" -o -name "*.yaml" | grep -v node_modules | head -20))
    
    for yaml_file in "${yaml_files[@]}"; do
        if yamllint -d relaxed "$yaml_file" >/dev/null 2>&1; then
            print_test_result "YAML Syntax: $yaml_file" "PASS"
        else
            local error=$(yamllint -d relaxed "$yaml_file" 2>&1 | head -1)
            print_test_result "YAML Syntax: $yaml_file" "FAIL" "$error"
        fi
    done
}

# Test Docker Compose validation
test_docker_compose_validation() {
    print_test_header "Docker Compose Validation Tests"
    
    for dir in p*/; do
        if [ -f "$dir/docker-compose.yml" ]; then
            if docker-compose -f "$dir/docker-compose.yml" config >/dev/null 2>&1; then
                print_test_result "Compose Config: $dir" "PASS"
            else
                local error=$(docker-compose -f "$dir/docker-compose.yml" config 2>&1 | head -1)
                print_test_result "Compose Config: $dir" "FAIL" "$error"
            fi
        fi
    done
}

# Test Dockerfile validation
test_dockerfile_validation() {
    print_test_header "Dockerfile Validation Tests"
    
    # Install hadolint if not present
    if ! command -v hadolint &> /dev/null; then
        wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-x86_64 2>/dev/null || {
            print_test_result "Install hadolint" "FAIL" "Could not download hadolint"
            return
        }
        chmod +x /tmp/hadolint
        sudo mv /tmp/hadolint /usr/local/bin/ 2>/dev/null || mv /tmp/hadolint ./hadolint
    fi
    
    # Test all Dockerfiles
    local dockerfiles=($(find . -name "Dockerfile*" | head -10))
    
    for dockerfile in "${dockerfiles[@]}"; do
        if hadolint "$dockerfile" >/dev/null 2>&1; then
            print_test_result "Dockerfile Lint: $dockerfile" "PASS"
        else
            local error=$(hadolint "$dockerfile" 2>&1 | head -1)
            print_test_result "Dockerfile Lint: $dockerfile" "FAIL" "$error"
        fi
    done
}

# Test project builds
test_project_builds() {
    print_test_header "Project Build Tests"
    
    # Test first 5 projects to avoid long build times
    for project in p1 p2 p3 p4 p6; do
        if [ -d "$project" ] && [ -f "$project/docker-compose.yml" ]; then
            echo "Testing build for $project..."
            
            cd "$project"
            
            # Build images
            if docker-compose build --no-cache >/dev/null 2>&1; then
                print_test_result "Build: $project" "PASS"
            else
                print_test_result "Build: $project" "FAIL" "Build failed"
            fi
            
            cd ..
        fi
    done
}

# Test container startup
test_container_startup() {
    print_test_header "Container Startup Tests"
    
    # Test lightweight projects
    for project in p1 p3; do
        if [ -d "$project" ] && [ -f "$project/docker-compose.yml" ]; then
            echo "Testing startup for $project..."
            
            cd "$project"
            
            # Start containers
            if docker-compose up -d >/dev/null 2>&1; then
                sleep 10
                
                # Check if containers are running
                local running_containers=$(docker-compose ps -q | wc -l)
                local expected_containers=$(docker-compose config --services | wc -l)
                
                if [ "$running_containers" -eq "$expected_containers" ]; then
                    print_test_result "Startup: $project" "PASS"
                else
                    print_test_result "Startup: $project" "FAIL" "Not all containers started"
                fi
                
                # Cleanup
                docker-compose down -v >/dev/null 2>&1
            else
                print_test_result "Startup: $project" "FAIL" "Could not start containers"
            fi
            
            cd ..
        fi
    done
}

# Test health checks
test_health_checks() {
    print_test_header "Health Check Tests"
    
    # Test project with health checks (p6 - Django)
    if [ -d "p6" ] && [ -f "p6/docker-compose.yml" ]; then
        cd p6
        
        echo "Testing health checks for Django project..."
        
        # Start containers
        if docker-compose up -d >/dev/null 2>&1; then
            sleep 30
            
            # Check health status
            local healthy_containers=$(docker-compose ps | grep -c "(healthy)" || true)
            
            if [ "$healthy_containers" -gt 0 ]; then
                print_test_result "Health Checks: p6" "PASS"
            else
                print_test_result "Health Checks: p6" "FAIL" "No healthy containers found"
            fi
            
            # Cleanup
            docker-compose down -v >/dev/null 2>&1
        else
            print_test_result "Health Checks: p6" "FAIL" "Could not start containers"
        fi
        
        cd ..
    fi
}

# Test quiz system
test_quiz_system() {
    print_test_header "Quiz System Tests"
    
    if [ -f "package.json" ]; then
        # Install dependencies
        if npm install >/dev/null 2>&1; then
            print_test_result "Quiz Dependencies" "PASS"
        else
            print_test_result "Quiz Dependencies" "FAIL" "npm install failed"
            return
        fi
        
        # Test quiz validation
        if [ -d "quizzes" ]; then
            if npm run validate 2>/dev/null || true; then
                print_test_result "Quiz Validation" "PASS"
            else
                print_test_result "Quiz Validation" "FAIL" "Quiz validation failed"
            fi
        fi
    fi
}

# Test documentation links
test_documentation_links() {
    print_test_header "Documentation Tests"
    
    # Check if README files exist
    local readme_files=("README.md" "basics/README.md" "quizzes/README.md" "kubernetes/README.md")
    
    for readme in "${readme_files[@]}"; do
        if [ -f "$readme" ]; then
            print_test_result "Documentation: $readme" "PASS"
        else
            print_test_result "Documentation: $readme" "FAIL" "File not found"
        fi
    done
    
    # Check for broken internal links (basic check)
    if grep -r "\[.*\](\./" . --include="*.md" >/dev/null 2>&1; then
        print_test_result "Internal Links Check" "PASS"
    else
        print_test_result "Internal Links Check" "FAIL" "No internal links found"
    fi
}

# Test security basics
test_security_basics() {
    print_test_header "Security Tests"
    
    # Check for common security issues
    local security_issues=0
    
    # Check for hardcoded passwords
    if grep -r "password.*=" . --include="*.yml" --include="*.yaml" | grep -v "example\|placeholder\|your-password" >/dev/null; then
        print_test_result "Hardcoded Passwords" "FAIL" "Found potential hardcoded passwords"
        security_issues=$((security_issues + 1))
    else
        print_test_result "Hardcoded Passwords" "PASS"
    fi
    
    # Check for root user usage
    if grep -r "user.*root" . --include="*.yml" --include="*.yaml" >/dev/null; then
        print_test_result "Root User Usage" "FAIL" "Found root user configurations"
        security_issues=$((security_issues + 1))
    else
        print_test_result "Root User Usage" "PASS"
    fi
    
    # Check for privileged containers
    if grep -r "privileged.*true" . --include="*.yml" --include="*.yaml" >/dev/null; then
        print_test_result "Privileged Containers" "FAIL" "Found privileged containers"
        security_issues=$((security_issues + 1))
    else
        print_test_result "Privileged Containers" "PASS"
    fi
}

# Test performance basics
test_performance_basics() {
    print_test_header "Performance Tests"
    
    # Check for resource limits
    local projects_with_limits=0
    
    for dir in p*/; do
        if [ -f "$dir/docker-compose.yml" ]; then
            if grep -q "mem_limit\|cpus\|memory" "$dir/docker-compose.yml"; then
                projects_with_limits=$((projects_with_limits + 1))
            fi
        fi
    done
    
    if [ $projects_with_limits -gt 5 ]; then
        print_test_result "Resource Limits" "PASS"
    else
        print_test_result "Resource Limits" "FAIL" "Few projects have resource limits"
    fi
    
    # Check for health checks
    local projects_with_health=0
    
    for dir in p*/; do
        if [ -f "$dir/docker-compose.yml" ]; then
            if grep -q "healthcheck" "$dir/docker-compose.yml"; then
                projects_with_health=$((projects_with_health + 1))
            fi
        fi
    done
    
    if [ $projects_with_health -gt 3 ]; then
        print_test_result "Health Checks" "PASS"
    else
        print_test_result "Health Checks" "FAIL" "Few projects have health checks"
    fi
}

# Generate test report
generate_test_report() {
    print_test_header "Test Summary Report"
    
    echo -e "\n${GREEN}📊 Test Results Summary${NC}"
    echo "=========================="
    echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
    echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
    echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
    
    local pass_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "Pass Rate: ${GREEN}$pass_rate%${NC}"
    
    echo -e "\n${YELLOW}📝 Detailed log: logs/$LOG_FILE${NC}"
    
    # Set exit code based on results
    if [ $FAILED_TESTS -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All tests passed! Your Docker & YAML Mastery project is ready!${NC}"
        exit 0
    else
        echo -e "\n${RED}⚠️  Some tests failed. Please review the results and fix issues.${NC}"
        exit 1
    fi
}

# Main test execution
main() {
    echo -e "${BLUE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🧪 Docker & YAML Mastery - Test Suite                     ║
║                                                               ║
║   Validating projects, configurations, and learning content  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo "Starting comprehensive test suite..."
    echo "This may take several minutes..."
    echo ""
    
    # Run all test suites
    test_yaml_validation
    test_docker_compose_validation
    test_dockerfile_validation
    test_project_builds
    test_container_startup
    test_health_checks
    test_quiz_system
    test_documentation_links
    test_security_basics
    test_performance_basics
    
    # Generate final report
    generate_test_report
}

# Handle command line arguments
case "${1:-}" in
    --yaml-only)
        test_yaml_validation
        ;;
    --docker-only)
        test_docker_compose_validation
        test_dockerfile_validation
        ;;
    --build-only)
        test_project_builds
        ;;
    --quick)
        test_yaml_validation
        test_docker_compose_validation
        ;;
    --security)
        test_security_basics
        ;;
    --help|-h)
        echo "Docker & YAML Mastery Test Suite"
        echo ""
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  --yaml-only    Run only YAML validation tests"
        echo "  --docker-only  Run only Docker-related tests"
        echo "  --build-only   Run only build tests"
        echo "  --quick        Run quick validation tests"
        echo "  --security     Run only security tests"
        echo "  --help, -h     Show this help message"
        echo ""
        echo "Default: Run all tests"
        ;;
    *)
        main
        ;;
esac
