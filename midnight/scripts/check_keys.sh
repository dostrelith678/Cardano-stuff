#!/bin/bash
#set -x 
#
# this script checks if your node has the keys in partner-chains-public-keys.json
#

public_keys_file="./partner-chains-public-keys.json"

declare -A items=(
    ["aura"]="aura_pub_key"
    ["gran"]="grandpa_pub_key"
    ["crch"]="sidechain_pub_key"
)

echo "Checking midnight for keys --"

for key in "${!items[@]}"; do
    public_key_name="${items[$key]}"

    public_key_value=$(jq -r ".${public_key_name}" "$public_keys_file")

    echo -n " - does the node have the key for ${public_key_name} ${public_key_value}? "
    curl -H "Content-Type: application/json" \
         -d '{"jsonrpc":"2.0","id":1,"method":"author_hasKey","params":["'${public_key_value}'", "'${key}'"]}' \
         http://localhost:9944 2>/dev/null | jq .result 

done
