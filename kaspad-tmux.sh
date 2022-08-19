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
$TMUX set-option -g prefix C-a
$TMUX bind-key C-a send-prefix
$TMUX set-option -t "$SESSION" -g pane-border-format " [ ###P #T ] "

# message text
#$TMUX set -g message-style bg='#44475a',fg='#8be9fd'

#$TMUX set -g status-style bg='#44475a',fg='#bd93f9'
#$TMUX set -g status-interval 1

# status left
# are we controlling tmux or the content of the panes?

#tmux set-option -t KASPA-kaspanode -g status-left-length 50

#$TMUX set-option -t "$SESSION" status-left '#[bg=#f8f8f2]#[fg=#282a36]#{?client_prefix,#[bg=#ff79c6],} ☺ Use Ctrl-a d to disconnect'


$TMUX set-option -t "$SESSION" status on
$TMUX set-option -t "$SESSION" status-interval 1
$TMUX set-option -t "$SESSION" status-justify centre
$TMUX set-option -t "$SESSION" status-keys vi
$TMUX set-option -t "$SESSION" status-position bottom
$TMUX set-option -t "$SESSION" status-style fg=colour136,bg=colour235
$TMUX set-option -t "$SESSION" status-left-length 20
$TMUX set-option -t "$SESSION" status-left-style default
$TMUX set-option -t "$SESSION" status-left "#[fg=green]#H #[fg=black]• #[fg=green,bright]#(uname -r)#[default]"
$TMUX set-option -t "$SESSION" status-right-length 140
$TMUX set-option -t "$SESSION" status-right-style default
$TMUX set-option -t "$SESSION" status-right "#[fg=blue,bg=default,bright]#(tmux-mem-cpu-load) "
$TMUX set-option -t "$SESSION" -a status-right "#[fg=red,dim,bg=default]#(uptime | cut -f 4-5 -d ' ' | cut -f 1 -d ',') "
$TMUX set-option -t "$SESSION" -a status-right " #[fg=white,bg=default]%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d"
$TMUX set-window-option -t "$SESSION" window-status-style fg=colour244
$TMUX set-window-option -t "$SESSION" window-status-style bg=default
$TMUX set-window-option -t "$SESSION" window-status-current-style fg=colour166
$TMUX set-window-option -t "$SESSION" window-status-current-style bg=default







# are we zoomed into a pane?
#$TMUX set -ga status-left '#[bg=#44475a]#[fg=#ff79c6] #{?window_zoomed_flag, ↕  ,   }'

# window status
#$TMUX set-window-option -g window-status-style fg='#bd93f9',bg=default
#$TMUX set-window-option -g window-status-current-style fg='#ff79c6',bg='#282a36'

#$#TMUX set -g window-status-current-format "#[fg=#44475a]#[bg=#bd93f9]#[fg=#f8f8f2]#[bg=#bd93f9] #I #W #[fg=#bd93f9]#[bg=#44475a]"
#$TMUX set -g window-status-format "#[fg=#f8f8f2]#[bg=#44475a]#I #W #[fg=#44475a] "

# status right
#$TMUX set -g status-right '#[fg=#8be9fd,bg=#44475a]#[fg=#44475a,bg=#8be9fd] #(tmux-mem-cpu-load -g 5 --interval 2) '
#$TMUX set -ga status-right '#[fg=#ff79c6,bg=#8be9fd]#[fg=#44475a,bg=#ff79c6] #(uptime | cut -f 4-5 -d " " | cut -f 1 -d ",") '
#$TMUX set -ga status-right '#[fg=#bd93f9,bg=#ff79c6]#[fg=#f8f8f2,bg=#bd93f9] %a %H:%M:%S #[fg=#6272a4]%Y-%m-%d '


# # panes
# $TMUX set-option -t "$SESSION" pane-border-style 'fg=colour19 bg=colour0'
# $TMUX set-option -t "$SESSION" pane-active-border-style 'bg=colour0 fg=colour9'
#
# # statusbar
# $TMUX set-option -t "$SESSION" status-position bottom
# $TMUX set-option -t "$SESSION" status-justify left
# $TMUX set-option -t "$SESSION" status-style 'bg=colour18 fg=colour137 dim'
# $TMUX set-option -t "$SESSION" status-left ''
# $TMUX set-option -t "$SESSION" status-right '#[fg=colour233,bg=colour19] %d/%m #[fg=colour233,bg=colour8] %H:%M:%S '
# $TMUX set-option -t "$SESSION" status-right-length 50
# $TMUX set-option -t "$SESSION" status-left-length 20
#
# $TMUX set-option -t "$SESSION" -w window-status-current-style 'fg=colour1 bg=colour19 bold'
# $TMUX set-option -t "$SESSION" -w window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
#
# $TMUX set-option -t "$SESSION" -w window-status-style 'fg=colour9 bg=colour18'
# $TMUX set-option -t "$SESSION" -w window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
#
# $TMUX set-option -t "$SESSION" -w window-status-bell-style 'fg=colour255 bg=colour1 bold'






$TMUX rename-window -t $SESSION:0 'Hit Ctrl+a d to disconnect'
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
