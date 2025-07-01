# 🚀 Docker & YAML Mastery - Live Demo Deployment (PowerShell)
# Enhanced flagship Windows-compatible deployment script

param(
    [string]$Provider = "docker-playground",
    [string]$Domain = "demo.docker-mastery.dev",
    [string]$Project = "",
    [switch]$List,
    [switch]$Help,
    [switch]$Interactive
)

# Colors for PowerShell
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Blue = "Blue"
$Cyan = "Cyan"
$Magenta = "Magenta"

# ASCII Banner
Write-Host ""
Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor $Cyan
Write-Host "║                                                               ║" -ForegroundColor $Cyan
Write-Host "║   🚀 Docker & YAML Mastery - Live Demo Deployment           ║" -ForegroundColor $Cyan
Write-Host "║                                                               ║" -ForegroundColor $Cyan
Write-Host "║   Flagship-Level Windows PowerShell Automation               ║" -ForegroundColor $Cyan
Write-Host "║                                                               ║" -ForegroundColor $Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor $Cyan
Write-Host ""

# Enhanced demo projects with comprehensive metadata
$DemoProjects = @{
    "p1" = @{
        Name = "simple-node-mongo"
        Description = "Basic Node.js + MongoDB"
        Difficulty = "⭐"
        Technologies = @("Node.js", "MongoDB", "Express")
        Port = 3000
        Category = "Beginner"
    }
    "p2" = @{
        Name = "fullstack-react-express"
        Description = "Full-stack React + Express"
        Difficulty = "⭐⭐"
        Technologies = @("React", "Express", "PostgreSQL", "Redis")
        Port = 3000
        Category = "Beginner"
    }
    "p6" = @{
        Name = "django-celery-stack"
        Description = "Django + Celery + Redis"
        Difficulty = "⭐⭐⭐"
        Technologies = @("Django", "Celery", "PostgreSQL", "Redis", "Nginx")
        Port = 8000
        Category = "Intermediate"
    }
    "p10" = @{
        Name = "kafka-streaming"
        Description = "Event Streaming Platform"
        Difficulty = "⭐⭐⭐⭐"
        Technologies = @("Kafka", "Zookeeper", "Node.js", "PostgreSQL")
        Port = 9092
        Category = "Advanced"
    }
    "p14" = @{
        Name = "production-monitoring"
        Description = "Enterprise Observability"
        Difficulty = "⭐⭐⭐⭐⭐"
        Technologies = @("Prometheus", "Grafana", "Nginx", "Node.js")
        Port = 3000
        Category = "Expert"
    }
}

function Deploy-ToDockerPlayground {
    param($ProjectPath, $Name)
    
    Write-Host "Deploying $Name to Docker Playground..." -ForegroundColor $Yellow
    
    # Create Docker Playground compatible stack
    $stackUrl = "https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/$ProjectPath/docker-compose.yml"
    Write-Host "Demo URL: $stackUrl" -ForegroundColor $Green
}

function Deploy-ToRender {
    param($ProjectPath, $Name)
    
    Write-Host "Deploying $Name to Render..." -ForegroundColor $Yellow
    
    Set-Location $ProjectPath
    
    # Create render.yaml
    $renderConfig = @"
services:
  - type: web
    name: $Name
    env: docker
    dockerfilePath: ./Dockerfile
    envVars:
      - key: NODE_ENV
        value: production
    healthCheckPath: /health
"@
    
    $renderConfig | Out-File -FilePath "render.yaml" -Encoding utf8
    
    # Deploy (requires Render CLI)
    if (Get-Command "render" -ErrorAction SilentlyContinue) {
        render deploy
    } else {
        Write-Host "Render CLI not found. Install from: https://render.com/docs/cli" -ForegroundColor $Red
    }
    
    Set-Location ..
}

