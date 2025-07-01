#!/bin/bash

# 🐳 Docker & YAML Mastery - Learning Platform Launcher
# This script sets up and launches the interactive learning environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🐳 Docker & YAML Mastery - Learning Platform              ║
║                                                               ║
║   From Zero to Production Hero                                ║
║   Interactive Learning • Hands-on Projects • Real Demos      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if running in learning mode
if [ "$1" = "--learning-mode" ]; then
    LEARNING_MODE=true
else
    LEARNING_MODE=false
fi

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check prerequisites
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        echo "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose."
        echo "Visit: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    # Check Node.js (for quiz system)
    if ! command -v node &> /dev/null; then
        print_warning "Node.js not found. Installing quiz system dependencies..."
        # Try to install Node.js via package manager
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y nodejs npm
        elif command -v yum &> /dev/null; then
            sudo yum install -y nodejs npm
        elif command -v brew &> /dev/null; then
            brew install node
        else
            print_error "Please install Node.js manually: https://nodejs.org/"
            exit 1
        fi
    fi
    
    print_success "All requirements satisfied!"
}

# Setup learning environment
setup_environment() {
    print_status "Setting up learning environment..."
    
    # Create necessary directories
    mkdir -p logs tmp progress
    
    # Install quiz system dependencies
    if [ -f "package.json" ]; then
        print_status "Installing quiz system dependencies..."
        npm install
    fi
    
    # Download additional resources
    if [ ! -f "tmp/resources_downloaded" ]; then
        print_status "Downloading additional learning resources..."
        
        # Download example datasets
        curl -o tmp/sample-data.json https://raw.githubusercontent.com/docker-yaml-mastery/resources/main/sample-data.json 2>/dev/null || true
        
        # Download cheat sheets
        curl -o tmp/docker-cheatsheet.pdf https://raw.githubusercontent.com/docker-yaml-mastery/resources/main/docker-cheatsheet.pdf 2>/dev/null || true
        
        touch tmp/resources_downloaded
    fi
    
    print_success "Environment setup complete!"
}

# Display learning menu
show_learning_menu() {
    echo -e "\n${PURPLE}🎯 Choose Your Learning Path:${NC}\n"
    
    echo "1. 🟢 Beginner Track (Weeks 1-2)"
    echo "   └── YAML Basics → Docker Fundamentals → Simple Projects"
    echo ""
    echo "2. 🟡 Intermediate Track (Weeks 3-4)"
    echo "   └── Multi-Container Apps → Databases → Microservices"
    echo ""
    echo "3. 🔴 Advanced Track (Weeks 5-6)"
    echo "   └── Production Systems → Monitoring → Data Pipelines"
    echo ""
    echo "4. 🚀 Expert Track (Week 7+)"
    echo "   └── Kubernetes Migration → GitOps → Advanced CI/CD"
    echo ""
    echo "5. 🧠 Take Interactive Quiz"
    echo "   └── Test your knowledge with instant feedback"
    echo ""
    echo "6. 🌐 Launch Live Demos"
    echo "   └── Experience applications without local setup"
    echo ""
    echo "7. 📊 View Progress Dashboard"
    echo "   └── Track your learning journey"
    echo ""
    echo "8. 🛠️ Project-Specific Learning"
    echo "   └── Jump to specific project (p1-p15)"
    echo ""
    echo "9. ⚙️ Setup Development Environment"
    echo "   └── Configure tools and IDE extensions"
    echo ""
    echo "0. ❌ Exit"
    echo ""
    echo -n -e "${CYAN}Enter your choice (0-9): ${NC}"
}

# Handle user choice
handle_choice() {
    local choice=$1
    
    case $choice in
        1)
            launch_beginner_track
            ;;
        2)
            launch_intermediate_track
            ;;
        3)
            launch_advanced_track
            ;;
        4)
            launch_expert_track
            ;;
        5)
            launch_quiz_system
            ;;
        6)
            launch_live_demos
            ;;
        7)
            show_progress_dashboard
            ;;
        8)
            launch_project_specific
            ;;
        9)
            setup_dev_environment
            ;;
        0)
            print_status "Thanks for using Docker & YAML Mastery! 🚀"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Please try again."
            ;;
    esac
}

