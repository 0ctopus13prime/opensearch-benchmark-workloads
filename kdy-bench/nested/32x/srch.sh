#!/bin/bash

BASE="$(dirname "$(readlink -f "$0")")"
source $BASE/../../config

PARAMS_FILE="$BASE/osb-config.json"

opensearch-benchmark execute-test \
        --pipeline=benchmark-only \
        --workload=vectorsearch \
        --target-host="${OPENSEARCH_HOST}" \
        --results-format=csv \
        --test-procedure=search-only \
        --results-file=results_with_mem_opt_srch.csv \
        --workload-params ${PARAMS_FILE} \
        --pipeline benchmark-only \
        --client-options="$OSB_CLIENT_OPT" \
        --kill-running-processes

# For search only performance bench
# Just add --test-procedure=search-only
# --client-options="basic_auth_user:'pfUser',basic_auth_password:'pfUser@123'" \
# For csv, use --results-format=csv
