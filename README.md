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
name: Continuous Integration - SAST - Security

on:
  push:
    branches: [ "main" ]
  pull_request:
    # Triggers the scan on every PR targeting the main branch (Quality Gate)
    branches: [ "main" ]

jobs:
  static-security-analysis:
    name: Shield Aegis Shift Trigger Scan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v7

      - name: Run Static Scanners
        uses: shirosweets/shield-aegis-shift-trigger@v1
        with:
          target_dir: '.'
          # Applying language-specific rules and strict security audits
          semgrep_rules: 'p/security-audit p/secrets'
          # Failing the pipeline even on MEDIUM severity dependencies
          trivy_severity: 'MEDIUM,HIGH,CRITICAL'
          trivy_scanners: 'vuln,misconfig,secret'
          ignore_unfixed: 'true'
          # Change to 'false' if you want to audit legacy code without fails CI/CD
          blocking: 'true'
```