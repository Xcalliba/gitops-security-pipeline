# Attack Scenario 01: Secrets in Code

## 🎯 Attack Description

**Threat:** Developer accidentally commits hardcoded credentials to version control

**Real-World Examples:**

- Uber breach (2016): Private keys in GitHub repository
- Toyota (2022): Nearly 300,000 customers' data exposed due to access key on GitHub
- Samsung (2019): Entire source code + secrets leaked via public GitHub repos

**Impact:**

- HIGH: Complete compromise of cloud infrastructure
- Data breaches affecting millions of users
- Cryptomining attacks costing thousands per day
- Supply chain compromise

## 🛡️ Defense

**Tool:** Gitleaks

**How it works:**

1. Pre-commit hook scans files before commit
2. Uses regex patterns to detect credential formats
3. Blocks commit if secrets detected
4. CI/CD pipeline runs as backup check

**Configuration:** `.gitleaks.toml` in repository root

## ✅ Test

```bash
cd attack-scenarios/01-secrets-in-code
./test.sh
```

**Expected Result:** Commit blocked, secrets detected

## 📊 Metrics

- **Detection Rate:** 100%
- **False Positive Rate:** <5% (with proper configuration)
- **Time to Detect:** <1 second (pre-commit)

## 🔗 References

- [Gitleaks Documentation](https://github.com/gitleaks/gitleaks)
- [OWASP: Use of Hard-coded Credentials](https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password)
