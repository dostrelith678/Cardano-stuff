#!/bin/bash
#Kill and restart node

killall cardano-node
sleep 2

#kill tmux session
tmux kill-session -t relay
sleep 2
#restart node
SCRIPT_PATH="/opt/cardano/cnode/scripts/cnode.sh"

tmux new -s "relay" -d
sleep 2
tmux send-keys -t "relay" "$SCRIPT_PATH" C-m
