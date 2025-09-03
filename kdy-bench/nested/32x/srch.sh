#!/bin/bash

PARAMS_FILE="/home/ssm-user/kdy-bench/nested/32x/osb-config.json"
TARGET_HOST="https://search-kdy-gpu-fp16-e2e-3-sttl7anaglpqvonpjt7smc5cfu.us-west-2.es-staging.amazonaws.com" # baseline

opensearch-benchmark execute-test \
        --pipeline=benchmark-only \
        --workload=vectorsearch \
        --target-host="${TARGET_HOST}" \
        --results-format=csv \
        --test-procedure=search-only \
        --results-file=results_with_mem_opt_srch.csv \
        --workload-params ${PARAMS_FILE} \
        --pipeline benchmark-only \
        --client-options="basic_auth_user:'pfUser',basic_auth_password:'pfUser@123',max_retries:5,retry_on_timeout:true,retry_on_error:True,timeout:900" \
        --kill-running-processes

# For search only performance bench
# Just add --test-procedure=search-only
# --client-options="basic_auth_user:'pfUser',basic_auth_password:'pfUser@123'" \
# For csv, use --results-format=csv