function Deploy-ToHeroku {
    param($ProjectPath, $Name)
    
    Write-Host "Deploying $Name to Heroku Container Registry..." -ForegroundColor $Yellow
    
    Set-Location $ProjectPath
    
    # Check if Heroku CLI is available
    if (Get-Command "heroku" -ErrorAction SilentlyContinue) {
        heroku container:login
        heroku create $Name --region us
        heroku container:push web
        heroku container:release web
        heroku open
    } else {
        Write-Host "Heroku CLI not found. Install from: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor $Red
    }
    
    Set-Location ..
}

function Generate-DemoIndex {
    Write-Host "Generating demo index page..." -ForegroundColor $Yellow
    
    if (-not (Test-Path "demos")) {
        New-Item -ItemType Directory -Path "demos"
    }
    
    $indexHtml = @'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Docker & YAML Mastery - Live Demos</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🐳</text></svg>">
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <header class="text-center mb-12">
            <div class="animate-bounce mb-4">
                <span class="text-6xl">🐳</span>
            </div>
            <h1 class="text-5xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent mb-4">
                Docker & YAML Mastery
            </h1>
            <p class="text-2xl text-gray-700 mb-6">Interactive Live Demos</p>
            <div class="flex justify-center space-x-4">
                <span class="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">✅ 15+ Projects</span>
                <span class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">🚀 Live Demos</span>
                <span class="bg-purple-100 text-purple-800 px-3 py-1 rounded-full text-sm font-medium">🧠 Interactive Quizzes</span>
            </div>
        </header>
        
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
            <!-- P1 Demo -->
            <div class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-gray-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🟢</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">P1: Node.js + MongoDB</h3>
                        <span class="text-sm text-green-600 font-medium">Beginner Level</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Basic containerization with Node.js and MongoDB. Perfect starting point!</p>
                <div class="flex space-x-2">
                    <a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p1/docker-compose.yml" 
                       class="bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-2 rounded-lg hover:from-blue-600 hover:to-blue-700 transition-colors flex-1 text-center">
                        🚀 Live Demo
                    </a>
                    <a href="https://github.com/yourusername/docker-yaml-mastery/tree/main/p1" 
                       class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                        📖 Code
                    </a>
                </div>
            </div>
            
            <!-- P2 Demo -->
            <div class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-gray-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🟡</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">P2: Full-Stack React</h3>
                        <span class="text-sm text-yellow-600 font-medium">Intermediate Level</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Complete web application with React, Express, PostgreSQL, and Redis.</p>
                <div class="flex space-x-2">
                    <a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p2/docker-compose.yml" 
                       class="bg-gradient-to-r from-green-500 to-green-600 text-white px-4 py-2 rounded-lg hover:from-green-600 hover:to-green-700 transition-colors flex-1 text-center">
                        🚀 Live Demo
                    </a>
                    <a href="https://github.com/yourusername/docker-yaml-mastery/tree/main/p2" 
                       class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                        📖 Code
                    </a>
                </div>
            </div>
            
            <!-- P6 Demo -->
            <div class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-gray-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🔴</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">P6: Django + Celery</h3>
                        <span class="text-sm text-red-600 font-medium">Advanced Level</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Production-ready Django with async task processing using Celery and Redis.</p>
                <div class="flex space-x-2">
                    <a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p6/docker-compose.yml" 
                       class="bg-gradient-to-r from-purple-500 to-purple-600 text-white px-4 py-2 rounded-lg hover:from-purple-600 hover:to-purple-700 transition-colors flex-1 text-center">
                        🚀 Live Demo
                    </a>
                    <a href="https://github.com/yourusername/docker-yaml-mastery/tree/main/p6" 
                       class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                        📖 Code
                    </a>
                </div>
            </div>
            
            <!-- P10 Demo -->
            <div class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-gray-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🚀</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">P10: Kafka Streaming</h3>
                        <span class="text-sm text-orange-600 font-medium">Expert Level</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Real-time event streaming platform with Kafka, producers, and consumers.</p>
                <div class="flex space-x-2">
                    <a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p10/docker-compose.yml" 
                       class="bg-gradient-to-r from-orange-500 to-orange-600 text-white px-4 py-2 rounded-lg hover:from-orange-600 hover:to-orange-700 transition-colors flex-1 text-center">
                        🚀 Live Demo
                    </a>
                    <a href="https://github.com/yourusername/docker-yaml-mastery/tree/main/p10" 
                       class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                        📖 Code
                    </a>
                </div>
            </div>
            
            <!-- P14 Demo -->
            <div class="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-gray-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🏭</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">P14: Production Stack</h3>
                        <span class="text-sm text-indigo-600 font-medium">Enterprise Level</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Enterprise-grade monitoring with Prometheus, Grafana, and Traefik.</p>
                <div class="flex space-x-2">
                    <a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p14/docker-compose.yml" 
                       class="bg-gradient-to-r from-indigo-500 to-indigo-600 text-white px-4 py-2 rounded-lg hover:from-indigo-600 hover:to-indigo-700 transition-colors flex-1 text-center">
                        🚀 Live Demo
                    </a>
                    <a href="https://github.com/yourusername/docker-yaml-mastery/tree/main/p14" 
                       class="bg-gray-500 text-white px-4 py-2 rounded-lg hover:bg-gray-600 transition-colors">
                        📖 Code
                    </a>
                </div>
            </div>
            
            <!-- Interactive Quiz -->
            <div class="bg-gradient-to-br from-green-50 to-emerald-100 rounded-xl shadow-lg hover:shadow-xl transition-shadow p-6 border border-green-200">
                <div class="flex items-center mb-4">
                    <span class="text-3xl mr-3">🧠</span>
                    <div>
                        <h3 class="text-xl font-bold text-gray-800">Interactive Quiz</h3>
                        <span class="text-sm text-green-600 font-medium">Test Your Skills</span>
                    </div>
                </div>
                <p class="text-gray-600 mb-4">Challenge yourself with Docker and YAML questions. Track your progress!</p>
                <div class="flex space-x-2">
                    <a href="/quizzes/quiz.html" 
                       class="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-4 py-2 rounded-lg hover:from-green-600 hover:to-emerald-700 transition-colors flex-1 text-center">
                        🎯 Start Quiz
                    </a>
                    <a href="/quizzes/leaderboard.html" 
                       class="bg-purple-500 text-white px-4 py-2 rounded-lg hover:bg-purple-600 transition-colors">
                        🏆 Leaderboard
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="bg-white rounded-xl shadow-lg p-8 mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">🎯 Quick Actions</h2>
            <div class="grid md:grid-cols-4 gap-4">
                <a href="https://github.com/yourusername/docker-yaml-mastery" 
                   class="bg-gray-800 text-white px-6 py-4 rounded-lg hover:bg-gray-900 transition-colors text-center">
                    <div class="text-2xl mb-2">📚</div>
                    <div class="font-medium">View Repository</div>
                </a>
                <a href="/docs/quick-start.html" 
                   class="bg-blue-500 text-white px-6 py-4 rounded-lg hover:bg-blue-600 transition-colors text-center">
                    <div class="text-2xl mb-2">🚀</div>
                    <div class="font-medium">Quick Start Guide</div>
                </a>
                <a href="/kubernetes/README.md" 
                   class="bg-indigo-500 text-white px-6 py-4 rounded-lg hover:bg-indigo-600 transition-colors text-center">
                    <div class="text-2xl mb-2">☸️</div>
                    <div class="font-medium">Kubernetes Next</div>
                </a>
                <a href="/community/discord" 
                   class="bg-purple-500 text-white px-6 py-4 rounded-lg hover:bg-purple-600 transition-colors text-center">
                    <div class="text-2xl mb-2">💬</div>
                    <div class="font-medium">Join Community</div>
                </a>
            </div>
        </div>
        
        <!-- Stats -->
        <div class="bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl shadow-lg text-white p-8 text-center">
            <h2 class="text-3xl font-bold mb-4">Join 10,000+ Developers Learning Docker</h2>
            <div class="grid md:grid-cols-4 gap-6">
                <div>
                    <div class="text-3xl font-bold">15+</div>
                    <div class="text-blue-100">Projects</div>
                </div>
                <div>
                    <div class="text-3xl font-bold">50+</div>
                    <div class="text-blue-100">Technologies</div>
                </div>
                <div>
                    <div class="text-3xl font-bold">100+</div>
                    <div class="text-blue-100">Quiz Questions</div>
                </div>
                <div>
                    <div class="text-3xl font-bold">∞</div>
                    <div class="text-blue-100">Possibilities</div>
                </div>
            </div>
        </div>
        
        <footer class="text-center mt-12 text-gray-600">
            <p class="mb-4">🚀 Built with Docker & YAML Mastery</p>
            <div class="flex justify-center space-x-6">
                <a href="https://github.com/yourusername/docker-yaml-mastery" class="text-blue-500 hover:text-blue-600">GitHub</a>
                <a href="/docs" class="text-blue-500 hover:text-blue-600">Documentation</a>
                <a href="/community" class="text-blue-500 hover:text-blue-600">Community</a>
                <a href="/contribute" class="text-blue-500 hover:text-blue-600">Contribute</a>
            </div>
        </footer>
    </div>
    
    <!-- Analytics -->
    <script>
        // Add Google Analytics or other tracking
        console.log('🐳 Docker & YAML Mastery Demo Portal Loaded!');
        
        // Track demo clicks
        document.querySelectorAll('a[href*="play-with-docker"]').forEach(link => {
            link.addEventListener('click', () => {
                console.log('Demo started:', link.closest('.bg-white').querySelector('h3').textContent);
            });
        });
    </script>
</body>
</html>
'@
    
    $indexHtml | Out-File -FilePath "demos\index.html" -Encoding utf8
    Write-Host "✅ Demo index generated at demos\index.html" -ForegroundColor $Green
}

