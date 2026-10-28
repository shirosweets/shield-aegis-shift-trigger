
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-v5-undefined.svg?logo=github&logoColor=white&style=flat)](https://github.com/marketplace/actions/codecov)
![License](https://img.shields.io/github/license/shirosweets/shield-aegis-shift-trigger)

# SAST: Shield Aegis Shift Trigger (Static Application Security Testing) 🛡️

## Action Inputs (Arguments)

Configure the behavior of the SAST scanners by passing these inputs through the with: block in your workflow.

> Path: uses: your-username/aegis-shift/sast@v1

| Input | Description | Required | Default |
| --- | --- | --- | --- | 
| target_dir | Directory to scan inside the mounted workspace. | No | /src |
| semgrep_rules | Semgrep ruleset to apply (e.g., p/default, p/golang). | No | /p/default |
| trivy_severity | Vulnerability severities to fail the pipeline. | No | HIGH,CRITICAL |

## 🔐 Environment Variables (Optional)

If you need to connect your pipelines to external dashboards, you can map repository secrets to the action's environment.

| Variable | Description |
| SEMGREP_APP_TOKEN | Required only if you are using the Semgrep AppSec Platform to track findings historically. Map this from your GitHub Secrets to allow the CLI to push results to your dashboard. |

## 💡 Integration Example

```yml
name: Continuous Integration - Security

on:
  pull_request:
    branches: [ "main" ]

jobs:
  static-security-analysis:
    name: Aegis-Shift SAST Scan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Run T.O.A.S.T. Static Scanners
        uses: your-username/aegis-shift/sast@v1
        with:
          target_dir: '.'
          # Applying language-specific rules and strict security audits
          semgrep_rules: 'p/golang p/security-audit p/secrets'
          # Failing the pipeline even on MEDIUM severity dependencies
          trivy_severity: 'MEDIUM,HIGH,CRITICAL'
```