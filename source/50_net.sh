
s() {
    local SSH_TARGET=$1; 
    local SSH_PARAMS="-tt"
    if [[ -z $SSH_TARGET ]]; then
    	SSH_TARGET="dev";
    fi
    ssh $SSH_PARAMS $SSH_TARGET agenttmux attach || agenttmux || tmux attach || tmux || bash
}

sx() {
    local SSH_TARGET=$1; 
    local SSH_PARAMS="-ttX"
    if [[ -z $SSH_TARGET ]]; then
    	SSH_TARGET="dev";
    fi
    ssh $SSH_PARAMS $SSH_TARGET agenttmux attach
}

