#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }
SESSION="KASPA-$HOSTNAME"
NOKILL=1
# kaspa Binary location
KBIN="#HOME/go/bin"


function at_exit() {
	$TMUX kill-session -t "$SESSION" >/dev/null 2>&1
}
[[ "$NOKILL" == "1" ]] || trap at_exit EXIT

echo "Attempting to start Session"
$TMUX -q new-session -d -s "$SESSION"

if [ $? -eq 1 ]
 then
 	$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
 	exit
 fi

$TMUX set-option -t "$SESSION" -q mouse on
#$TMUX set-option -t "$SESSION" -w pane-border-status top

$TMUX set-option -t "$SESSION" -g pane-border-format " [ ###P #T ] "


$TMUX rename-window -t $SESSION:0 'Main'
$TMUX splitw -v -p 10 -t $SESSION:0.0
$TMUX splitw -h -p 80 -t $SESSION:0.1
$TMUX send-keys -t $SESSION:0.0 "while true; do ~/go/bin/kaspawallet balance;sleep 3;done" Enter
$TMUX select-pane -t $SESSION:0.0 -T "Kaspd"
$TMUX send-keys -t $SESSION:0.0 "printf '\033]2;%s\033\\' 'Kaspd'" Enter
$TMUX send-keys -t $SESSION:0.1 "ping 8.8.8.8" Enter
$TMUX send-keys -t $SESSION:0.2 "while true; do ~/go/bin/kaspawallet balance;sleep 3;done" Enter

#$TMUX set-option -t "$SESSION" -g pane-border-format " [ ###P #T ] "


# $TMUX new-window -t $SESSION
# $TMUX splitw -v -p 10 -t $SESSION:0.0
# $TMUX splitw -h -p 80 -t $SESSION:0.1
# $TMUX send-keys -t $SESSION:1.0 "while true; do ~/go/bin/kaspawallet balance;sleep 3; done" Enter

#$TMUX -q split-window -t "$SESSION" "while true; do ~/go/bin/kaspawallet balance;sleep 3; done"
#$TMUX set-option -t "${SESSION}.0" pane-border-format "'WalletBalance1'"
#$TMUX -q split-window -t "$SESSION" "printf '\033]2;%s\033\\' 'WalletBalance2' ; while true; do ~/go/bin/kaspawallet balance;sleep 3; done"
#$TMUX set-option -t "${SESSION}.1" pane-border-format "'WalletBalance10'"
$TMUX -q select-layout -t "$SESSION" tiled


#$TMUX -q kill-pane -t "${SESSION}:0.2"
#$TMUX -q select-pane -t "${SESSION}.0"
#$TMUX -q select-layout -t "$SESSION" "$LAYOUT"



$TMUX set-option -t "$SESSION" -g status-style bg=colour235,fg=yellow,dim
$TMUX set-window-option -t "$SESSION" -g window-status-style fg=brightblue,bg=colour236,dim
$TMUX set-window-option -t "$SESSION" -g window-status-current-style fg=brightred,bg=colour236,bright

#$TMUX -q set-window-option -t "$SESSION" synchronize-panes on
$TMUX set-option -t "$SESSION" -w pane-border-status bottom
$TMUX -q set-option -t "$SESSION" -g status-left "#S #[fg=green,bg=black]#(tmux-mem-cpu-load --colors --interval 2)#[default]"

$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
