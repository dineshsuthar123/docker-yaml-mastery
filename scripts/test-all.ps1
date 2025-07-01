# 🧪 Docker & YAML Mastery - Test All Projects (PowerShell)
# Windows-compatible testing script

param(
    [string]$Project = "",
    [switch]$Verbose,
    [switch]$SkipBuild,
    [switch]$Help
)

# Colors
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"
$Blue = "Blue"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-DockerCompose {
    param([string]$ProjectPath)
    
    Write-ColorOutput "🧪 Testing $ProjectPath..." $Yellow
    
    $originalLocation = Get-Location
    try {
        Set-Location $ProjectPath
        
        # Test 1: Validate docker-compose.yml syntax
        Write-ColorOutput "  ├─ Validating docker-compose.yml..." $Blue
        $configResult = docker-compose config --quiet 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "  ├─ ✅ Configuration valid" $Green
        } else {
            Write-ColorOutput "  ├─ ❌ Configuration invalid: $configResult" $Red
            return $false
        }
        
        # Test 2: Check for required files
        Write-ColorOutput "  ├─ Checking required files..." $Blue
        if (Test-Path "docker-compose.yml") {
            Write-ColorOutput "  ├─ ✅ docker-compose.yml found" $Green
        } else {
            Write-ColorOutput "  ├─ ❌ docker-compose.yml missing" $Red
            return $false
        }
        
        # Test 3: Check for Dockerfile if build context exists
        $composeContent = Get-Content "docker-compose.yml" -Raw
        if ($composeContent -match "build:" -and -not (Test-Path "Dockerfile") -and -not (Test-Path "*/Dockerfile")) {
            Write-ColorOutput "  ├─ ⚠️  Build context found but no Dockerfile" $Yellow
        }
        
        # Test 4: Build images (if not skipped)
        if (-not $SkipBuild) {
            Write-ColorOutput "  ├─ Building images..." $Blue
            $buildResult = docker-compose build --quiet 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "  ├─ ✅ Build successful" $Green
            } else {
                Write-ColorOutput "  ├─ ❌ Build failed: $buildResult" $Red
                return $false
            }
        }
        
        # Test 5: Start services
        Write-ColorOutput "  ├─ Starting services..." $Blue
        $upResult = docker-compose up -d 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "  ├─ ✅ Services started" $Green
            
            # Wait for services to be ready
            Start-Sleep -Seconds 10
            
            # Test 6: Check service health
            Write-ColorOutput "  ├─ Checking service health..." $Blue
            $psResult = docker-compose ps --format json | ConvertFrom-Json
            $allHealthy = $true
            
            foreach ($service in $psResult) {
                if ($service.State -eq "running") {
                    Write-ColorOutput "  ├─ ✅ $($service.Service): $($service.State)" $Green
                } else {
                    Write-ColorOutput "  ├─ ❌ $($service.Service): $($service.State)" $Red
                    $allHealthy = $false
                }
            }
            
            # Test 7: Basic connectivity test
            Write-ColorOutput "  ├─ Testing connectivity..." $Blue
            $ports = (docker-compose config | Select-String "^\s*-\s*\"\d+:\d+\"").Matches | ForEach-Object { $_.Value -replace '.*"(\d+):\d+".*', '$1' }
            
            foreach ($port in $ports) {
                try {
                    $connection = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
                    if ($connection.TcpTestSucceeded) {
                        Write-ColorOutput "  ├─ ✅ Port $port accessible" $Green
                    } else {
                        Write-ColorOutput "  ├─ ⚠️  Port $port not accessible" $Yellow
                    }
                } catch {
                    Write-ColorOutput "  ├─ ⚠️  Could not test port $port" $Yellow
                }
            }
            
            # Cleanup
            Write-ColorOutput "  ├─ Cleaning up..." $Blue
            docker-compose down --volumes --remove-orphans | Out-Null
            Write-ColorOutput "  └─ ✅ Cleanup complete" $Green
            
            return $allHealthy
        } else {
            Write-ColorOutput "  └─ ❌ Failed to start services: $upResult" $Red
            return $false
        }
        
    } catch {
        Write-ColorOutput "  └─ ❌ Error testing $ProjectPath : $($_.Exception.Message)" $Red
        return $false
    } finally {
        Set-Location $originalLocation
    }
}

