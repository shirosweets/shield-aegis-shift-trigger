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

echo "🛡️ Starting Shield Aegis Shift Trigger SAST (Semgrep)..."
echo "📜 Rulesets: $RULES"
echo "📂 Target Directory: $TARGET_DIR"
echo "🚦 Blocking Mode: $BLOCKING"

# Parse multiple rulesets into valid Semgrep arguments
CONFIG_ARGS=""
for rule in $RULES; do
  CONFIG_ARGS="$CONFIG_ARGS --config=$rule"
done

# The workspace is mounted to /src. TARGET_DIR is relative to the workspace.
SCAN_PATH="/src/$TARGET_DIR"

# Disable exit-on-error temporarily to evaluate the Semgrep exit code manually
set +e

# Execute Semgrep via Docker
# The $CONFIG_ARGS variable is intentionally left unquoted to expand into multiple parameters
docker run --rm \
  -v "$WORKSPACE:/src:ro" \
  -e SEMGREP_APP_TOKEN \
  semgrep/semgrep \
  semgrep scan $CONFIG_ARGS --error "$SCAN_PATH"

EXIT_CODE=$?
set -e

# Evaluate exit code against the blocking policy
if [ $EXIT_CODE -ne 0 ]; then
  if [ "$BLOCKING" = "true" ]; then
    echo "❌ Static analysis failed. Vulnerabilities or policy violations detected."
    exit $EXIT_CODE
  else
    echo "⚠️ Vulnerabilities found, but BLOCKING mode is disabled (Audit only). Proceeding..."
    exit 0
  fi
fi

echo "✅ SAST completed cleanly. No vulnerabilities found."
exit 0