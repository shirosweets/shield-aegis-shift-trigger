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

set -e # Stops the script if a critical error occurs

echo "🛡️ Starting Aegis-Shift SAST..."
echo "📜 Ruleset: $RULES"
echo "📂 Scanning workspace..."

# Disable exit-on-error temporarily to evaluate the Semgrep exit code manually
set +e

# Execute Semgrep via Docker. The repository workspace is mounted as read-only at /src
docker run --rm \
  -v "$WORKSPACE:/src:ro" \
  -e SEMGREP_APP_TOKEN \
  semgrep/semgrep \
  semgrep scan --config="$RULES" --error "$TARGET_DIR"

EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
  echo "❌ Static analysis failed. Vulnerabilities or policy violations detected."
  exit $EXIT_CODE
fi

echo "✅ SAST completed cleanly. No vulnerabilities found."
exit 0