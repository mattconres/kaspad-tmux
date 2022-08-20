#!/bin/bash
#
#






TMUX=$(type -p tmux) || { echo "This script requires tmux"; exit 1; }
SESSION="KASPA-$HOSTNAME"
NOKILL=1
# kaspa Binary location
KBIN="$HOME/go/bin"


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

# TMUX settings
$TMUX set-option -t "$SESSION" -q mouse on
$TMUX set-option -g prefix C-a
$TMUX bind-key C-a send-prefix
$TMUX set-option -t "$SESSION" -g pane-border-format " [ ###P #T ] "

$TMUX set-option -t "$SESSION" status on
$TMUX set-option -t "$SESSION" status-interval 1
$TMUX set-option -t "$SESSION" status-justify centre
$TMUX set-option -t "$SESSION" status-keys vi
$TMUX set-option -t "$SESSION" status-position bottom
$TMUX set-option -t "$SESSION" status-style fg=white,bg=colour235
$TMUX set-option -t "$SESSION" status-left-length 20
$TMUX set-option -t "$SESSION" status-left-style default
$TMUX set-option -t "$SESSION" status-left "#[fg=green]#H #[fg=black]• #[fg=green,bright]#(uname -r)#[default]"
$TMUX set-option -t "$SESSION" status-right-length 140
$TMUX set-option -t "$SESSION" status-right-style default
$TMUX set-option -t "$SESSION" status-right "#[fg=green,bg=default,bright]#(tmux-mem-cpu-load) "
$TMUX set-option -t "$SESSION" -a status-right "#[fg=red,dim,bg=default]#(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',') "
$TMUX set-option -t "$SESSION" -a status-right " #[fg=white,bg=default]%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d"
$TMUX set-window-option -t "$SESSION" window-status-style fg=colour244
$TMUX set-window-option -t "$SESSION" window-status-style bg=default
$TMUX set-window-option -t "$SESSION" window-status-current-style fg=colour166
$TMUX set-window-option -t "$SESSION" window-status-current-style bg=default


# Start up Panes and commands

$TMUX rename-window -t $SESSION:0 'Hit Ctrl+a d to disconnect'
$TMUX splitw -v -p 10 -t $SESSION:0.0
$TMUX splitw -h -p 80 -t $SESSION:0.1
$TMUX send-keys -t $SESSION:0.0 "$KBIN/kaspad --utxoindex" Enter
$TMUX select-pane -t $SESSION:0.0 -T "Kaspd Daemon"
$TMUX send-keys -t $SESSION:0.1 "$KBIN/kaspawallet start-daemon" Enter
$TMUX select-pane -t $SESSION:0.1 -T "Kaspa Wallet Daemon"
$TMUX send-keys -t $SESSION:0.2 "while true; do ~/go/bin/kaspawallet balance;sleep 30;done" Enter
$TMUX select-pane -t $SESSION:0.2 -T "Kaspa Wallet Balance Loop"

#$TMUX set-option -t "$SESSION" -g status-style bg=colour235,fg=yellow,dim
#$TMUX set-window-option -t "$SESSION" -g window-status-style fg=brightblue,bg=colour236,dim
#$TMUX set-window-option -t "$SESSION" -g window-status-current-style fg=brightred,bg=colour236,bright

#$TMUX -q set-window-option -t "$SESSION" synchronize-panes on
#$TMUX set-option -t "$SESSION" -w pane-border-status bottom
#$TMUX -q set-option -t "$SESSION" -g status-left "#S #[fg=green,bg=black]#(tmux-mem-cpu-load --colors --interval 2)#[default]"

$TMUX -q attach -t "$SESSION" >/dev/null 2>&1
