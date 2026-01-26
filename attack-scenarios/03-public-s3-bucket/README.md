# Attack Scenario 03: Public S3 Bucket

## 🎯 Attack Description

**Threat:** Misconfigured cloud storage exposing sensitive data to the internet

**Real-World Examples:**

- Capital One breach (2019): 100+ million records exposed via misconfigured S3
- Accenture (2017): 137 GB of data in public S3 buckets
- Verizon (2017): 14 million customer records in public S3 bucket
- GoDaddy (2020): Backup files exposed in public S3 bucket

**Impact:**

- CRITICAL: Complete data breach
- Regulatory fines (GDPR: up to 4% of revenue)
- Reputational damage
- Customer data theft

## 🛡️ Defense

**Tools:**

- Checkov (policy-as-code for Terraform)
- tfsec (static analysis for Terraform)

**How it works:**

1. Parse Terraform HCL files
2. Check against 1000+ built-in policies
3. Detect misconfigurations before deployment
4. Fail CI/CD if violations found

**Policies Enforced:**

- ✅ No public ACLs
- ✅ Block public access enabled
- ✅ Encryption at rest required
- ✅ Versioning enabled
- ✅ Access logging enabled
- ✅ No public bucket policies

## ✅ Test

```bash
cd attack-scenarios/03-public-s3-bucket
./test.sh
```

**Expected Result:** Insecure Terraform rejected with multiple violations

## 📊 Violations Found

**Insecure Configuration:**

1. ❌ Public ACL (public-read)
2. ❌ No encryption
3. ❌ Public access block disabled
4. ❌ No versioning
5. ❌ No logging
6. ❌ Bucket policy allows public access

**Secure Configuration:**

- ✅ Private ACL
- ✅ AES256 encryption
- ✅ Public access blocked
- ✅ Versioning enabled
- ✅ Access logging to separate bucket
- ✅ Lifecycle policies for log retention

## 🔗 References

- [AWS S3 Security Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
- [Checkov S3 Policies](https://www.checkov.io/5.Policy%20Index/aws.html)
- [tfsec AWS Checks](https://aquasecurity.github.io/tfsec/latest/checks/aws/)
