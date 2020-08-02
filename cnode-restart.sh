#!/bin/bash
#Kill and restart node

killall cardano-node
sleep 5

#kill tmux session
tmux kill-session -t relay

#restart node
SCRIPT_PATH="/opt/cardano/cnode/scripts/cnode.sh"

tmux new -s "relay" -d
tmux send-keys -t "relay" "$SCRIPT_PATH" C-m
tmux attach -t "relay" -d
