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

echo "🛡️ Starting Shield Aegis Shift Trigger Trivy Scanner..."
echo "📦 Trivy Docker image tag: $TRIVY_VERSION"
echo "🔍 Target severities: $SEVERITY"
echo "🔬 Scanners active: $SCANNERS"
echo "🙈 Ignore unfixed: $IGNORE_UNFIXED"
echo "🚦 Blocking Mode: $BLOCKING"

# Dynamically build Trivy arguments.
TRIVY_ARGS=(--scanners "$SCANNERS" --severity "$SEVERITY" --no-progress)

read -r -a EXCLUDE_DIR_LIST <<< "$EXCLUDE_DIRS"
for dir in "${EXCLUDE_DIR_LIST[@]}"; do
  case "$dir" in
    /*|..|../*|*/..|*/../*)
      echo "❌ Excluded directories must be relative workspace paths: $dir" >&2
      exit 2
      ;;
  esac
  TRIVY_ARGS+=(--skip-dirs "/src/${dir%/}")
done

if [ "$IGNORE_UNFIXED" = "true" ]; then
  TRIVY_ARGS+=(--ignore-unfixed)
fi

if [ "$BLOCKING" = "true" ]; then
  TRIVY_ARGS+=(--exit-code 1)
else
  TRIVY_ARGS+=(--exit-code 0)
fi

SCAN_PATH="/src/$TARGET_DIR"

set +e

# Execute Trivy via Docker in filesystem (fs) mode
docker run --rm \
  -v "$WORKSPACE:/src:ro" \
  "aquasec/trivy:$TRIVY_VERSION" \
  fs "${TRIVY_ARGS[@]}" "$SCAN_PATH"

EXIT_CODE=$?
set -e

if [ $EXIT_CODE -ne 0 ]; then
  # This block will only trigger if BLOCKING is true and vulnerabilities are found,
  # because if BLOCKING is false, Trivy returns exit code 0 natively.
  echo "❌ Trivy analysis failed. Vulnerable dependencies, secrets, or misconfigurations detected."
  exit "$EXIT_CODE"
fi

echo "✅ Trivy completed cleanly or ran in audit mode. Proceeding."
exit 0