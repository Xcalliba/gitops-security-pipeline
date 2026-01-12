#!/bin/bash

echo "🎯 ATTACK SCENARIO 01: Secrets in Code"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Step 1: Adding vulnerable file to Git${NC}"
git add vulnerable.py

echo ""
echo -e "${YELLOW}Step 2: Attempting to commit${NC}"
echo ""

# Capture output and exit code properly
OUTPUT_FILE="/tmp/commit-output-$$.txt"

# Run commit and capture both output and exit code
git commit -m "test: add vulnerable code with secrets" > "$OUTPUT_FILE" 2>&1
COMMIT_EXIT_CODE=$?

# Display the output
cat "$OUTPUT_FILE"

echo ""
echo "=========================================="
echo "TEST RESULT ANALYSIS"
echo "=========================================="
echo ""

# Debug info
echo "Commit exit code: $COMMIT_EXIT_CODE"
echo ""

# Check if commit was blocked
if [ $COMMIT_EXIT_CODE -eq 0 ]; then
    echo -e "${RED}❌ FAILURE: Commit was NOT blocked${NC}"
    echo -e "${RED}   Git commit succeeded when it should have failed${NC}"
    git reset HEAD vulnerable.py 2>/dev/null || true
    rm -f "$OUTPUT_FILE"
    exit 1
fi

# Commit was blocked, now check if it was Gitleaks
if grep -q "leaks found:" "$OUTPUT_FILE"; then
    LEAK_COUNT=$(grep "leaks found:" "$OUTPUT_FILE" | awk '{print $4}')
    echo -e "${GREEN}✅ SUCCESS: Gitleaks detected $LEAK_COUNT secret(s) and blocked commit${NC}"
    echo ""
    echo "Detected secrets by rule:"
    grep "RuleID:" "$OUTPUT_FILE" | awk '{print "  - " $2}' | sort | uniq -c
    echo ""
    echo -e "${GREEN}Security control is WORKING correctly!${NC}"
    git reset HEAD vulnerable.py 2>/dev/null || true
    rm -f "$OUTPUT_FILE"
    exit 0
else
    echo -e "${RED}❌ FAILURE: Commit blocked but not by Gitleaks${NC}"
    echo ""
    echo "Commit was blocked, but couldn't find 'leaks found' in output"
    echo ""
    echo "Searching for gitleaks-related output..."
    grep -i "gitleaks\|secret\|leak" "$OUTPUT_FILE" || echo "No gitleaks output found"
    git reset HEAD vulnerable.py 2>/dev/null || true
    rm -f "$OUTPUT_FILE"
    exit 1
fi
