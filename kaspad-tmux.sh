#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }
SESSION="KASPA-$HOSTNAME"

# kaspa Binary location
KBIN="#HOME/go/bin"

echo "Attempting to start Session"
$TMUX -q new-session -d -s "$SESSION" > /dev/null

if [ $? -eq 1 ]
then
	$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
fi


$TMUX -q split-window -t "$SESSION" "printf '\033]2;%s\033\\' 'WalletBalance' ; kaspawallet balance"
$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
