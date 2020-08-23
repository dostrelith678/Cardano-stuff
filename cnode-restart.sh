#!/bin/bash
#Kill and restart node

killall cardano-node
sleep 3

#kill tmux session
tmux kill-session -t relay

#restart node
SCRIPT_PATH="/opt/cardano/cnode/scripts/cnode-relay.sh"

sleep 1
tmux new -s "relay" -d
sleep 1
tmux send-keys -t "relay" "$SCRIPT_PATH" C-m
