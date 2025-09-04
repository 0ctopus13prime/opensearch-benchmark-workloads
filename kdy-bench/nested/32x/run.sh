#!/bin/bash

set -euo pipefail

BASE="$(dirname "$(readlink -f "$0")")"
source $BASE/../../config

# Default values
isgpu=true

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --isgpu)
      isgpu="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Validate input
if [[ "$isgpu" != "true" && "$isgpu" != "false" ]]; then
  echo "Error: --isgpu must be true or false"
  exit 1
fi

# Example usage
if [[ "$isgpu" == "true" ]]; then
  PARAMS_FILE="$BASE/osb-config.json"
  RESULT_FILE="results.csv"
else
  PARAMS_FILE="$BASE/cpu-osb-config.json"
  RESULT_FILE="cpu-results.csv"
fi

opensearch-benchmark execute-test \
        --pipeline=benchmark-only \
        --workload=vectorsearch \
        --target-host="${OPENSEARCH_HOST}" \
        --workload-params ${PARAMS_FILE} \
        --results-format=csv \
        --results-file=${RESULT_FILE} \
        --pipeline benchmark-only \
        --client-options="$OSB_CLIENT_OPT" \
        --kill-running-processes

# For search only performance bench
# Just add --test-procedure=search-only
# --client-options="basic_auth_user:'pfUser',basic_auth_password:'pfUser@123'" \
# For csv, use --results-format=csv
