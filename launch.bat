@echo off
REM 🐳 Docker & YAML Mastery - Quick Launcher for Windows
REM This batch file provides easy access to all scripts

title Docker ^& YAML Mastery - Learning Platform

echo.
echo  ╔═══════════════════════════════════════════════════════════════╗
echo  ║                                                               ║
echo  ║   🐳 Docker ^& YAML Mastery - Windows Launcher              ║
echo  ║                                                               ║
echo  ║   Choose your learning path:                                  ║
echo  ║                                                               ║
echo  ╚═══════════════════════════════════════════════════════════════╝
echo.

:menu
echo  1. 📚 Start Learning Platform (Bash)
echo  2. 🚀 Deploy Live Demos (PowerShell)
echo  3. 🧪 Run Tests on All Projects
echo  4. 📊 Performance Testing
echo  5. 🏁 Flagship Launcher
echo  6. 🐳 Run Specific Project
echo  7. 📖 Open Documentation
echo  8. 🌐 Open Demo Portal
echo  9. ❓ Help
echo  0. 🚪 Exit
echo.

set /p choice="Enter your choice (0-9): "

REM Clear any previous error level
echo.

if "%choice%"=="1" goto start_learning
if "%choice%"=="2" goto deploy_demos
if "%choice%"=="3" goto run_tests
if "%choice%"=="4" goto performance_test
if "%choice%"=="5" goto flagship_launcher
if "%choice%"=="6" goto run_project
if "%choice%"=="7" goto open_docs
if "%choice%"=="8" goto open_demos
if "%choice%"=="9" goto help
if "%choice%"=="0" goto exit

REM If we get here, it's an invalid choice
goto invalid

:start_learning
echo.
echo 🚀 Starting Learning Platform...
echo.
echo Note: This requires Git Bash or WSL for shell scripts
echo Alternative: Use PowerShell scripts directly
echo.
pause
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" scripts/start-learning-platform.sh
) else (
    echo Git Bash not found. Please install Git for Windows or use WSL.
    echo Alternatively, examine the scripts manually in VS Code.
    start code scripts/
)
goto menu

:deploy_demos
echo.
echo 🚀 Deploying Live Demos...
echo.
REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% equ 0 (
    if exist "scripts\deploy-demos.ps1" (
        powershell -ExecutionPolicy Bypass -File "scripts\deploy-demos.ps1"
    ) else (
        echo PowerShell deployment script not found. Using alternative...
        echo Creating demo pages locally...
        if not exist "demos" mkdir demos
        echo ^<!DOCTYPE html^> > demos\index.html
        echo ^<html^>^<head^>^<title^>Docker Mastery Demos^</title^>^</head^> >> demos\index.html
        echo ^<body^>^<h1^>🐳 Docker ^& YAML Mastery Demos^</h1^> >> demos\index.html
        echo ^<p^>Local demo portal created successfully!^</p^> >> demos\index.html
        echo ^</body^>^</html^> >> demos\index.html
        echo ✅ Demo portal created at demos\index.html
        start demos\index.html
    )
) else (
    echo PowerShell not found in PATH. Creating simple demo portal...
    if not exist "demos" mkdir demos
    echo ^<!DOCTYPE html^> > demos\index.html
    echo ^<html^>^<head^>^<title^>Docker Mastery Demos^</title^>^</head^> >> demos\index.html
    echo ^<body^>^<h1^>🐳 Docker ^& YAML Mastery Demos^</h1^> >> demos\index.html
    echo ^<p^>Demo portal created! Check individual projects in their folders.^</p^> >> demos\index.html
    echo ^</body^>^</html^> >> demos\index.html
    echo ✅ Basic demo portal created at demos\index.html
    start demos\index.html
)
goto menu

:run_tests
echo.
echo 🧪 Running Tests on All Projects...
echo.
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" scripts/test-all.sh
) else (
    echo Running PowerShell equivalent...
    powershell -Command "Get-ChildItem p* -Directory | ForEach-Object { Write-Host 'Testing $_...'; Set-Location $_; if (Test-Path 'docker-compose.yml') { docker-compose config --quiet; Write-Host '✅ $_' } else { Write-Host '⚠️  No docker-compose.yml in $_' }; Set-Location '..' }"
)
goto menu

:performance_test
echo.
echo 📊 Running Performance Tests...
echo.
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" scripts/performance-test.sh
) else (
    echo Performance testing requires bash. Opening script for manual review...
    start code scripts/performance-test.sh
)
goto menu

:flagship_launcher
echo.
echo 🏁 Starting Flagship Experience...
echo.
if exist "C:\Program Files\Git\bin\bash.exe" (
    "C:\Program Files\Git\bin\bash.exe" scripts/flagship-launcher.sh
) else (
    echo Opening flagship experience components...
    start code README.md
    start demos/index.html
)
goto menu

:run_project
echo.
echo Available projects:
dir /b p* 2>nul | findstr "^p[0-9]"
echo.
set /p project="Enter project name (e.g., p1, p6): "
if exist "%project%" (
    echo.
    echo 🐳 Starting %project%...
    cd %project%
    docker-compose up -d
    echo.
    echo ✅ %project% is running! Check Docker Desktop or use 'docker-compose ps'
    echo To stop: docker-compose down
    cd ..
) else (
    echo ❌ Project %project% not found!
)
goto menu

:open_docs
echo.
echo 📖 Opening Documentation...
start README.md
if exist "docs\" (
    start code docs/
)
goto menu

:open_demos
echo.
echo 🌐 Opening Demo Portal...
if exist "demos\index.html" (
    start demos\index.html
) else (
    echo Demo portal not found. Running deployment first...
    powershell -ExecutionPolicy Bypass -File "scripts\deploy-demos.ps1"
    start demos\index.html
)
goto menu

:help
echo.
echo ❓ Docker ^& YAML Mastery Help
echo.
echo This launcher provides quick access to all learning tools:
echo.
echo • Learning Platform: Interactive tutorials and guides
echo • Live Demos: Deploy projects to cloud platforms  
echo • Testing: Validate all Docker Compose configurations
echo • Performance: Benchmark container performance
echo • Projects: Quick start individual projects
echo.
echo Prerequisites:
echo • Docker Desktop installed and running
echo • Git for Windows (for bash scripts)
echo • PowerShell 5.0+ (for advanced features)
echo.
echo Troubleshooting:
echo • If bash scripts fail, use PowerShell alternatives
echo • Ensure Docker is running before starting projects
echo • Check firewall settings for port access
echo.
pause
goto menu

:invalid
echo.
echo ❌ Invalid choice. Please enter a number between 0-9.
echo.
goto menu

:exit
echo.
echo 👋 Thank you for using Docker ^& YAML Mastery!
echo.
echo 🌟 Don't forget to:
echo   • Star the repository on GitHub
echo   • Share with your network
echo   • Join our community Discord
echo.
echo Happy coding! 🚀
echo.
pause
exit /b 0
