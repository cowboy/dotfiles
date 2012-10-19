# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Always use color output for `ls`
if [[ "$OSTYPE" =~ ^darwin ]]; then
  alias ls="command ls -G"
else
  alias ls="command ls --color"
  export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
fi

# Directory listing
if [[ "$(type -P tree)" ]]; then
  alias ll='tree --dirsfirst -aLpughDFiC 1'
  alias lsd='ll -d'
else
  alias ll='ls -al'
  alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Create a new directory and enter it
function md() {
  mkdir -p "$@" && cd "$@"
}

# Do something inside each directory under the current directory.
function eachdir() {
  local d dashes
  local dirs=()
  # dirs defaults to */ but you can do this:
  # eachdir dir1 dir2 [etc] -- arg1 arg2 [etc]
  for d in "$@"; do
    if [[ "$d" == "--" ]]; then
      dashes=1
      shift $(( ${#dirs[@]} + 1 ))
      break
    fi
    dirs=("${dirs[@]}" "$d")
  done
  [[ "$dashes" ]] || dirs=(*/)
  local h1="$(tput smul)"
  local h2="$(tput rmul)"
  local nops=()
  # Do stuff for each specified dir, in each dir. Non-dirs are ignored.
  for d in "${dirs[@]}"; do
    [[ ! -d "$d" ]] && continue
    d="${d%/}"
    local output="$( (cd "$d"; eval "$@") 2>&1 )"
    if [[ "$output" ]]; then
      echo -e "${h1}${d}${h2}\n$output\n"
    else
      nops=("${nops[@]}" "$d")
    fi
  done
  # List any dirs that had no output.
  if [[ ${#nops[@]} > 0 ]]; then
    echo "${h1}no output from${h2}"
    for d in "${nops[@]}"; do echo "${d}"; done
  fi
}

# Fast directory switching
_Z_NO_PROMPT_COMMAND=1
_Z_DATA=~/.dotfiles/caches/.z
. ~/.dotfiles/libs/z/z.sh
