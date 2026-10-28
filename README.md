[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-v5-undefined.svg?logo=github&logoColor=white&style=flat)](https://github.com/marketplace/actions/codecov)
![License](https://img.shields.io/github/license/shirosweets/shield-aegis-shift-trigger)

# SAST: Shield Aegis Shift Trigger (Static Application Security Testing) 🛡️

## What is Static Application Security Testing (SAST)?

Static Application Security Testing (SAST) analyzes source code and related
project files for security issues without running the application. Finding
potential problems early in the development process helps teams address them
before deployment.

Shield Aegis Shift Trigger combines Semgrep for source-code analysis with
Trivy for dependency vulnerabilities, misconfigurations, and secrets. Configure
the action to fail the workflow when findings are detected, or use audit mode
to report findings without blocking it.

## Action Inputs (Arguments)

Configure the behavior of the SAST scanners by passing these inputs through the `with` block in your workflow.

> Usage: `uses: shirosweets/shield-aegis-shift-trigger@v1`

| Input | Description | Required | Default |
| --- | --- | --- | --- |
| `target_dir` | Relative path to the directory to scan. The repository root is used by default. | No | `.` |
| `semgrep_rules` | Space-separated Semgrep rulesets to apply (e.g., `p/default`, `p/security-audit`, `p/golang`). | No | `p/default p/security-audit` |
| `trivy_severity` | Comma-separated Trivy severity levels to report (e.g., `HIGH,CRITICAL`). | No | `HIGH,CRITICAL` |
| `trivy_version` | Trivy Docker image tag to use. Set a release tag to avoid following the mutable `latest` tag. Docker selects the image variant for the runner architecture automatically. | No | `latest` |
| `trivy_scanners` | Comma-separated Trivy scanners to run: `vuln`, `misconfig`, and/or `secret`. | No | `vuln,misconfig,secret` |
| `ignore_unfixed` | Whether Trivy ignores vulnerabilities without an available fix (`true` or `false`). | No | `true` |
| `blocking` | Whether findings fail the workflow (`true`) or are reported in audit mode (`false`). | No | `true` |

## 🔐 Environment Variables (Optional)

If you need to connect your pipelines to external dashboards, you can map repository secrets to the action's environment.

| Variable | Description |
| --- | --- |
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
        uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1

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

## Policies and guidelines

- [Contributing](CONTRIBUTING.md): guidance for issues, pull requests, and testing changes.
- [Security](SECURITY.md): how to report vulnerabilities privately, safe testing boundaries, and fixture usage.
