#!/bin/bash

# Usage: ./update_knn_setting.sh true|false

set -e

BASE="$(dirname "$(readlink -f "$0")")"
source $BASE/config

# Configurable parameters
INDEX_NAME="target_index"

# Input validation
if [ "$1" != "true" ] && [ "$1" != "false" ]; then
  echo "Usage: $0 true|false"
  exit 1
fi

FLAG=$1

echo "Closing index: $INDEX_NAME..."
curl $PWD -s -X POST "$OPENSEARCH_HOST/$INDEX_NAME/_close" -w "\n"

echo "Updating setting: index.knn.memory_optimized_search = $FLAG"
curl $PWD -s -X PUT "$OPENSEARCH_HOST/$INDEX_NAME/_settings" \
     -H 'Content-Type: application/json' \
     -d "{
           \"settings\": {
             \"index.knn.memory_optimized_search\": $FLAG
           }
         }" -w "\n"

echo "Reopening index: $INDEX_NAME..."
curl $PWD -s -X POST "$OPENSEARCH_HOST/$INDEX_NAME/_open" -w "\n"

echo "Fetching updated setting..."
curl $PWD -s "$OPENSEARCH_HOST/$INDEX_NAME/_settings/index.knn.memory_optimized_search?pretty"

echo "Done."
