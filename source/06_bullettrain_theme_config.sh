# Bullet Train theme configuration
# https://github.com/caiogondim/bullet-train-oh-my-zsh-theme
BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_DIR_EXTENDED=0
BULLETTRAIN_PROMPT_SEPARATE_LINE=false
BULLETTRAIN_TIME_BG=cyan
BULLETTRAIN_TIME=black
if [ ! -n "${SSH_CLIENT+1}" ]; then
  BULLETTRAIN_CONTEXT_BG=yellow
  BULLETTRAIN_CONTEXT_FG=black
else
  BULLETTRAIN_CONTEXT_BG=magenta
  BULLETTRAIN_CONTEXT_FG=white
fi
BULLETTRAIN_PROMPT_ORDER=( time status context git line_sep dir )
