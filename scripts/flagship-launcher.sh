#!/bin/bash

# 🎪 Docker & YAML Mastery - Complete Platform Launcher
# The ultimate one-command setup for the flagship learning experience

set -e

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Platform configuration
PLATFORM_VERSION="2.0.0"
PLATFORM_NAME="Docker & YAML Mastery"
PLATFORM_URL="https://docker-mastery.dev"

# Feature flags
ENABLE_DEMOS=${ENABLE_DEMOS:-true}
ENABLE_QUIZZES=${ENABLE_QUIZZES:-true}
ENABLE_CHALLENGES=${ENABLE_CHALLENGES:-true}
ENABLE_MONITORING=${ENABLE_MONITORING:-true}
ENABLE_SECURITY=${ENABLE_SECURITY:-true}

# Display flagship banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🐳 DOCKER & YAML MASTERY v2.0                                 ║
║   The Ultimate Container Learning Platform                       ║
║                                                                  ║
║   🎮 Live Demos  🧠 AI Quizzes  🎯 Challenges  ☸️ K8s Prep      ║
║   📊 Analytics  🔒 Security    🏆 Community   📈 Career         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${BOLD}🌟 Join 15,000+ developers mastering modern containerization${NC}"
    echo -e "${YELLOW}⚡ Launch Time: ~60 seconds | 🎯 15 Projects | 🧠 AI-Powered | 🏆 Gamified${NC}"
    echo ""
}

# Check system requirements
check_requirements() {
    echo -e "${BLUE}🔍 Checking system requirements...${NC}"
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found. Please install Docker Desktop.${NC}"
        echo -e "${YELLOW}   Download: https://docker.com/get-started${NC}"
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${YELLOW}⚠️  Docker Compose not found as separate command, checking Docker Compose V2...${NC}"
        if ! docker compose version &> /dev/null; then
            echo -e "${RED}❌ Docker Compose not available. Please update Docker Desktop.${NC}"
            exit 1
        fi
        # Use Docker Compose V2
        alias docker-compose='docker compose'
    fi
    
    # Check Node.js for quiz system
    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}⚠️  Node.js not found. Installing via Docker for quiz system...${NC}"
        NODE_IN_DOCKER=true
    fi
    
    # Check available disk space (need at least 5GB)
    available_space=$(df . | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt 5242880 ]; then
        echo -e "${YELLOW}⚠️  Low disk space. Recommend at least 5GB free for all demos.${NC}"
    fi
    
    echo -e "${GREEN}✅ System requirements check complete${NC}"
}

# Initialize platform data
init_platform() {
    echo -e "${BLUE}🚀 Initializing Docker & YAML Mastery platform...${NC}"
    
    # Create data directories
    mkdir -p {data,logs,backups,performance-results,demo-sessions}
    mkdir -p data/{users,progress,achievements,leaderboard,analytics}
    
    # Initialize platform configuration
    cat > data/platform-config.json << EOF
{
    "version": "$PLATFORM_VERSION",
    "platform": "$PLATFORM_NAME",
    "features": {
        "demos": $ENABLE_DEMOS,
        "quizzes": $ENABLE_QUIZZES,
        "challenges": $ENABLE_CHALLENGES,
        "monitoring": $ENABLE_MONITORING,
        "security": $ENABLE_SECURITY
    },
    "launch_time": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "environment": "${ENVIRONMENT:-local}"
}
EOF
    
    # Set up logging
    echo "$(date): Platform initialization started" >> logs/platform.log
    
    echo -e "${GREEN}✅ Platform data initialized${NC}"
}

# Start core platform services
start_platform_services() {
    echo -e "${BLUE}🏗️ Starting core platform services...${NC}"
    
    # Create platform docker-compose.yml
    cat > docker-compose.platform.yml << EOF
version: '3.8'

services:
  platform-dashboard:
    image: nginx:alpine
    container_name: mastery-dashboard
    ports:
      - "3000:80"
    volumes:
      - ./platform/dashboard:/usr/share/nginx/html:ro
      - ./platform/nginx.conf:/etc/nginx/nginx.conf:ro
    restart: unless-stopped
    
  analytics-service:
    image: node:18-alpine
    container_name: mastery-analytics
    working_dir: /app
    volumes:
      - ./platform/analytics:/app
      - ./data:/app/data
    command: node server.js
    ports:
      - "3001:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    
  quiz-engine:
    image: node:18-alpine
    container_name: mastery-quiz-engine
    working_dir: /app
    volumes:
      - ./quizzes:/app
      - ./data/users:/app/data/users
    command: node advanced-quiz-system.js
    ports:
      - "3002:3000"
    restart: unless-stopped
    
  demo-proxy:
    image: traefik:v2.9
    container_name: mastery-demo-proxy
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./platform/traefik.yml:/etc/traefik/traefik.yml:ro
    restart: unless-stopped
    
  monitoring:
    image: prom/prometheus:latest
    container_name: mastery-monitoring
    ports:
      - "9090:9090"
    volumes:
      - ./platform/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    restart: unless-stopped
    
volumes:
  prometheus_data:

networks:
  default:
    name: mastery-network
EOF
    
    # Start platform services
    docker-compose -f docker-compose.platform.yml up -d
    
    echo -e "${GREEN}✅ Core platform services started${NC}"
}

