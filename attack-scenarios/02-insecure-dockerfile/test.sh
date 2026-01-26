#!/bin/bash
set -e

echo "🎯 ATTACK SCENARIO 02: Insecure Dockerfile"
echo "============================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Testing insecure Dockerfile with Conftest...${NC}"
echo ""

# Test with Conftest
if conftest test --policy ../../security-policies/conftest/dockerfile/policy.rego Dockerfile.insecure 2>&1 | tee /tmp/conftest-output.txt; then
    echo ""
    echo -e "${RED}❌ FAILURE: Conftest did NOT catch security issues${NC}"
    exit 1
else
    echo ""
    # Check if we caught the expected issues
    ISSUES_FOUND=0

    if grep -q "Do not use 'latest' tag" /tmp/conftest-output.txt; then
        echo -e "${GREEN}✅ Caught: 'latest' tag usage${NC}"
        ((ISSUES_FOUND++))
    fi

    if grep -q "Do not run containers as root" /tmp/conftest-output.txt; then
        echo -e "${GREEN}✅ Caught: Running as root user${NC}"
        ((ISSUES_FOUND++))
    fi

    if grep -q "USER instruction" /tmp/conftest-output.txt; then
        echo -e "${GREEN}✅ Caught: Missing USER instruction${NC}"
        ((ISSUES_FOUND++))
    fi

    if [ $ISSUES_FOUND -ge 3 ]; then
        echo ""
        echo -e "${GREEN}✅ SUCCESS: Conftest caught multiple security issues ($ISSUES_FOUND)${NC}"

        echo ""
        echo -e "${YELLOW}Now testing secure Dockerfile (should pass)...${NC}"
        if conftest test --policy ../../security-policies/conftest/dockerfile/policy.rego Dockerfile.secure; then
            echo -e "${GREEN}✅ Secure Dockerfile passes all checks${NC}"
        else
            echo -e "${YELLOW}⚠️  Secure Dockerfile has some warnings (acceptable)${NC}"
        fi

        rm -f /tmp/conftest-output.txt
        exit 0
    else
        echo ""
        echo -e "${RED}❌ FAILURE: Only caught $ISSUES_FOUND issues (expected at least 3)${NC}"
        rm -f /tmp/conftest-output.txt
        exit 1
    fi
fi