function Show-Help {
    Write-Host @"
🚀 Live Demo Deployment Script (PowerShell)

Usage: .\deploy-demos.ps1 [OPTIONS]

Parameters:
    -Provider PROVIDER     Cloud provider (docker-playground, render, railway, heroku)
    -Domain DOMAIN        Demo domain (default: demo.docker-mastery.dev)
    -Project PROJECT      Deploy specific project only
    -List                 List available projects
    -Help                 Show this help

Examples:
    .\deploy-demos.ps1 -Provider render
    .\deploy-demos.ps1 -Provider railway -Project p6
    .\deploy-demos.ps1 -Domain my-demos.com
"@ -ForegroundColor $Yellow
}

function Show-ProjectList {
    Write-Host "Available demo projects:" -ForegroundColor $Green
    foreach ($demo in $DemoProjects) {
        Write-Host "  $($demo.Project): $($demo.Name)" -ForegroundColor $Yellow
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

if ($List) {
    Show-ProjectList
    exit 0
}

Write-Host "Starting live demo deployment..." -ForegroundColor $Green
Write-Host "Provider: $Provider" -ForegroundColor $Yellow
Write-Host "Domain: $Domain" -ForegroundColor $Yellow

# Generate demo index page
Generate-DemoIndex

# Deploy projects
foreach ($demo in $DemoProjects) {
    if ($Project -and $demo.Project -ne $Project) {
        continue
    }
    
    Write-Host "`nProcessing $($demo.Project): $($demo.Name)" -ForegroundColor $Yellow
    
    switch ($Provider) {
        "docker-playground" {
            Deploy-ToDockerPlayground $demo.Project $demo.Name
        }
        "render" {
            Deploy-ToRender $demo.Project $demo.Name
        }
        "heroku" {
            Deploy-ToHeroku $demo.Project $demo.Name
        }
        default {
            Write-Host "Unknown provider: $Provider" -ForegroundColor $Red
            Write-Host "Supported providers: docker-playground, render, heroku" -ForegroundColor $Yellow
        }
    }
    
    Start-Sleep -Seconds 2
}

Write-Host "`n✅ Live demos deployment completed!" -ForegroundColor $Green
Write-Host "Demo index: https://$Domain" -ForegroundColor $Yellow
Write-Host "Local demo page: file:///$PWD/demos/index.html" -ForegroundColor $Cyan
