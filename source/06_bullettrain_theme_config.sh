# Bullet Train theme configuration
# https://github.com/caiogondim/bullet-train-oh-my-zsh-theme
BULLETTRAIN_DIR_EXTENDED=0
BULLETTRAIN_PROMPT_SEPARATE_LINE=false

# Show context, colored to indicate whether local or remote
BULLETTRAIN_CONTEXT_SHOW=true
if [ ! -n "${SSH_CLIENT+1}" ]; then
  BULLETTRAIN_CONTEXT_BG=cyan
  BULLETTRAIN_CONTEXT_FG=black
else
  BULLETTRAIN_CONTEXT_BG=magenta
  BULLETTRAIN_CONTEXT_FG=white
fi

# Ignore all git status except for ahead/behind/diverged
BULLETTRAIN_GIT_ADDED=""
BULLETTRAIN_GIT_MODIFIED=""
BULLETTRAIN_GIT_DELETED=""
BULLETTRAIN_GIT_UNTRACKED=""
BULLETTRAIN_GIT_RENAMED=""
BULLETTRAIN_GIT_UNMERGED=""
BULLETTRAIN_GIT_DIRTY=""
BULLETTRAIN_GIT_CLEAN=""

# Change color on the git directory being dirty or staged
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_GIT_REPO_BG=blue
BULLETTRAIN_GIT_REPO_FG=white

# Set prompt order
BULLETTRAIN_PROMPT_ORDER=( time status context git line_sep dir )
