# Attack Scenario 02: Insecure Dockerfile

## 🎯 Attack Description

**Threat:** Deploying containers with security misconfigurations

**Common Issues:**

- Using `latest` tags (non-reproducible builds)
- Running as root (privilege escalation risk)
- No health checks (reliability issues)
- Copying entire directory (may include secrets)
- Not cleaning package manager cache (bloated images)
- Exposing unnecessary ports (increased attack surface)

**Real-World Examples:**

- Docker Hub supply chain attacks targeting popular base images
- Cryptomining malware in compromised containers running as root
- Container escapes via kernel exploits (easier when running as root)

**Impact:**

- CRITICAL: Container escape → Node compromise
- HIGH: Privilege escalation
- MEDIUM: Larger attack surface, supply chain risks

## 🛡️ Defense

**Tool:** Conftest with OPA policies

**How it works:**

1. Parse Dockerfile into structured format
2. Apply policy rules written in Rego
3. Fail build if violations found
4. Provide actionable feedback

**Policies Enforced:**

- ✅ No `latest` tags
- ✅ Must specify non-root USER
- ✅ Efficient package management
- ✅ Use COPY instead of ADD
- ✅ Include HEALTHCHECK

## ✅ Test

```bash
cd attack-scenarios/02-insecure-dockerfile
./test.sh
```

**Expected Result:** Insecure Dockerfile rejected, secure Dockerfile approved

## 📊 Comparison

| Issue           | Insecure        | Secure                      |
| --------------- | --------------- | --------------------------- |
| Base Image      | `ubuntu:latest` | `python:3.11-slim-bookworm` |
| User            | `root`          | `appuser` (non-root)        |
| Package Cleanup | ❌ No           | ✅ Yes                      |
| Health Check    | ❌ No           | ✅ Yes                      |
| Exposed Ports   | 5+              | 1 (only needed)             |

## 🔗 References

- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [Conftest Documentation](https://www.conftest.dev/)
