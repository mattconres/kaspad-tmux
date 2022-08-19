#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }
SESSION="KASPA-$HOSTNAME"

# kaspa Binary location
KBIN="#HOME/go/bin"

echo "Attempting to start Session"
$TMUX -q new-session -d -s "$SESSION"

# if [ $? -eq 1 ]
# then
# 	$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
# fi


$TMUX -q split-window -t "$SESSION" "printf '\033]2;%s\033\\' 'WalletBalance' ; while true; do ~/go/bin/kaspawallet balance; done"
$TMUX -q select-layout -t "$SESSION" tiled


$TMUX -q kill-pane -t "${SESSION}.0"
$TMUX -q select-pane -t "${SESSION}.0"
$TMUX -q select-layout -t "$SESSION" "$LAYOUT"


$TMUX set-option -t "$SESSION" -g status-style bg=colour235,fg=yellow,dim
$TMUX set-window-option -t "$SESSION" -g window-status-style fg=brightblue,bg=colour236,dim
$TMUX set-window-option -t "$SESSION" -g window-status-current-style fg=brightred,bg=colour236,bright

$TMUX -q set-window-option -t "$SESSION" synchronize-panes on
$TMUX set-option -t "$SESSION" -w pane-border-status bottom

$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
