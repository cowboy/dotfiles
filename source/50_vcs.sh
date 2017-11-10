
# Git shortcuts

alias g='git'
function ga() { git add "${@:-.}"; } # Add all files by default
alias gp='git push'
alias gpa='gp --all'
alias gu='git pull'
alias gl='git log'
alias gg='gl --decorate --oneline --graph --date-order --all'
alias gs='git status'
alias gst='gs'
alias gd='git diff'
alias gdc='gd --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gba='git branch -a'
function gc() { git checkout "${@:-master}"; } # Checkout master by default
alias gco='gc'
alias gcb='gc -b'
alias gbc='gc -b' # Dyslexia
alias gr='git remote'
alias grv='gr -v'
#alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'
alias gcd='git rev-parse 2>/dev/null && cd "./$(git rev-parse --show-cdup)"'

# Current branch or SHA if detached.
alias gbs='git branch | perl -ne '"'"'/^\* (?:\(detached from (.*)\)|(.*))/ && print "$1$2"'"'"''

# Run commands in each subdirectory.
alias gu-all='eachdir git pull'
alias gp-all='eachdir git push'
alias gs-all='eachdir git status'

# Rebase topic branch onto origin parent branch and update local parent branch
# to match origin parent branch
function grbo() {
  local parent topic parent_sha origin_sha
  parent=$1
  topic=$2
  [[ ! "$parent" ]] && _grbo_err "Missing parent branch." && return 1
  parent_sha=$(git rev-parse $parent 2>/dev/null)
  [[ $? != 0 ]] && _grbo_err "Invalid parent branch: $parent" && return 1
  origin_sha=$(git ls-remote origin $parent | awk '{print $1}')
  [[ ! "$origin_sha" ]] && _grbo_err "Invalid origin parent branch: origin/$parent" && return 1
  [[ "$parent_sha" == "$origin_sha" ]] && echo "Same SHA for parent and origin/parent. Nothing to do!" && return
  if [[ "$topic" ]]; then
    git rev-parse "$topic" >/dev/null 2>&1
    [[ $? != 0 ]] && _grbo_err "Invalid topic branch: $topic" && return 1
  else
    topic="$(git rev-parse --abbrev-ref HEAD)"
  fi
  [[ "$topic" == "HEAD" ]] && _grbo_err "Missing or invalid topic branch." && return 1
  [[ "$topic" == "$parent" ]] && _grbo_err "Topic and parent branch must be different!" && return 1
  read -n 1 -r -p "About to rebase $topic onto origin/$parent. Are you sure? [y/N] "
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    git fetch &&
    git rebase --onto origin/$parent $parent "$topic" &&
    git branch -f $parent origin/$parent
  else
    echo "Aborted by user."
  fi
}
function _grbo_err() {
  echo "Error: $@"
  echo "Usage: grbo parent-branch [topic-branch]"
}

# open all changed files (that still actually exist) in the editor
function ged() {
  local files
  local _IFS="$IFS"
  IFS=$'\n' files=($(git diff --name-status "$@" | grep -v '^D' | cut -f2 | sort | uniq))
  IFS="$_IFS"
  echo "Opening files modified $([[ "$2" ]] && echo "between $1 and $2" || echo "since $1")"
  gcd
  q "${files[@]}"
  cd - > /dev/null
}

# add a github remote by github username
function gra() {
  if (( "${#@}" != 1 )); then
    echo "Usage: gra githubuser"
    return 1;
  fi
  local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
  gr add "$1" "git://github.com/$1/$repo"
}

# GitHub URL for current repo.
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local host="$(echo "$remote" | perl -pe 's/.*@//;s/:.*//')"
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://$host/$user_repo"
}
# GitHub URL for current repo, including current branch + path.
alias gurlp='echo $(gurl)/tree/$(gbs)/$(git rev-parse --show-prefix)'

# git log with per-commit cmd-clickable GitHub URLs (iTerm)
function gf() {
  git log $* --name-status --color | awk "$(cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\t$(gurl)/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
  )" | less -F
}

# open last commit in GitHub, in the browser.
function gfu() {
  local n="${@:-1}"
  n=$((n-1))
  git web--browse  $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
}
# open current branch + path in GitHub, in the browser.
alias gpu='git web--browse $(gurlp)'

# Just the last few commits, please!
for n in {1..5}; do alias gf$n="gf -n $n"; done

function gj() { git-jump "${@:-next}"; }
alias gj-='gj prev'

# Combine diff --name-status and --stat
function gstat() {
  local file mode modes color lines range code line_regex
  local file_len graph_len e r c
  range="${1:-HEAD~}"
  echo "Diff name-status & stat for range: $range"
  IFS=$'\n'

  lines=($(git diff --name-status "$range"))
  code=$?; [[ $code != 0 ]] && return $code
  declare -A modes
  for line in "${lines[@]}"; do
    file="$(echo $line | cut -f2)"
    mode=$(echo $line | cut -f1)
    modes["$file"]=$mode
  done

  file_len=0
  lines=($(git diff -M --stat --stat-width=999 "$range"))
  line_regex='s/\s*([^|]+?)\s*\|.*/$1/'
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    (( ${#file} > $file_len )) && file_len=${#file}
  done
  graph_len=$(($COLUMNS-$file_len-10))
  (( $graph_len <= 0 )) && graph_len=1

  lines=($(git diff -M --stat --stat-width=999 --stat-name-width=$file_len \
    --stat-graph-width=$graph_len --color "$range"))
  e=$(echo -e "\033")
  r="$e[0m"
  declare -A c=([M]="1;33" [D]="1;31" [A]="1;32" [R]="1;34")
  for line in "${lines[@]}"; do
    file="$(echo "$line" | perl -pe "$line_regex")"
    if [[ "$file" =~ \{.+\=\>.+\} ]]; then
      mode=R
      line="$(echo "$line" | perl -pe "s/(^|=>|\})/$r$e[${c[R]}m\$1$r$e[${c[A]}m/g")"
      line="$(echo "$line" | perl -pe "s/(\{)/$r$e[${c[R]}m\$1$r$e[${c[D]}m/")"
    else
      mode=${modes["$file"]}
      color=0; [[ "$mode" ]] && color=${c[$mode]}
      line="$e[${color}m$line"
    fi
    echo "$line" | sed "s/\|/$e[0m$mode \|/"
  done
  unset IFS
}

# OSX-specific Git shortcuts
if is_osx; then
  alias gdk='git ksdiff'
  alias gdkc='gdk --cached'
  function gt() {
    local path repo
    {
      pushd "${1:-$PWD}"
      path="$PWD"
      repo="$(git rev-parse --show-toplevel)"
      popd
    } >/dev/null 2>&1
    if [[ -e "$repo" ]]; then
      echo "Opening git repo $repo."
      gittower "$repo"
    else
      echo "Error: $path is not a git repo."
    fi
  }
fi
