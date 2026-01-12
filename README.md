# GitOps Security Pipeline

> Offense-aware CI/CD that catches real attacks before they reach production

## 🎯 What This Is

A hardened CI/CD pipeline demonstrating:

- ✅ **Secrets scanning** with Gitleaks
- ✅ **SAST** with Semgrep
- ✅ **Container scanning** with Trivy
- ✅ **IaC scanning** with Checkov
- ✅ **Image signing** with Cosign
- ✅ **Policy enforcement** with Conftest/OPA
- ✅ **8 attack scenarios** - all successfully blocked

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/gitops-security-pipeline
cd gitops-security-pipeline

# Run attack simulation
cd attack-scenarios
./run-all-attacks.sh
```

## ⚔️ Attack Scenarios

| #   | Attack               | Tool That Blocks It | Status |
| --- | -------------------- | ------------------- | ------ |
| 1   | Secrets in code      | Gitleaks            | ✅     |
| 2   | Insecure Dockerfile  | Conftest            | ✅     |
| 3   | Public S3 bucket     | Checkov             | ✅     |
| 4   | Unsigned image       | Cosign              | ✅     |
| 5   | Privilege escalation | OPA                 | ✅     |
| 6   | SQL injection        | Semgrep             | ✅     |
| 7   | Container escape     | OPA                 | ✅     |
| 8   | Resource bomb        | OPA                 | ✅     |

## 📊 Architecture

[Architecture diagram coming soon]

## 📚 Documentation

- [Architecture Details](docs/architecture/README.md)
- [Security Controls](docs/security-controls.md)
- [Attack Breakdown](docs/attack-breakdown.md)

## 🎬 Demo

[Demo video coming soon]

## 📝 License

MIT
