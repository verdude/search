#!/usr/bin/env bash

set -euo pipefail

function check_for_exe() {
  set +e
  if [ -z "$1" ]; then
    echo Missing Argument for check_for_exe
    exit 1
  fi
  local exe="$1"

  which "$exe" &>/dev/null
  if [ $? -ne 0 ]; then
    echo Missing "$exe"
    exit 1
  fi
  set -e
}

csvname=$(ls | grep -E '\.csv$' | head -1)
jsonname="data.json"

for exe in cat python jq; do
  check_for_exe "$exe"
done

# Convert CSV
cat "${csvname:-data.csv}" | python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))' > "$jsonname"

