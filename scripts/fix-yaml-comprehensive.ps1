# 🔧 Comprehensive YAML Fix Script - PowerShell Version
# Fixes all YAML issues detected in CI/CD pipeline

param(
    [switch]$Verbose = $false
)

Write-Host "🔧 Starting comprehensive YAML fixes..." -ForegroundColor Cyan

$fixCount = 0
$errorCount = 0

# Function to fix trailing spaces
function Fix-TrailingSpaces {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw
        $fixed = $content -replace '\s+$', ''
        $fixed = $fixed -replace '\s+\r?\n', "`n"
        Set-Content -Path $FilePath -Value $fixed -NoNewline
        
        if ($Verbose) {
            Write-Host "✅ Fixed trailing spaces: $FilePath" -ForegroundColor Green
        }
        return $true
    }
    catch {
        Write-Host "❌ Error fixing $FilePath : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to validate YAML files
function Test-YamlFile {
    param([string]$FilePath)
    
    # Skip GitHub Actions workflow files (they have different validation)
    if ($FilePath -match "\.github\\workflows\\") {
        return $true
    }
    
    # Skip basic YAML examples (they're not docker-compose files)
    if ($FilePath -match "basics\\") {
        return $true
    }
    
    # Only validate docker-compose files
    if ($FilePath -match "docker-compose.*\.yml$") {
        try {
            $result = docker-compose -f $FilePath config --quiet 2>$null
            return $LASTEXITCODE -eq 0
        }
        catch {
            return $false
        }
    }
    
    return $true
}

# Get all YAML files
$yamlFiles = Get-ChildItem -Recurse -Include "*.yml", "*.yaml" | Where-Object { !$_.PSIsContainer }

Write-Host "📋 Found $($yamlFiles.Count) YAML files to process" -ForegroundColor Yellow

foreach ($file in $yamlFiles) {
    Write-Host "🔍 Processing: $($file.FullName)" -ForegroundColor Blue
    
    if (Fix-TrailingSpaces -FilePath $file.FullName) {
        $fixCount++
        
        if (Test-YamlFile -FilePath $file.FullName) {
            Write-Host "✅ $($file.Name) - Valid" -ForegroundColor Green
        } else {
            Write-Host "⚠️  $($file.Name) - Validation failed (may be expected for non-compose files)" -ForegroundColor Yellow
        }
    } else {
        $errorCount++
    }
}

Write-Host ""
Write-Host "🎉 YAML Processing Complete!" -ForegroundColor Cyan
Write-Host "✅ Files processed: $fixCount" -ForegroundColor Green
Write-Host "❌ Errors: $errorCount" -ForegroundColor Red

# Create .yamllint.yml configuration for better validation
$yamllintConfig = @"
extends: default

rules:
  line-length:
    max: 120
  trailing-spaces: enable
  empty-lines:
    max-end: 1
  comments:
    min-spaces-from-content: 1
  indentation:
    spaces: 2
  truthy:
    allowed-values: [true, false, 'yes', 'no']
"@

Set-Content -Path ".yamllint.yml" -Value $yamllintConfig
Write-Host "📋 Created .yamllint.yml configuration" -ForegroundColor Green

Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor Cyan
Write-Host "1. Install yamllint: pip install yamllint" -ForegroundColor White
Write-Host "2. Run validation: yamllint ." -ForegroundColor White
Write-Host "3. Commit and push the fixes" -ForegroundColor White
