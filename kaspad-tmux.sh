#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }

SESSION="KASPA-$HOSTNAME"


$TMUX -q new-session -d -s "$SESSION" > /dev/null
echo "Attempting to start Session"
if [ $? -eq 1 ]
then
	$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
fi


test