# Launch beginner track
launch_beginner_track() {
    print_status "🟢 Starting Beginner Track..."
    
    echo -e "\n${GREEN}📚 Beginner Learning Path:${NC}"
    echo "1. YAML Fundamentals (basics/)"
    echo "2. Docker Basics (p1-p3)"
    echo "3. Interactive Quizzes"
    echo ""
    echo "Estimated time: 2 weeks"
    echo ""
    echo -n "Start with YAML basics? (y/n): "
    read -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        cd basics
        print_status "Opening YAML tutorial..."
        
        # Launch interactive YAML tutorial
        if command -v code &> /dev/null; then
            code hello.yaml
        else
            echo "Please open basics/hello.yaml in your preferred editor"
        fi
        
        # Take quiz after tutorial
        echo -n "Ready to take the YAML quiz? (y/n): "
        read -r quiz_response
        if [[ $quiz_response =~ ^[Yy]$ ]]; then
            node ../quizzes/quiz-runner.js beginner/yaml-basics
        fi
    fi
}

# Launch intermediate track
launch_intermediate_track() {
    print_status "🟡 Starting Intermediate Track..."
    
    echo -e "\n${YELLOW}🏗️ Intermediate Learning Path:${NC}"
    echo "1. Multi-Container Applications (p4-p6)"
    echo "2. Databases & Persistence (p7-p8)"
    echo "3. Production Concepts"
    echo ""
    echo "Prerequisites: Complete Beginner Track"
    echo ""
    echo -n "Start with multi-container project? (y/n): "
    read -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        cd p4
        print_status "Launching WordPress + MySQL project..."
        docker-compose up -d
        
        echo "WordPress is starting up..."
        echo "Access at: http://localhost:8080"
        echo "phpMyAdmin: http://localhost:8081"
        echo ""
        echo "Press Enter when ready to continue..."
        read
    fi
}

# Launch advanced track
launch_advanced_track() {
    print_status "🔴 Starting Advanced Track..."
    
    echo -e "\n${RED}⚡ Advanced Learning Path:${NC}"
    echo "1. Production Systems (p9-p12)"
    echo "2. Monitoring & Logging (p13-p14)"
    echo "3. Scalable Architectures (p15)"
    echo ""
    echo "Prerequisites: Complete Intermediate Track"
    echo ""
    echo -n "Start with production monitoring? (y/n): "
    read -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        cd p14
        print_status "Launching production monitoring stack..."
        docker-compose up -d
        
        echo "Monitoring stack is starting..."
        echo "Prometheus: http://localhost:9090"
        echo "Grafana: http://localhost:3000 (admin/admin)"
        echo ""
    fi
}

# Launch expert track
launch_expert_track() {
    print_status "🚀 Starting Expert Track..."
    
    echo -e "\n${PURPLE}🎓 Expert Learning Path:${NC}"
    echo "1. Kubernetes Migration (kubernetes/)"
    echo "2. GitOps & CI/CD (gitops/)"
    echo "3. Advanced Patterns"
    echo ""
    echo "Prerequisites: Complete Advanced Track"
    echo ""
    echo -n "Start Kubernetes migration guide? (y/n): "
    read -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        cd kubernetes
        print_status "Opening Kubernetes guide..."
        
        if command -v code &> /dev/null; then
            code README.md
        else
            echo "Please open kubernetes/README.md in your preferred editor"
        fi
    fi
}

# Launch quiz system
launch_quiz_system() {
    print_status "🧠 Launching Interactive Quiz System..."
    
    echo -e "\n${BLUE}Available Quizzes:${NC}"
    echo "1. YAML Basics"
    echo "2. Docker Fundamentals"
    echo "3. Docker Compose"
    echo "4. Production Concepts"
    echo "5. Kubernetes Basics"
    echo "6. Random Challenge"
    echo ""
    echo -n "Choose quiz (1-6): "
    read -r quiz_choice
    
    case $quiz_choice in
        1) node quizzes/quiz-runner.js beginner/yaml-basics ;;
        2) node quizzes/quiz-runner.js beginner/docker-fundamentals ;;
        3) node quizzes/quiz-runner.js intermediate/docker-compose ;;
        4) node quizzes/quiz-runner.js advanced/production ;;
        5) node quizzes/quiz-runner.js expert/kubernetes ;;
        6) node quizzes/quiz-runner.js random ;;
        *) print_error "Invalid choice" ;;
    esac
}

# Launch live demos
launch_live_demos() {
    print_status "🌐 Launching Live Demos..."
    
    echo -e "\n${CYAN}Available Demos:${NC}"
    echo "1. Simple Web App (p1) - Node.js + MongoDB"
    echo "2. Full-Stack App (p2) - React + Express + PostgreSQL"
    echo "3. WordPress Site (p4) - WordPress + MySQL"
    echo "4. Monitoring Stack (p14) - Prometheus + Grafana"
    echo ""
    echo -n "Choose demo (1-4): "
    read -r demo_choice
    
    case $demo_choice in
        1)
            cd p1
            docker-compose up -d
            print_success "Demo available at: http://localhost:3000"
            ;;
        2)
            cd p2
            docker-compose up -d
            print_success "Frontend: http://localhost:3000, API: http://localhost:5000"
            ;;
        4)
            cd p14
            docker-compose up -d
            print_success "Prometheus: http://localhost:9090, Grafana: http://localhost:3000"
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
}