function Test-YamlFiles {
    Write-ColorOutput "🔍 Testing YAML files..." $Yellow
    
    $yamlFiles = Get-ChildItem -Recurse -Include "*.yml", "*.yaml" | Where-Object { $_.Name -notmatch "node_modules|\.git" }
    $allValid = $true
    
    foreach ($file in $yamlFiles) {
        Write-ColorOutput "  ├─ Testing $($file.FullName)" $Blue
        try {
            # Basic YAML validation using PowerShell
            $content = Get-Content $file.FullName -Raw
            if ($content -match "^---" -or $content -match "^\w+:") {
                Write-ColorOutput "  ├─ ✅ $($file.Name) appears valid" $Green
            } else {
                Write-ColorOutput "  ├─ ⚠️  $($file.Name) may have issues" $Yellow
            }
        } catch {
            Write-ColorOutput "  ├─ ❌ $($file.Name) has errors: $($_.Exception.Message)" $Red
            $allValid = $false
        }
    }
    
    return $allValid
}

function Show-TestSummary {
    param([hashtable]$Results)
    
    Write-ColorOutput "`n📊 Test Summary" $Blue
    Write-ColorOutput "═══════════════" $Blue
    
    $passed = ($Results.Values | Where-Object { $_ -eq $true }).Count
    $failed = ($Results.Values | Where-Object { $_ -eq $false }).Count
    $total = $Results.Count
    
    Write-ColorOutput "Total Projects: $total" $Blue
    Write-ColorOutput "✅ Passed: $passed" $Green
    Write-ColorOutput "❌ Failed: $failed" $Red
    Write-ColorOutput "Success Rate: $([math]::Round(($passed / $total) * 100, 1))%" $Blue
    
    if ($failed -gt 0) {
        Write-ColorOutput "`n❌ Failed Projects:" $Red
        foreach ($result in $Results.GetEnumerator()) {
            if (-not $result.Value) {
                Write-ColorOutput "  • $($result.Key)" $Red
            }
        }
    }
    
    Write-ColorOutput "`n✅ Passed Projects:" $Green
    foreach ($result in $Results.GetEnumerator()) {
        if ($result.Value) {
            Write-ColorOutput "  • $($result.Key)" $Green
        }
    }
}

function Show-Help {
    Write-ColorOutput @"
🧪 Docker & YAML Mastery Test Suite (PowerShell)

Usage: .\test-all.ps1 [OPTIONS]

Parameters:
    -Project PROJECT      Test specific project only
    -Verbose             Show detailed output
    -SkipBuild           Skip the build step (faster testing)
    -Help                Show this help

Examples:
    .\test-all.ps1                    # Test all projects
    .\test-all.ps1 -Project p6        # Test only p6
    .\test-all.ps1 -SkipBuild         # Skip building images
    .\test-all.ps1 -Verbose           # Show detailed output
"@ $Yellow
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-ColorOutput "🧪 Docker & YAML Mastery - Test Suite" $Blue
Write-ColorOutput "═══════════════════════════════════════" $Blue

# Check Docker availability
try {
    docker --version | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Docker is not available. Please install Docker Desktop." $Red
        exit 1
    }
    Write-ColorOutput "✅ Docker is available" $Green
} catch {
    Write-ColorOutput "❌ Docker is not available. Please install Docker Desktop." $Red
    exit 1
}

# Check docker-compose availability
try {
    docker-compose --version | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-ColorOutput "❌ Docker Compose is not available." $Red
        exit 1
    }
    Write-ColorOutput "✅ Docker Compose is available" $Green
} catch {
    Write-ColorOutput "❌ Docker Compose is not available." $Red
    exit 1
}

# Test YAML files first
Write-ColorOutput "`n🔍 Phase 1: YAML Validation" $Blue
$yamlValid = Test-YamlFiles

# Get projects to test
if ($Project) {
    if (Test-Path $Project) {
        $projects = @($Project)
    } else {
        Write-ColorOutput "❌ Project '$Project' not found!" $Red
        exit 1
    }
} else {
    $projects = Get-ChildItem -Directory -Name | Where-Object { $_ -match "^p\d+$" } | Sort-Object
}

Write-ColorOutput "`n🐳 Phase 2: Docker Compose Projects" $Blue
Write-ColorOutput "Found $($projects.Count) projects to test" $Yellow

# Test each project
$results = @{}
foreach ($proj in $projects) {
    $results[$proj] = Test-DockerCompose $proj
    Write-ColorOutput ""
}

# Show summary
Show-TestSummary $results

# Exit with appropriate code
$failedCount = ($results.Values | Where-Object { $_ -eq $false }).Count
if ($failedCount -eq 0 -and $yamlValid) {
    Write-ColorOutput "`n🎉 All tests passed! Your Docker & YAML Mastery setup is ready!" $Green
    exit 0
} else {
    Write-ColorOutput "`n⚠️  Some tests failed. Please review the output above." $Yellow
    exit 1
}
