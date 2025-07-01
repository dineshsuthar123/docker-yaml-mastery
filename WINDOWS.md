# 🎯 Windows Quick Start Guide

Welcome to Docker & YAML Mastery on Windows! This guide helps you get started quickly.

## 🚀 Quick Launch Options

### Option 1: Windows Launcher (Recommended)
```cmd
# Double-click launch.bat or run from command prompt
launch.bat
```

### Option 2: PowerShell Scripts
```powershell
# Deploy live demos
.\scripts\deploy-demos.ps1

# Test all projects
.\scripts\test-all.ps1

# Test specific project
.\scripts\test-all.ps1 -Project p6
```

### Option 3: NPM Scripts
```cmd
# Start learning (Windows compatible)
npm run start:windows

# Test projects (Windows compatible)  
npm run test:windows

# Deploy demos
npm run deploy:demos:windows

# Quick launcher
npm run launcher
```

## 🐳 Running Individual Projects

```cmd
# Navigate to any project
cd p6

# Start the stack
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the stack
docker-compose down
```

## 🛠️ Prerequisites

1. **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop)
2. **Git for Windows** (optional) - [Download here](https://git-scm.com/download/win)
3. **Node.js** (for quizzes) - [Download here](https://nodejs.org/)

## 🎯 Recommended Learning Path

1. **Start with YAML basics** (`basics/` folder)
2. **Run simple projects** (p1, p2, p3)
3. **Explore advanced stacks** (p6, p10, p14)
4. **Take interactive quizzes**
5. **Deploy live demos**

## 🆘 Troubleshooting

### PowerShell Execution Policy
```powershell
# If scripts won't run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Docker Issues
- Ensure Docker Desktop is running
- Check Windows containers vs Linux containers mode
- Verify virtualization is enabled in BIOS

### Port Conflicts
```cmd
# Check what's using a port
netstat -ano | findstr :8000

# Kill process if needed
taskkill /F /PID [process_id]
```

## 🌟 Windows-Specific Features

- **PowerShell scripts** for native Windows experience
- **Batch file launcher** for easy access
- **Windows Terminal** integration
- **VS Code** integration and tasks

---

Happy learning! 🚀
