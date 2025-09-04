#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
source $SCRIPT_DIR/../config

echo "SCRIPT_DIR=$SCRIPT_DIR"

for file in $(find $SCRIPT_DIR -type f -name "run.sh"); do
        echo "Found: $file"
        # Ex: file -> /home/ssm-user/kdy-bench/fp16/run.sh
        target_dir=$(dirname $file)
        cd $target_dir

        # 1. Dump stats
        curl $PWD $OPENSEARCH_HOST/_plugins/_knn/stats | jq . > stats1.json

        # 2. Executing run
        echo "Executing run file, I'm at $(pwd)"
        ./run.sh

        # 3. Dump stats
        curl $PWD $OPENSEARCH_HOST/_plugins/_knn/stats | jq . > stats2.json

        # 4. Compare stats
        python3 $SCRIPT_DIR/../stats_diff.py stats1.json stats2.json > stats_diff.json

        # 5. Turn on mem opt srch + do search
        $SCRIPT_DIR/../mem_opt_srch.sh true
        ./srch.sh

        # 6. Run CPU index
        ./run.sh --isgpu false

        cd $SCRIPT_DIR
done
