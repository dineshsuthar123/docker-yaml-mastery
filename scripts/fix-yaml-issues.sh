#!/bin/bash

# 🔧 Fix YAML Trailing Spaces - CI/CD Issue Resolver
# This script removes trailing spaces from all YAML files

echo "🔧 Fixing YAML trailing spaces across all files..."

# Find and fix trailing spaces in all YAML files
find . -name "*.yml" -o -name "*.yaml" | while read file; do
    if [[ -f "$file" ]]; then
        echo "Fixing: $file"
        # Remove trailing spaces and tabs
        sed -i 's/[[:space:]]*$//' "$file"
    fi
done

echo "✅ All YAML files cleaned of trailing spaces!"

# Validate all files after cleaning
echo "🔍 Validating cleaned files..."
find . -name "*.yml" -o -name "*.yaml" | while read file; do
    if [[ -f "$file" ]]; then
        if docker-compose -f "$file" config --quiet 2>/dev/null; then
            echo "✅ $file - Valid"
        else
            echo "❌ $file - Still has issues"
        fi
    fi
done

echo "🎉 YAML cleanup complete!"
