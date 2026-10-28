#!/bin/bash
# Copyright (C) 2026 Valentina Solange Vispo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e

echo "🛡️ Starting Aegis-Shift Trivy Scanner..."
echo "🔍 Target severities: $SEVERITY"

set +e

# Execute Trivy via Docker in filesystem (fs) mode
docker run --rm \
  -v "$WORKSPACE:/src:ro" \
  aquasec/trivy:latest \
  fs \
  --scanners vuln,misconfig \
  --severity "$SEVERITY" \
  --exit-code 1 \
  --no-progress \
  /src

EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
  echo "❌ Trivy analysis failed. Vulnerable dependencies or misconfigurations detected."
  exit $EXIT_CODE
fi

echo "✅ Trivy completed cleanly. No critical vulnerabilities found."
exit 0