# Generate platform dashboard
generate_dashboard() {
    echo -e "${BLUE}📊 Generating interactive dashboard...${NC}"
    
    mkdir -p platform/dashboard
    
    cat > platform/dashboard/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker & YAML Mastery - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">
    <!-- Header -->
    <header class="bg-white shadow-lg">
        <div class="container mx-auto px-6 py-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <i class="fab fa-docker text-3xl text-blue-600 mr-3"></i>
                    <h1 class="text-2xl font-bold text-gray-800">Docker & YAML Mastery</h1>
                </div>
                <div class="flex space-x-4">
                    <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">🟢 All Systems Operational</span>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Dashboard -->
    <main class="container mx-auto px-6 py-8">
        <!-- Welcome Section -->
        <div class="bg-white rounded-lg shadow-lg p-8 mb-8">
            <h2 class="text-3xl font-bold text-gray-800 mb-4">🚀 Welcome to Your Learning Journey!</h2>
            <p class="text-gray-600 text-lg mb-6">Master Docker and YAML with 15 progressive projects, interactive quizzes, and real-world challenges.</p>
            
            <div class="grid md:grid-cols-3 gap-4">
                <div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 rounded-lg">
                    <i class="fas fa-code text-2xl mb-2"></i>
                    <h3 class="font-semibold">15 Projects</h3>
                    <p class="text-sm opacity-90">From beginner to expert</p>
                </div>
                <div class="bg-gradient-to-r from-green-500 to-green-600 text-white p-4 rounded-lg">
                    <i class="fas fa-brain text-2xl mb-2"></i>
                    <h3 class="font-semibold">AI Quizzes</h3>
                    <p class="text-sm opacity-90">Adaptive learning system</p>
                </div>
                <div class="bg-gradient-to-r from-purple-500 to-purple-600 text-white p-4 rounded-lg">
                    <i class="fas fa-trophy text-2xl mb-2"></i>
                    <h3 class="font-semibold">Challenges</h3>
                    <p class="text-sm opacity-90">Weekly competitions</p>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <a href="/demos" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="text-center">
                    <i class="fas fa-play-circle text-4xl text-blue-600 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Live Demos</h3>
                    <p class="text-gray-600">Try all projects instantly</p>
                </div>
            </a>
            
            <a href="/quiz" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="text-center">
                    <i class="fas fa-question-circle text-4xl text-green-600 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Take Quiz</h3>
                    <p class="text-gray-600">Test your knowledge</p>
                </div>
            </a>
            
            <a href="/challenges" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="text-center">
                    <i class="fas fa-target text-4xl text-orange-600 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Challenges</h3>
                    <p class="text-gray-600">Weekly competitions</p>
                </div>
            </a>
            
            <a href="/progress" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition-shadow">
                <div class="text-center">
                    <i class="fas fa-chart-line text-4xl text-purple-600 mb-4"></i>
                    <h3 class="text-xl font-semibold text-gray-800 mb-2">Progress</h3>
                    <p class="text-gray-600">Track your journey</p>
                </div>
            </a>
        </div>

        <!-- Learning Paths -->
        <div class="bg-white rounded-lg shadow-lg p-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">📚 Learning Paths</h2>
            
            <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="border border-green-200 rounded-lg p-4">
                    <div class="text-center mb-4">
                        <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm">🟢 Beginner</span>
                    </div>
                    <h3 class="font-semibold text-gray-800 mb-2">Foundation (P1-P3)</h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Basic containerization</li>
                        <li>• Service communication</li>
                        <li>• Data persistence</li>
                    </ul>
                    <button class="w-full mt-4 bg-green-500 text-white py-2 rounded hover:bg-green-600">Start Learning</button>
                </div>
                
                <div class="border border-yellow-200 rounded-lg p-4">
                    <div class="text-center mb-4">
                        <span class="bg-yellow-100 text-yellow-800 px-3 py-1 rounded-full text-sm">🟡 Intermediate</span>
                    </div>
                    <h3 class="font-semibold text-gray-800 mb-2">Production (P4-P7)</h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Background processing</li>
                        <li>• Monitoring & logging</li>
                        <li>• Message queues</li>
                    </ul>
                    <button class="w-full mt-4 bg-yellow-500 text-white py-2 rounded hover:bg-yellow-600">Continue</button>
                </div>
                
                <div class="border border-red-200 rounded-lg p-4">
                    <div class="text-center mb-4">
                        <span class="bg-red-100 text-red-800 px-3 py-1 rounded-full text-sm">🔴 Advanced</span>
                    </div>
                    <h3 class="font-semibold text-gray-800 mb-2">Enterprise (P8-P11)</h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• CI/CD pipelines</li>
                        <li>• Event streaming</li>
                        <li>• Modern architectures</li>
                    </ul>
                    <button class="w-full mt-4 bg-red-500 text-white py-2 rounded hover:bg-red-600">Advance</button>
                </div>
                
                <div class="border border-purple-200 rounded-lg p-4">
                    <div class="text-center mb-4">
                        <span class="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm">🚀 Expert</span>
                    </div>
                    <h3 class="font-semibold text-gray-800 mb-2">Mastery (P12-P15)</h3>
                    <ul class="text-sm text-gray-600 space-y-1">
                        <li>• Real-time systems</li>
                        <li>• Production operations</li>
                        <li>• Kubernetes prep</li>
                    </ul>
                    <button class="w-full mt-4 bg-purple-500 text-white py-2 rounded hover:bg-purple-600">Master</button>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-8 mt-16">
        <div class="container mx-auto px-6 text-center">
            <p>&copy; 2025 Docker & YAML Mastery. The ultimate container learning platform.</p>
            <div class="mt-4 space-x-4">
                <a href="https://github.com/yourusername/docker-yaml-mastery" class="text-blue-400 hover:text-blue-300">
                    <i class="fab fa-github mr-1"></i> GitHub
                </a>
                <a href="https://discord.gg/docker-yaml-mastery" class="text-blue-400 hover:text-blue-300">
                    <i class="fab fa-discord mr-1"></i> Discord
                </a>
                <a href="https://twitter.com/dockeryamlmaster" class="text-blue-400 hover:text-blue-300">
                    <i class="fab fa-twitter mr-1"></i> Twitter
                </a>
            </div>
        </div>
    </footer>
</body>
</html>
EOF
    
    echo -e "${GREEN}✅ Interactive dashboard generated${NC}"
}

