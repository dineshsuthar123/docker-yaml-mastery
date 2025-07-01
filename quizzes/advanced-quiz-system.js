#!/usr/bin/env node

/**
 * 🧠 Advanced Interactive Quiz System
 * Gamified learning platform with achievements, leaderboards, and adaptive difficulty
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
const crypto = require('crypto');

// Quiz configuration
const QUIZ_CONFIG = {
    baseDir: 'quizzes',
    userDataFile: 'quiz-data/users.json',
    leaderboardFile: 'quiz-data/leaderboard.json',
    achievementsFile: 'quiz-data/achievements.json',
    questionsDir: 'quiz-data/questions'
};

// Difficulty levels
const DIFFICULTY = {
    BEGINNER: 1,
    INTERMEDIATE: 2,
    ADVANCED: 3,
    EXPERT: 4
};

// Achievement types
const ACHIEVEMENTS = {
    FIRST_QUIZ: { name: "First Steps", description: "Completed your first quiz", points: 10 },
    PERFECT_SCORE: { name: "Perfectionist", description: "Got 100% on a quiz", points: 50 },
    STREAK_5: { name: "On Fire", description: "5 correct answers in a row", points: 25 },
    STREAK_10: { name: "Unstoppable", description: "10 correct answers in a row", points: 75 },
    DOCKER_MASTER: { name: "Docker Master", description: "Completed all Docker quizzes", points: 100 },
    YAML_GURU: { name: "YAML Guru", description: "Completed all YAML quizzes", points: 100 },
    SPEED_DEMON: { name: "Speed Demon", description: "Answered 10 questions in under 5 minutes", points: 30 },
    COMEBACK_KID: { name: "Comeback Kid", description: "Improved score by 50% on retake", points: 40 }
};

class QuizSystem {
    constructor() {
        this.rl = readline.createInterface({
            input: process.stdin,
            output: process.stdout
        });

        this.currentUser = null;
        this.currentQuiz = null;
        this.questionStartTime = null;
        this.streak = 0;
        this.totalTime = 0;
        this.correctAnswers = 0;

        this.initializeDataStructures();
    }

    initializeDataStructures() {
        // Create data directories if they don't exist
        const dirs = ['quiz-data', 'quiz-data/questions', 'quiz-data/backups'];
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });

        // Initialize data files
        this.users = this.loadJsonFile(QUIZ_CONFIG.userDataFile, {});
        this.leaderboard = this.loadJsonFile(QUIZ_CONFIG.leaderboardFile, []);
        this.achievements = this.loadJsonFile(QUIZ_CONFIG.achievementsFile, {});
    }

    loadJsonFile(filepath, defaultValue) {
        try {
            if (fs.existsSync(filepath)) {
                return JSON.parse(fs.readFileSync(filepath, 'utf8'));
            }
        } catch (error) {
            console.log(`Warning: Could not load ${filepath}, using default value`);
        }
        return defaultValue;
    }

    saveJsonFile(filepath, data) {
        try {
            fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
            return true;
        } catch (error) {
            console.error(`Error saving ${filepath}:`, error.message);
            return false;
        }
    }

    async showWelcome() {
        console.clear();
        console.log(`
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🧠 Docker & YAML Mastery - Interactive Quiz System        ║
║                                                              ║
║   Test your knowledge • Earn achievements • Climb rankings  ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
        `);

        await this.getUserInfo();
        await this.showMainMenu();
    }

    async getUserInfo() {
        const username = await this.askQuestion('Enter your username (or press Enter for guest): ');

        if (username.trim()) {
            this.currentUser = username.trim();

            if (!this.users[this.currentUser]) {
                this.users[this.currentUser] = {
                    name: this.currentUser,
                    totalScore: 0,
                    totalQuizzes: 0,
                    averageScore: 0,
                    achievements: [],
                    quizHistory: [],
                    joinDate: new Date().toISOString(),
                    lastActive: new Date().toISOString()
                };
                console.log(`\n🎉 Welcome to Docker & YAML Mastery, ${this.currentUser}!`);
                await this.grantAchievement('FIRST_QUIZ');
            } else {
                this.users[this.currentUser].lastActive = new Date().toISOString();
                console.log(`\n👋 Welcome back, ${this.currentUser}!`);
                console.log(`📊 Your stats: ${this.users[this.currentUser].totalQuizzes} quizzes, ${this.users[this.currentUser].averageScore.toFixed(1)}% average`);
            }

            this.saveJsonFile(QUIZ_CONFIG.userDataFile, this.users);
        } else {
            this.currentUser = 'guest';
            console.log('\n👤 Playing as guest (progress will not be saved)');
        }
    }

    async showMainMenu() {
        console.log(`
📚 Main Menu:
1. 🟢 Beginner Quizzes (YAML Basics, Docker Fundamentals)
2. 🟡 Intermediate Quizzes (Multi-container, Networking)
3. 🔴 Advanced Quizzes (Production, Security, Performance)
4. 🚀 Expert Challenges (Kubernetes, CI/CD, Architecture)
5. 📊 View Leaderboard
6. 🏆 View Achievements
7. 📈 Personal Stats
8. 🎯 Weekly Challenge
9. 🔄 Adaptive Quiz (AI-powered difficulty)
10. ❌ Exit
        `);

        const choice = await this.askQuestion('Select an option (1-10): ');
        await this.handleMainMenuChoice(choice);
    }

    async handleMainMenuChoice(choice) {
        switch (choice) {
            case '1':
                await this.showQuizCategory('beginner');
                break;
            case '2':
                await this.showQuizCategory('intermediate');
                break;
            case '3':
                await this.showQuizCategory('advanced');
                break;
            case '4':
                await this.showQuizCategory('expert');
                break;
            case '5':
                await this.showLeaderboard();
                break;
            case '6':
                await this.showAchievements();
                break;
            case '7':
                await this.showPersonalStats();
                break;
            case '8':
                await this.startWeeklyChallenge();
                break;
            case '9':
                await this.startAdaptiveQuiz();
                break;
            case '10':
                console.log('\n👋 Thanks for learning with Docker & YAML Mastery!');
                this.rl.close();
                return;
            default:
                console.log('\n❌ Invalid choice. Please try again.');
                await this.showMainMenu();
        }
    }

    async showQuizCategory(category) {
        const quizzes = this.getQuizzesForCategory(category);

        console.log(`\n📖 ${category.toUpperCase()} Quizzes:`);
        quizzes.forEach((quiz, index) => {
            const userProgress = this.getUserQuizProgress(quiz.id);
            const status = userProgress ? `✅ ${userProgress.bestScore}%` : '⭕ Not attempted';
            console.log(`${index + 1}. ${quiz.title} ${status}`);
        });

        const choice = await this.askQuestion('\nSelect a quiz (number) or 0 to go back: ');

        if (choice === '0') {
            await this.showMainMenu();
            return;
        }

        const quizIndex = parseInt(choice) - 1;
        if (quizIndex >= 0 && quizIndex < quizzes.length) {
            await this.startQuiz(quizzes[quizIndex]);
        } else {
            console.log('❌ Invalid choice.');
            await this.showQuizCategory(category);
        }
    }

    getQuizzesForCategory(category) {
        // Mock quiz data - in a real implementation, this would load from files
        const quizzes = {
            beginner: [
                { id: 'yaml-basics', title: 'YAML Basics', questions: this.generateYAMLBasicsQuestions() },
                { id: 'docker-fundamentals', title: 'Docker Fundamentals', questions: this.generateDockerFundamentalsQuestions() },
                { id: 'containers-101', title: 'Containers 101', questions: this.generateContainers101Questions() }
            ],
            intermediate: [
                { id: 'multi-container', title: 'Multi-Container Applications', questions: this.generateMultiContainerQuestions() },
                { id: 'networking', title: 'Docker Networking', questions: this.generateNetworkingQuestions() },
                { id: 'volumes-storage', title: 'Volumes & Storage', questions: this.generateVolumesQuestions() }
            ],
            advanced: [
                { id: 'production-deployment', title: 'Production Deployment', questions: this.generateProductionQuestions() },
                { id: 'security-hardening', title: 'Security & Hardening', questions: this.generateSecurityQuestions() },
                { id: 'performance-optimization', title: 'Performance Optimization', questions: this.generatePerformanceQuestions() }
            ],
            expert: [
                { id: 'kubernetes-migration', title: 'Kubernetes Migration', questions: this.generateKubernetesQuestions() },
                { id: 'cicd-integration', title: 'CI/CD Integration', questions: this.generateCICDQuestions() },
                { id: 'microservices-architecture', title: 'Microservices Architecture', questions: this.generateMicroservicesQuestions() }
            ]
        };

        return quizzes[category] || [];
    }

    async startQuiz(quiz) {
        console.log(`\n🎯 Starting quiz: ${quiz.title}`);
        console.log(`📝 ${quiz.questions.length} questions`);

        this.currentQuiz = quiz;
        this.streak = 0;
        this.correctAnswers = 0;
        this.totalTime = 0;

        const startTime = Date.now();

        for (let i = 0; i < quiz.questions.length; i++) {
            const question = quiz.questions[i];
            const isCorrect = await this.askQuizQuestion(question, i + 1, quiz.questions.length);

            if (isCorrect) {
                this.correctAnswers++;
                this.streak++;

                // Check for streak achievements
                if (this.streak === 5) await this.grantAchievement('STREAK_5');
                if (this.streak === 10) await this.grantAchievement('STREAK_10');
            } else {
                this.streak = 0;
            }
        }

        const endTime = Date.now();
        this.totalTime = Math.round((endTime - startTime) / 1000);

        await this.showQuizResults(quiz);
    }

    async askQuizQuestion(question, current, total) {
        this.questionStartTime = Date.now();

        console.log(`\n📝 Question ${current}/${total}:`);
        console.log(`${question.question}\n`);

        question.options.forEach((option, index) => {
            console.log(`${String.fromCharCode(65 + index)}. ${option}`);
        });

        const answer = await this.askQuestion('\nYour answer (A, B, C, or D): ');
        const answerIndex = answer.toUpperCase().charCodeAt(0) - 65;

        const isCorrect = answerIndex === question.correct;

        if (isCorrect) {
            console.log('✅ Correct!');
            if (question.explanation) {
                console.log(`💡 ${question.explanation}`);
            }
        } else {
            console.log(`❌ Incorrect. The correct answer is ${String.fromCharCode(65 + question.correct)}.`);
            if (question.explanation) {
                console.log(`💡 ${question.explanation}`);
            }
        }

        // Add small delay for better UX
        await new Promise(resolve => setTimeout(resolve, 1500));

        return isCorrect;
    }

    async showQuizResults(quiz) {
        const score = Math.round((this.correctAnswers / quiz.questions.length) * 100);

        console.log(`\n🎉 Quiz Complete: ${quiz.title}`);
        console.log(`📊 Score: ${score}% (${this.correctAnswers}/${quiz.questions.length})`);
        console.log(`⏱️  Time: ${this.totalTime} seconds`);
        console.log(`🔥 Best streak: ${this.streak}`);

        // Grant achievements
        if (score === 100) await this.grantAchievement('PERFECT_SCORE');
        if (this.totalTime < 300 && quiz.questions.length >= 10) await this.grantAchievement('SPEED_DEMON');

        // Save user progress
        if (this.currentUser !== 'guest') {
            await this.saveQuizProgress(quiz, score);
        }

        // Show grade
        let grade, emoji;
        if (score >= 90) { grade = 'A+'; emoji = '🥇'; }
        else if (score >= 80) { grade = 'A'; emoji = '🥈'; }
        else if (score >= 70) { grade = 'B'; emoji = '🥉'; }
        else if (score >= 60) { grade = 'C'; emoji = '📚'; }
        else { grade = 'F'; emoji = '💪'; }

        console.log(`\n${emoji} Grade: ${grade}`);

        const again = await this.askQuestion('\n🔄 Take this quiz again? (y/n): ');
        if (again.toLowerCase() === 'y') {
            await this.startQuiz(quiz);
        } else {
            await this.showMainMenu();
        }
    }

    async saveQuizProgress(quiz, score) {
        const quizData = {
            quizId: quiz.id,
            score: score,
            time: this.totalTime,
            date: new Date().toISOString(),
            correctAnswers: this.correctAnswers,
            totalQuestions: quiz.questions.length
        };

        this.users[this.currentUser].quizHistory.push(quizData);
        this.users[this.currentUser].totalQuizzes++;
        this.users[this.currentUser].totalScore += score;
        this.users[this.currentUser].averageScore = this.users[this.currentUser].totalScore / this.users[this.currentUser].totalQuizzes;

        // Update leaderboard
        this.updateLeaderboard();

        this.saveJsonFile(QUIZ_CONFIG.userDataFile, this.users);
    }

    updateLeaderboard() {
        const userEntry = {
            username: this.currentUser,
            totalScore: this.users[this.currentUser].totalScore,
            averageScore: this.users[this.currentUser].averageScore,
            totalQuizzes: this.users[this.currentUser].totalQuizzes,
            achievements: this.users[this.currentUser].achievements.length
        };

        // Remove existing entry
        this.leaderboard = this.leaderboard.filter(entry => entry.username !== this.currentUser);

        // Add updated entry
        this.leaderboard.push(userEntry);

        // Sort by average score, then by total quizzes
        this.leaderboard.sort((a, b) => {
            if (b.averageScore !== a.averageScore) {
                return b.averageScore - a.averageScore;
            }
            return b.totalQuizzes - a.totalQuizzes;
        });

        this.saveJsonFile(QUIZ_CONFIG.leaderboardFile, this.leaderboard);
    }

    async grantAchievement(achievementKey) {
        if (!this.currentUser || this.currentUser === 'guest') return;

        const achievement = ACHIEVEMENTS[achievementKey];
        if (!achievement) return;

        const userAchievements = this.users[this.currentUser].achievements;

        // Check if already has this achievement
        if (userAchievements.some(a => a.key === achievementKey)) return;

        // Grant achievement
        const achievementData = {
            key: achievementKey,
            name: achievement.name,
            description: achievement.description,
            points: achievement.points,
            dateEarned: new Date().toISOString()
        };

        userAchievements.push(achievementData);

        console.log(`\n🏆 Achievement Unlocked: ${achievement.name}`);
        console.log(`💎 ${achievement.description} (+${achievement.points} points)`);

        this.saveJsonFile(QUIZ_CONFIG.userDataFile, this.users);
    }

    async showLeaderboard() {
        console.log('\n🏆 Docker & YAML Mastery Leaderboard\n');
        console.log('Rank | Username          | Avg Score | Quizzes | Achievements');
        console.log('-----|-------------------|-----------|---------|-------------');

        this.leaderboard.slice(0, 10).forEach((entry, index) => {
            const rank = (index + 1).toString().padStart(4);
            const username = entry.username.substring(0, 17).padEnd(17);
            const avgScore = entry.averageScore.toFixed(1).padStart(9);
            const quizzes = entry.totalQuizzes.toString().padStart(7);
            const achievements = entry.achievements.toString().padStart(11);

            console.log(`${rank} | ${username} | ${avgScore}% | ${quizzes} | ${achievements}`);
        });

        await this.askQuestion('\nPress Enter to continue...');
        await this.showMainMenu();
    }

    // Mock question generators (in a real implementation, these would load from files)
    generateYAMLBasicsQuestions() {
        return [
            {
                question: "What does YAML stand for?",
                options: ["Yet Another Markup Language", "YAML Ain't Markup Language", "Young Adult Modern Language", "Youthful Agile Markup Language"],
                correct: 1,
                explanation: "YAML is a recursive acronym that stands for 'YAML Ain't Markup Language'."
            },
            {
                question: "Which character is used for comments in YAML?",
                options: ["//", "#", "/*", "--"],
                correct: 1,
                explanation: "YAML uses the # character for comments, just like many shell scripting languages."
            }
        ];
    }

    generateDockerFundamentalsQuestions() {
        return [
            {
                question: "What is the main purpose of Docker?",
                options: ["Virtual machines", "Container orchestration", "Application containerization", "Database management"],
                correct: 2,
                explanation: "Docker's main purpose is application containerization - packaging applications with their dependencies."
            }
        ];
    }

    generateContainers101Questions() {
        return [
            {
                question: "What is a Docker image?",
                options: ["A running container", "A blueprint for containers", "A network configuration", "A volume mount"],
                correct: 1,
                explanation: "A Docker image is a blueprint or template used to create containers."
            }
        ];
    }

    generateMultiContainerQuestions() {
        return [
            {
                question: "What tool is commonly used to orchestrate multiple Docker containers?",
                options: ["Docker Swarm", "Docker Compose", "Docker Machine", "Docker Network"],
                correct: 1,
                explanation: "Docker Compose is the standard tool for defining and running multi-container Docker applications."
            }
        ];
    }

    generateNetworkingQuestions() {
        return [
            {
                question: "What is the default network driver in Docker?",
                options: ["host", "bridge", "overlay", "macvlan"],
                correct: 1,
                explanation: "The bridge network driver is the default network driver for standalone containers."
            }
        ];
    }

    generateVolumesQuestions() {
        return [
            {
                question: "What is the recommended way to persist data in Docker?",
                options: ["Bind mounts", "Volumes", "tmpfs mounts", "Copy files"],
                correct: 1,
                explanation: "Docker volumes are the recommended way to persist data as they are managed by Docker and work across platforms."
            }
        ];
    }

    generateProductionQuestions() {
        return [
            {
                question: "What should you avoid in production Docker images?",
                options: ["Multi-stage builds", "Running as root user", "Health checks", "Resource limits"],
                correct: 1,
                explanation: "Running containers as root user is a security risk and should be avoided in production."
            }
        ];
    }

    generateSecurityQuestions() {
        return [
            {
                question: "What tool can scan Docker images for vulnerabilities?",
                options: ["Docker Bench", "Trivy", "Hadolint", "All of the above"],
                correct: 3,
                explanation: "All of these tools can help with Docker security - Trivy for vulnerability scanning, Hadolint for Dockerfile linting, and Docker Bench for security benchmarks."
            }
        ];
    }

    generatePerformanceQuestions() {
        return [
            {
                question: "What is the benefit of multi-stage Docker builds?",
                options: ["Faster builds", "Smaller images", "Better security", "All of the above"],
                correct: 3,
                explanation: "Multi-stage builds provide faster builds, smaller final images, and better security by excluding build tools from the final image."
            }
        ];
    }

    generateKubernetesQuestions() {
        return [
            {
                question: "What Kubernetes object is equivalent to docker-compose.yml?",
                options: ["Pod", "Deployment", "Service", "ConfigMap"],
                correct: 1,
                explanation: "A Deployment in Kubernetes manages the deployment and scaling of applications, similar to docker-compose.yml."
            }
        ];
    }

    generateCICDQuestions() {
        return [
            {
                question: "What is the benefit of using Docker in CI/CD pipelines?",
                options: ["Consistent environments", "Faster deployments", "Better testing", "All of the above"],
                correct: 3,
                explanation: "Docker provides consistent environments, enables faster deployments, and improves testing reliability in CI/CD pipelines."
            }
        ];
    }

    generateMicroservicesQuestions() {
        return [
            {
                question: "What pattern is commonly used for service-to-service communication?",
                options: ["Direct HTTP calls", "Message queues", "Service mesh", "All of the above"],
                correct: 3,
                explanation: "Microservices can communicate via direct HTTP calls, message queues, or through a service mesh, depending on requirements."
            }
        ];
    }

    getUserQuizProgress(quizId) {
        if (!this.currentUser || this.currentUser === 'guest') return null;

        const history = this.users[this.currentUser].quizHistory;
        const quizAttempts = history.filter(attempt => attempt.quizId === quizId);

        if (quizAttempts.length === 0) return null;

        const bestScore = Math.max(...quizAttempts.map(attempt => attempt.score));
        return { bestScore, attempts: quizAttempts.length };
    }

    async showPersonalStats() {
        if (this.currentUser === 'guest') {
            console.log('\n📊 Personal stats are not available for guest users.');
            await this.askQuestion('Press Enter to continue...');
            await this.showMainMenu();
            return;
        }

        const user = this.users[this.currentUser];

        console.log(`\n📊 Personal Stats for ${user.name}`);
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        console.log(`🎯 Total Quizzes: ${user.totalQuizzes}`);
        console.log(`📈 Average Score: ${user.averageScore.toFixed(1)}%`);
        console.log(`🏆 Achievements: ${user.achievements.length}`);
        console.log(`📅 Member Since: ${new Date(user.joinDate).toLocaleDateString()}`);
        console.log(`🕒 Last Active: ${new Date(user.lastActive).toLocaleDateString()}`);

        if (user.achievements.length > 0) {
            console.log('\n🏆 Recent Achievements:');
            user.achievements.slice(-3).forEach(achievement => {
                console.log(`   ${achievement.name} - ${achievement.description}`);
            });
        }

        await this.askQuestion('\nPress Enter to continue...');
        await this.showMainMenu();
    }

    async showAchievements() {
        console.log('\n🏆 Available Achievements\n');

        Object.entries(ACHIEVEMENTS).forEach(([key, achievement]) => {
            const earned = this.currentUser !== 'guest' &&
                this.users[this.currentUser].achievements.some(a => a.key === key);
            const status = earned ? '✅' : '⭕';
            console.log(`${status} ${achievement.name} (${achievement.points} pts)`);
            console.log(`   ${achievement.description}\n`);
        });

        await this.askQuestion('Press Enter to continue...');
        await this.showMainMenu();
    }

    async startWeeklyChallenge() {
        console.log('\n🎯 Weekly Challenge: Docker Security Hardening');
        console.log('Complete this challenge to earn bonus points!');

        // Mock weekly challenge
        const challenge = {
            title: "Secure a Docker Application",
            description: "Review the provided Dockerfile and identify 5 security issues",
            questions: [
                {
                    question: "What's wrong with 'USER root' in a production Dockerfile?",
                    options: ["Nothing", "Security risk", "Performance issue", "Compatibility problem"],
                    correct: 1,
                    explanation: "Running as root gives unnecessary privileges and is a security risk."
                }
            ]
        };

        await this.startQuiz(challenge);
    }

    async startAdaptiveQuiz() {
        console.log('\n🤖 Adaptive Quiz - AI-Powered Difficulty Adjustment');
        console.log('This quiz adapts to your skill level based on your performance.');

        // Mock adaptive quiz logic
        const userLevel = this.getUserSkillLevel();
        const adaptiveQuiz = {
            title: `Adaptive Quiz (Level: ${userLevel})`,
            questions: this.generateAdaptiveQuestions(userLevel)
        };

        await this.startQuiz(adaptiveQuiz);
    }

    getUserSkillLevel() {
        if (this.currentUser === 'guest') return 'Beginner';

        const user = this.users[this.currentUser];
        if (user.averageScore >= 90) return 'Expert';
        if (user.averageScore >= 75) return 'Advanced';
        if (user.averageScore >= 60) return 'Intermediate';
        return 'Beginner';
    }

    generateAdaptiveQuestions(level) {
        // Return questions based on skill level
        const questionSets = {
            'Beginner': this.generateYAMLBasicsQuestions(),
            'Intermediate': this.generateMultiContainerQuestions(),
            'Advanced': this.generateProductionQuestions(),
            'Expert': this.generateKubernetesQuestions()
        };

        return questionSets[level] || this.generateYAMLBasicsQuestions();
    }

    askQuestion(prompt) {
        return new Promise((resolve) => {
            this.rl.question(prompt, (answer) => {
                resolve(answer);
            });
        });
    }
}

// Start the quiz system
const quizSystem = new QuizSystem();
quizSystem.showWelcome().catch(console.error);
