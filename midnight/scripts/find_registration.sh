#!/bin/bash
#set -x
#
# this utility searches partner chain registrations for your node's aura public key
# once found, the output is the registration data.
#
# to use, place in a directory with partner-chains-public-keys.json
# typically this would be in your partner chain's directory.

rpc_server="https://rpc.testnet-02.midnight.network"

aura_pub_key=$(cat partner-chains-public-keys.json | jq .aura_pub_key)
echo "aura_pub_key=${aura_pub_key}"
current_epoch=$(curl -L -X POST -H "Content-Type: application/json" -d '{
      "jsonrpc": "2.0",
      "method": "sidechain_getStatus",
      "params": [],
      "id": 1
    }' ${rpc_server} 2>/dev/null | jq .result.mainchain.epoch)

look_at_epoch=$((current_epoch + 2))

echo "epoch: current ${current_epoch}, look_at ${look_at_epoch}"
echo

curl -L -X POST -H "Content-Type: application/json" -d '{
      "jsonrpc": "2.0",
      "method": "sidechain_getAriadneParameters",
      "params": ['$look_at_epoch'],
      "id": 1
    }' $rpc_server 2>/dev/null | jq ".result.candidateRegistrations | to_entries[] | select(.value[].auraPubKey == ${aura_pub_key})"
