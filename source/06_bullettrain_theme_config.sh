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

# Show Git Repo Name
BULLETTRAIN_GIT_REPO_SHOW=true
BULLETTRAIN_GIT_REPO_CMD="\$(git_repo_name)"
BULLETTRAIN_GIT_REPO_BG=blue
BULLETTRAIN_GIT_REPO_FG=white

# Set prompt order
BULLETTRAIN_PROMPT_ORDER=( time status context git_repo git alt_line_sep dir )

# Output the name of the directory that contains the git repository
# e.g. if repo is '~/src/repo/.git', this gives 'repo' back
function git_repo_name() {
  local repo_path repo_name
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    if [[ "$repo_path" == ".git" ]]; then
      repo_name=$(basename $(pwd));
    else
      repo_name=$(basename $(dirname $repo_path));
    fi
    echo $repo_name
  fi
}

# Output a prompt segment that gives the name of the git repository
prompt_git_repo() {
  local git_repo
  if [[ $BULLETTRAIN_GIT_REPO_SHOW == true ]]; then
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
      eval git_repo=${BULLETTRAIN_GIT_REPO_CMD}
      prompt_segment $BULLETTRAIN_GIT_REPO_BG $BULLETTRAIN_GIT_REPO_FG "${git_repo}"
    fi
  fi
}

# Prompt Line Separator (For some reason the built in doesn't work)
prompt_alt_line_sep() {
  prompt_end
  CURRENT_BG='NONE'
  echo
}
