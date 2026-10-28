# This file is intentionally vulnerable for testing purposes.
# 1. Old vulnerable base image (Trivy vuln scanner)
FROM node:14-alpine

# 2. Hardcoded secret (Trivy secret scanner)
ENV AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"

# 3. Running as root (Trivy misconfig scanner)
USER root

COPY vulnerable-app.js /app/
CMD ["node", "/app/vulnerable-app.js"]