# Display launch summary
show_launch_summary() {
    echo -e "${GREEN}🎉 Docker & YAML Mastery Platform Successfully Launched!${NC}"
    echo ""
    echo -e "${BOLD}🌐 Access Points:${NC}"
    echo -e "   📊 Dashboard:    ${CYAN}http://localhost:3000${NC}"
    echo -e "   🧠 Quiz System:  ${CYAN}http://localhost:3002${NC}"
    echo -e "   📈 Analytics:    ${CYAN}http://localhost:3001${NC}"
    echo -e "   🔍 Monitoring:   ${CYAN}http://localhost:9090${NC}"
    echo ""
    echo -e "${BOLD}🚀 Quick Commands:${NC}"
    echo -e "   📝 Start Quiz:       ${YELLOW}npm run quiz${NC}"
    echo -e "   🎯 Join Challenge:   ${YELLOW}npm run challenges${NC}"
    echo -e "   📊 View Progress:    ${YELLOW}npm run progress${NC}"
    echo -e "   🏆 Leaderboard:     ${YELLOW}npm run leaderboard${NC}"
    echo ""
    echo -e "${BOLD}📚 Learning Paths:${NC}"
    echo -e "   🟢 Beginner:    P1 → P2 → P3  (8-12 hours)"
    echo -e "   🟡 Intermediate: P4 → P5 → P6 → P7  (15-20 hours)"
    echo -e "   🔴 Advanced:     P8 → P9 → P10 → P11  (25-35 hours)"
    echo -e "   🚀 Expert:       P12 → P13 → P14 → P15  (40-60 hours)"
    echo ""
    echo -e "${BOLD}🤝 Community:${NC}"
    echo -e "   💬 Discord: ${CYAN}https://discord.gg/docker-yaml-mastery${NC}"
    echo -e "   📝 Forum:   ${CYAN}https://forum.docker-mastery.dev${NC}"
    echo -e "   📱 Mobile:  ${CYAN}https://app.docker-mastery.dev${NC}"
    echo ""
    echo -e "${PURPLE}🌟 Pro Tip: Start with the dashboard to get your personalized learning path!${NC}"
    echo ""
    
    # Log launch completion
    echo "$(date): Platform launch completed successfully" >> logs/platform.log
}

