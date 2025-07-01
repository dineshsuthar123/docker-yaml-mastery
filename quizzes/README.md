# 🧠 Interactive Quizzes & Assessments

Test your Docker & YAML knowledge with progressive quizzes and hands-on challenges.

## 📊 Quiz System Overview

### 🎯 **Learning Assessments**
- **Project Quizzes** (p1-p15) - Test specific concepts
- **Track Assessments** (Beginner, Intermediate, Advanced) - Comprehensive evaluations
- **Practical Challenges** - Hands-on coding exercises
- **Kubernetes Readiness** - Migration preparation

### 🏆 **Achievement System**
- 🥉 **Bronze** - 70%+ score, basic understanding
- 🥈 **Silver** - 85%+ score, good proficiency  
- 🥇 **Gold** - 95%+ score, expert level
- ⭐ **Platinum** - 100% + bonus challenges

## 📚 Quiz Categories

### 🟢 Beginner Track
- [YAML Basics Quiz](./beginner/yaml-basics.md)
- [Docker Fundamentals Quiz](./beginner/docker-fundamentals.md)
- [Project p1-p3 Assessment](./beginner/foundation-assessment.md)

### 🟡 Intermediate Track  
- [Multi-Container Apps Quiz](./intermediate/multi-container.md)
- [Networking & Volumes Quiz](./intermediate/networking-volumes.md)
- [Project p4-p8 Assessment](./intermediate/application-assessment.md)

### 🔴 Advanced Track
- [Production Systems Quiz](./advanced/production-systems.md)
- [Monitoring & Security Quiz](./advanced/monitoring-security.md)
- [Project p9-p15 Assessment](./advanced/enterprise-assessment.md)

### 🚀 Expert Track
- [Kubernetes Migration Quiz](./expert/kubernetes-migration.md)
- [GitOps & CI/CD Quiz](./expert/gitops-cicd.md)
- [Capstone Challenge](./expert/capstone-challenge.md)

## 🎮 How to Take Quizzes

### Method 1: Interactive CLI
```bash
# Navigate to project directory
cd docker-yaml-mastery

# Take a specific quiz
npm run quiz beginner/yaml-basics

# Take project-specific quiz
npm run quiz:project p6

# Take full assessment
npm run assessment intermediate
```

### Method 2: Web Interface
```bash
# Start quiz server
npm run quiz:server

# Open browser to http://localhost:3001
# Select your quiz and difficulty level
```

### Method 3: GitHub Integration
- Quizzes auto-run on PR submissions
- Results posted as PR comments
- Achievement badges updated automatically

## 📋 Quiz Format Examples

### Multiple Choice
```yaml
question: "What is the correct way to expose a port in Docker Compose?"
type: "multiple-choice"
options:
  - "expose: 3000"
  - "ports: 3000"
  - "ports: ['3000:3000']"
  - "port: 3000:3000"
correct: 2
explanation: "The correct syntax is ports: ['3000:3000'] or ports: - '3000:3000'"
difficulty: "beginner"
tags: ["docker-compose", "networking"]
```

### Code Completion
```yaml
question: "Complete the Docker Compose service definition"
type: "code-completion"
template: |
  services:
    web:
      image: nginx
      ___: 
        - "80:80"
      ___:
        - ./html:/usr/share/nginx/html
answer: |
  services:
    web:
      image: nginx
      ports: 
        - "80:80"
      volumes:
        - ./html:/usr/share/nginx/html
difficulty: "intermediate"
```

### Practical Challenge
```yaml
question: "Create a Docker Compose file for a Django app with PostgreSQL"
type: "practical"
requirements:
  - "Django service with custom Dockerfile"
  - "PostgreSQL database with environment variables"
  - "Named volumes for data persistence"
  - "Network isolation"
  - "Health checks for both services"
time_limit: 1800  # 30 minutes
auto_test: true
test_script: "./tests/validate-django-postgres.sh"
```

## 🎯 Scoring System

### Individual Questions
- **Correct First Try**: 100 points
- **Correct Second Try**: 75 points  
- **Correct Third Try**: 50 points
- **Hint Used**: -10 points
- **Wrong Answer**: 0 points

### Bonus Points
- **Speed Bonus**: +20 points (under 30 seconds)
- **No Hints**: +10 points per question
- **Perfect Section**: +50 points
- **Streak Bonus**: +5 points per consecutive correct

### Achievement Thresholds
- 🥉 **Bronze**: 700+ points (70%)
- 🥈 **Silver**: 850+ points (85%)
- 🥇 **Gold**: 950+ points (95%)
- ⭐ **Platinum**: 1000 points (100% + bonuses)

## 📊 Progress Tracking

### Personal Dashboard
```bash
# View your progress
npm run progress

# Example output:
# 🎯 Docker & YAML Mastery Progress
# ================================
# 
# 🟢 Beginner Track: 100% Complete 🥇
# 🟡 Intermediate Track: 60% Complete 🥈  
# 🔴 Advanced Track: 20% Complete
# 🚀 Expert Track: Not Started
#
# 🏆 Achievements Unlocked:
# - YAML Master 🥇
# - Docker Developer 🥈
# - Multi-Container Expert 🥉
#
# 📈 Next Milestone: Production Engineer
# Recommended: Complete p9-p12 projects
```

### Leaderboard
```bash
# View community leaderboard
npm run leaderboard

# Weekly challenges
npm run challenges
```

## 🧪 Quiz Development

### Creating New Quizzes
```bash
# Generate quiz template
npm run create:quiz "Kubernetes Basics"

# Validate quiz format
npm run validate:quiz kubernetes-basics.yaml

# Test quiz locally
npm run test:quiz kubernetes-basics.yaml
```

### Quiz Structure
```yaml
metadata:
  title: "Docker Networking Fundamentals"
  description: "Test your understanding of Docker networking concepts"
  difficulty: "intermediate"
  estimated_time: 15
  topics: ["networking", "docker-compose", "containers"]
  prerequisites: ["docker-basics", "yaml-fundamentals"]

questions:
  - question: "What is the default network driver in Docker?"
    type: "multiple-choice"
    # ... question details
    
  - question: "Create a custom bridge network"
    type: "practical"
    # ... challenge details

scoring:
  total_points: 1000
  pass_threshold: 700
  time_bonus: true
  hints_penalty: 10

feedback:
  correct: "Great job! You understand Docker networking."
  partial: "Good effort! Review the networking documentation."
  needs_improvement: "Consider reviewing the basics before retrying."
```

## 🎓 Certification Integration

### Earning Certificates
1. **Complete All Track Quizzes** - 70%+ average score
2. **Pass Major Assessment** - Track-specific evaluation
3. **Submit Portfolio Project** - Practical demonstration
4. **Peer Review** - Community validation

### Certificate Verification
- **Blockchain-verified** digital certificates
- **LinkedIn integration** for professional profiles
- **GitHub badges** for repository profiles
- **Portable credentials** for job applications

## 🔄 Continuous Learning

### Adaptive Learning
- **Personalized recommendations** based on quiz performance
- **Difficulty adjustment** based on success rate
- **Content suggestions** for knowledge gaps
- **Practice problems** for weak areas

### Community Features
- **Study groups** formation based on skill level
- **Peer challenges** and collaborative quizzes
- **Discussion forums** for each quiz topic
- **Mentor matching** for guided learning

## 🚀 Getting Started

```bash
# Install quiz dependencies
npm install

# Take your first quiz
npm run quiz beginner/yaml-basics

# Start your learning journey!
npm run learning:start
```

Ready to test your Docker & YAML knowledge? Start with the [YAML Basics Quiz](./beginner/yaml-basics.md)!
