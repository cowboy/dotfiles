# My bash prompt
#
# Copyright (c) 2011 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:AMU][cowboy@Bens-MacBook-Pro:~/.dotfiles]
# [11:14:45] $
#
# Screenshot:
# http://www.flickr.com/photos/rj3/3959554047/sizes/o/

function prompt_git() {
  local branch=$(
    GITDIR=$(git rev-parse --git-dir 2>/dev/null)
    HEADSHA=$(git rev-parse --verify HEAD 2>/dev/null)
    if [[ ! "$GITDIR" ]]; then
      echo ''
    elif [[ "$HEADSHA" ]]; then
      git branch --no-color 2>/dev/null | awk '/^\*/ { print($2) }'
    else
      echo '(init)'
    fi
  )
  local status=$(
    git status 2>/dev/null | awk 'BEGIN {r=""} \
      /^# Changes to be committed:$/        {r=r "A"}\
      /^# Changes not staged for commit:$/  {r=r "M"}\
      /^# Untracked files:$/                {r=r "U"}\
      END {print(r)}'
  )
  local out=$branch
  if [ "$status" ]; then
    out=$out$3:$2$status
  fi
  if [ "$out" ]; then
    out=$4[$2$out$4]$1
  fi
  echo $out
}

function prompt_svn() {
  svn info . 2>/dev/null | awk "/Revision:/ {r=\$2} /Last Changed Rev:/ {c=\$4; printf(\"$4[$2%d$3:$2%d$4]$1\",c,r)}"
}

function prompt_init() {
  # ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
  #
  # 0   reset
  # 1   bold
  # 4   underline
  # 7   inverse
  #
  # FG  BG  COLOR
  # 30  40  black
  # 31  41  red
  # 32  42  green
  # 33  43  yellow
  # 34  44  blue
  # 35  45  magenta
  # 36  46  cyan
  # 37  47  white

  local text_color
  local sigil_color='37'
  local bracket_color=$sigil_color

  if [ "$SSH_TTY" ]; then             # connected via ssh
    text_color=32
  elif [ "$USER" == "root" ]; then    # logged in as root
    text_color=31
  else                                # connected locally
    text_color=36
  fi

  local C1='\[\e[0m\]'
  local C2='\[\e[0;'$text_color'm\]'
  local C3='\[\e[0;'$sigil_color'm\]'
  local C4='\[\e[0;'$bracket_color'm\]'

export PS1="\n\
\$(prompt_svn '$C1' '$C2' '$C3' '$C4')\
\$(prompt_git '$C1' '$C2' '$C3' '$C4')\
$C4[$C2\u$C3@$C2\h$C3:$C2\w$C4]$C1\n\
$C4[$C2\$(date +%H)$C3:$C2\$(date +%M)$C3:$C2\$(date +%S)$C4]$C1\
 \\$ "
}

prompt_init
