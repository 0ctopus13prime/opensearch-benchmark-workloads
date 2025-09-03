#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

echo "SCRIPT_DIR=$SCRIPT_DIR"

for file in $(find $SCRIPT_DIR -type f -name "run.sh"); do
        echo "Found: $file"

        # Ex: file -> /home/ssm-user/kdy-bench/plain/fp16/run.sh
        target_dir=$(dirname $file)
        cd $target_dir

        # 1. Dump stats
        curl -u pfUser:pfUser@123 https://search-kdy-gpu-fp16-e2e-3-sttl7anaglpqvonpjt7smc5cfu.us-west-2.es-staging.amazonaws.com/_plugins/_knn/stats | jq . > stats1.json

        # 2. Executing run
        echo "Executing run file, I'm at $(pwd)"
        ./run.sh

        # 3. Dump stats
        curl -u pfUser:pfUser@123 https://search-kdy-gpu-fp16-e2e-3-sttl7anaglpqvonpjt7smc5cfu.us-west-2.es-staging.amazonaws.com/_plugins/_knn/stats | jq . > stats2.json

        # 4. Compare stats
        python3 /home/ssm-user/kdy-bench/stats_diff.py stats1.json stats2.json > stats_diff.json

        # 5. Turn on mem opt srch + do search
        echo "Running mem-opt-srch, I'm at $(pwd)"
        /home/ssm-user/kdy-bench/mem_opt_srch.sh true
        ./srch.sh

        # 6. Run CPU index
        echo "Running CPU indexing + srch, I'm at $(pwd)"
        ./run.sh --isgpu false

        cd $SCRIPT_DIR
done
