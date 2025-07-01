# Fix YAML Trailing Spaces - CI/CD Issue Resolver (PowerShell)
# This script removes trailing spaces from all YAML files

Write-Host "Fixing YAML trailing spaces across all files..." -ForegroundColor Cyan

# Find all YAML files and fix trailing spaces
$yamlFiles = Get-ChildItem -Recurse -Include "*.yml", "*.yaml" | Where-Object { $_.PSIsContainer -eq $false }

foreach ($file in $yamlFiles) {
    Write-Host "Fixing: $($file.Name)" -ForegroundColor Yellow
    
    # Read content and remove trailing spaces
    $content = Get-Content $file.FullName
    $fixedContent = $content | ForEach-Object { $_ -replace '\s+$', '' }
    
    # Write back the cleaned content
    $fixedContent | Out-File -FilePath $file.FullName -Encoding UTF8
}

Write-Host "All YAML files cleaned of trailing spaces!" -ForegroundColor Green

# Validate Docker Compose files after cleaning
Write-Host "Validating Docker Compose files..." -ForegroundColor Blue

$composeFiles = Get-ChildItem -Recurse -Include "docker-compose*.yml" | Where-Object { $_.PSIsContainer -eq $false }

foreach ($file in $composeFiles) {
    try {
        $null = docker-compose -f $file.FullName config --quiet 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "VALID: $($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "ISSUES: $($file.Name)" -ForegroundColor Red
        }
    } catch {
        Write-Host "CANNOT VALIDATE: $($file.Name)" -ForegroundColor Yellow
    }
}

# Additional fixes for common YAML issues
Write-Host "Applying additional YAML fixes..." -ForegroundColor Cyan

foreach ($file in $yamlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Fix common YAML issues
    $content = $content -replace '\t', '  '  # Replace tabs with spaces
    $content = $content -replace ' +\n', "`n"  # Remove trailing spaces before newlines
    $content = $content -replace '\n{3,}', "`n`n"  # Remove excessive blank lines
    
    # Write back the fixed content
    $content | Out-File -FilePath $file.FullName -Encoding UTF8
}

Write-Host "YAML cleanup complete!" -ForegroundColor Green
