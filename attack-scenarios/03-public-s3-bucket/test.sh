#!/bin/bash
set -e

echo "🎯 ATTACK SCENARIO 03: Public S3 Bucket"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Step 1: Testing insecure Terraform with Checkov${NC}"
echo ""

# Test with Checkov
if checkov -f main.tf.insecure --framework terraform 2>&1 | tee /tmp/checkov-output.txt; then
    echo ""
    echo -e "${RED}❌ FAILURE: Checkov did NOT find security issues${NC}"
    exit 1
else
    echo ""
    CHECKS_FAILED=$(grep -c "Check:" /tmp/checkov-output.txt || echo "0")

    if [ "$CHECKS_FAILED" -ge 5 ]; then
        echo -e "${GREEN}✅ SUCCESS: Checkov found $CHECKS_FAILED security issues${NC}"
        echo ""
        echo "Issues detected:"
        grep "Check:" /tmp/checkov-output.txt | head -5
    else
        echo -e "${RED}❌ FAILURE: Only found $CHECKS_FAILED issues (expected at least 5)${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}Step 2: Testing insecure Terraform with tfsec${NC}"
echo ""

# Test with tfsec
if tfsec main.tf.insecure 2>&1 | tee /tmp/tfsec-output.txt; then
    echo -e "${RED}❌ FAILURE: tfsec did NOT find security issues${NC}"
    exit 1
else
    TFSEC_ISSUES=$(grep -c "Problem" /tmp/tfsec-output.txt || echo "0")

    if [ "$TFSEC_ISSUES" -ge 3 ]; then
        echo -e "${GREEN}✅ SUCCESS: tfsec found $TFSEC_ISSUES security issues${NC}"
    else
        echo -e "${YELLOW}⚠️  tfsec found $TFSEC_ISSUES issues (acceptable)${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Step 3: Testing secure Terraform (should pass or minimal warnings)${NC}"
echo ""

if checkov -f main.tf.secure --framework terraform --quiet; then
    echo -e "${GREEN}✅ Secure Terraform passes Checkov checks${NC}"
else
    echo -e "${YELLOW}⚠️  Secure Terraform has some warnings (review manually)${NC}"
fi

# Cleanup
rm -f /tmp/checkov-output.txt /tmp/tfsec-output.txt

echo ""
echo -e "${GREEN}✅ Test complete!${NC}"
exit 0
