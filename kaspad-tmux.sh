#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }

SESSION="KASPA-$HOSTNAME"

echo "Attempting to start Session"
$TMUX -q new-session -d -s "$SESSION" > /dev/null

if [ $? -eq 1 ]
then
	$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
fi

$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