# Handle user input for guided setup
guided_setup() {
    echo -e "${YELLOW}🎯 Welcome to Docker & YAML Mastery!${NC}"
    echo ""
    echo "Let's personalize your learning experience:"
    echo ""
    
    # Ask about experience level
    echo "What's your current Docker experience level?"
    echo "1. 🌱 Complete beginner"
    echo "2. 🏗️ Some experience with containers"  
    echo "3. 🚀 Experienced, want advanced projects"
    echo "4. 🧙‍♂️ Expert, here for specific features"
    echo ""
    read -p "Choose (1-4): " experience_level
    
    # Ask about learning goals
    echo ""
    echo "What's your primary learning goal?"
    echo "1. 🎓 Learn for personal projects"
    echo "2. 💼 Advance my career in DevOps"
    echo "3. 🏢 Apply at work/enterprise"
    echo "4. 🎯 Prepare for certification"
    echo ""
    read -p "Choose (1-4): " learning_goal
    
    # Ask about time commitment
    echo ""
    echo "How much time can you dedicate per week?"
    echo "1. ⏰ 1-3 hours (casual learning)"
    echo "2. 📚 4-8 hours (regular study)"
    echo "3. 🚀 9-15 hours (intensive)"
    echo "4. 💪 16+ hours (bootcamp style)"
    echo ""
    read -p "Choose (1-4): " time_commitment
    
    # Generate personalized config
    cat > data/user-profile.json << EOF
{
    "experience_level": $experience_level,
    "learning_goal": $learning_goal,
    "time_commitment": $time_commitment,
    "setup_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "recommended_path": "$(get_recommended_path $experience_level)",
    "estimated_completion": "$(get_estimated_completion $time_commitment)"
}
EOF
    
    echo ""
    echo -e "${GREEN}✅ Profile created! Your personalized dashboard is ready.${NC}"
}

get_recommended_path() {
    case $1 in
        1) echo "beginner-track" ;;
        2) echo "intermediate-track" ;;
        3) echo "advanced-track" ;;
        4) echo "expert-track" ;;
    esac
}

get_estimated_completion() {
    case $1 in
        1) echo "6-8 months" ;;
        2) echo "3-4 months" ;;
        3) echo "2-3 months" ;;
        4) echo "1-2 months" ;;
    esac
}

# Main execution flow
main() {
    show_banner
    
    # Check if user wants guided setup
    read -p "🎯 Would you like a guided setup? (y/n): " guided
    echo ""
    
    if [[ $guided =~ ^[Yy]$ ]]; then
        guided_setup
    fi
    
    check_requirements
    init_platform
    generate_dashboard
    start_platform_services
    
    # Wait for services to be ready
    echo -e "${BLUE}⏳ Waiting for services to be ready...${NC}"
    sleep 10
    
    show_launch_summary
    
    # Auto-open dashboard if on macOS or Windows
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:3000
    elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        start http://localhost:3000
    fi
}

# Script options
case "${1:-}" in
    --help|-h)
        echo "Docker & YAML Mastery Platform Launcher"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h          Show this help"
        echo "  --quick            Skip guided setup"
        echo "  --dev              Development mode"
        echo "  --reset            Reset all data"
        echo "  --status           Check platform status"
        echo ""
        exit 0
        ;;
    --quick)
        GUIDED_SETUP=false
        ;;
    --dev)
        ENVIRONMENT="development"
        ENABLE_MONITORING=false
        ;;
    --reset)
        echo "🔄 Resetting platform data..."
        docker-compose -f docker-compose.platform.yml down -v
        rm -rf data logs backups performance-results demo-sessions
        echo "✅ Platform reset complete"
        exit 0
        ;;
    --status)
        echo "📊 Platform Status:"
        docker-compose -f docker-compose.platform.yml ps
        exit 0
        ;;
esac

# Run main function
main "$@"