# Show progress dashboard
show_progress_dashboard() {
    print_status "📊 Loading Progress Dashboard..."
    
    # Create simple progress file if doesn't exist
    if [ ! -f "progress/user_progress.json" ]; then
        echo '{"beginner": 0, "intermediate": 0, "advanced": 0, "expert": 0}' > progress/user_progress.json
    fi
    
    echo -e "\n${GREEN}🎯 Your Learning Progress:${NC}"
    echo "=================================="
    echo ""
    echo "🟢 Beginner Track: 0% Complete"
    echo "🟡 Intermediate Track: 0% Complete"
    echo "🔴 Advanced Track: 0% Complete"
    echo "🚀 Expert Track: 0% Complete"
    echo ""
    echo "🏆 Achievements Unlocked:"
    echo "- Getting Started 🎉"
    echo ""
    echo "📈 Next Milestone: Complete YAML Basics Quiz"
    echo "💡 Recommendation: Start with basics/ folder"
    echo ""
    echo "Press Enter to continue..."
    read
}

# Launch project-specific learning
launch_project_specific() {
    print_status "🛠️ Project-Specific Learning..."
    
    echo -e "\n${YELLOW}Choose a project (1-15):${NC}"
    echo "p1-p3: Foundation Projects"
    echo "p4-p8: Application Projects"
    echo "p9-p12: Production Projects"
    echo "p13-p15: Enterprise Projects"
    echo ""
    echo -n "Enter project number (1-15): "
    read -r project_num
    
    if [[ $project_num =~ ^[0-9]+$ ]] && [ $project_num -ge 1 ] && [ $project_num -le 15 ]; then
        project_dir="p$project_num"
        if [ -d "$project_dir" ]; then
            cd "$project_dir"
            print_status "Launching project $project_num..."
            
            if [ -f "docker-compose.yml" ]; then
                docker-compose up -d
                print_success "Project $project_num is running!"
                
                # Show project-specific info
                case $project_num in
                    1) echo "Access at: http://localhost:3000" ;;
                    2) echo "Frontend: http://localhost:3000, API: http://localhost:5000" ;;
                    4) echo "WordPress: http://localhost:8080" ;;
                    6) echo "Django: http://localhost:8000, Flower: http://localhost:5555" ;;
                    *) echo "Check the project README for access URLs" ;;
                esac
            else
                print_warning "No docker-compose.yml found in $project_dir"
            fi
        else
            print_error "Project $project_dir not found"
        fi
    else
        print_error "Invalid project number"
    fi
}

# Setup development environment
setup_dev_environment() {
    print_status "⚙️ Setting up Development Environment..."
    
    echo -e "\n${CYAN}Development Environment Setup:${NC}"
    echo "1. Install VS Code extensions"
    echo "2. Configure shell aliases"
    echo "3. Setup git hooks"
    echo "4. Install additional tools"
    echo ""
    echo -n "Proceed with setup? (y/n): "
    read -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        # Install VS Code extensions
        if command -v code &> /dev/null; then
            print_status "Installing VS Code extensions..."
            code --install-extension ms-vscode.vscode-docker
            code --install-extension redhat.vscode-yaml
            code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
            print_success "VS Code extensions installed!"
        fi
        
        # Setup shell aliases
        echo "alias dcup='docker-compose up -d'" >> ~/.bashrc
        echo "alias dcdown='docker-compose down'" >> ~/.bashrc
        echo "alias dcps='docker-compose ps'" >> ~/.bashrc
        echo "alias dclogs='docker-compose logs -f'" >> ~/.bashrc
        
        print_success "Development environment setup complete!"
    fi
}

# Main execution
main() {
    clear
    
    # Check if running in CI/automated mode
    if [ "$CI" = "true" ] || [ "$AUTOMATED" = "true" ]; then
        print_status "Running in automated mode"
        check_requirements
        setup_environment
        exit 0
    fi
    
    # Interactive mode
    check_requirements
    setup_environment
    
    if [ "$LEARNING_MODE" = "true" ]; then
        # Direct learning mode
        launch_beginner_track
    else
        # Interactive menu mode
        while true; do
            show_learning_menu
            read -r choice
            echo ""
            handle_choice "$choice"
            echo ""
            echo "Press Enter to continue..."
            read
            clear
        done
    fi
}

# Run main function
main "$@"
