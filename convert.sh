#!/usr/bin/env bash

set -euo pipefail

function usage() {
  echo "This script converts a csv file to json."
  echo "It converts the first csv file that it finds in the current working dir"
  exit
}

while getopts :xh flag
do
  case ${flag} in
    x) set -x;;
    h) usage;;
  esac
done

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

for exe in cat python jq ls grep head; do
  check_for_exe "$exe"
done

csvname=$(ls | grep -E '\.csv$' | head -1)
jsonname="data.json"

# Convert CSV
cat "${csvname:-data.csv}" | python -c 'import csv, json, sys; print(json.dumps([dict(r) for r in csv.DictReader(sys.stdin)]))' > "$jsonname"

# Print json
cat "$jsonname" | jq .
