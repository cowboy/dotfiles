#!/bin/bash

echo 'Dotfiles - "Cowboy" Ben Alman - http://benalman.com/'

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP

Usage: $(basename "$0")

See the README for documentation.
https://github.com/cowboy/dotfiles

Copyright (c) 2012 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/
HELP
exit; fi

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;33m➜\033[0m  $@"; }

# Given a list of desired items and installed items, return a list
# of uninstalled items. Arrays in bash are insane (not in a good way).
function to_install() {
  local debug desired installed i desired_s installed_s remain
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  # Convert args to arrays, handling both space- and newline-separated lists.
  read -ra desired < <(echo "$1" | tr '\n' ' ')
  read -ra installed < <(echo "$2" | tr '\n' ' ')
  # Sort desired and installed arrays.
  unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
    printf "%s\n" "${desired[@]}" | sort
  )
  unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
    printf "%s\n" "${installed[@]}" | sort
  )
  # Get the difference. comm is awesome.
  unset i; while read -r; do remain[i++]=$REPLY; done < <(
    comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
  )
  [[ "$debug" ]] && for v in desired desired_s installed installed_s remain; do
    echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")"
  done
  echo "${remain[@]}"
}

# Offer the user a chance to skip something.
function skip() {
  REPLY=noskip
  read -t 5 -n 1 -s -p "To skip, press X within 5 seconds. "
  if [[ "$REPLY" =~ ^[Xx]$ ]]; then
    echo "Skipping!"
  else
    echo "Continuing..."
    return 1
  fi
}

# Initialize.
function init_do() {
  source "$2"
}

# Copy files.
function copy_header() { e_header "Copying files into home directory"; }
function copy_test() {
  if [[ -e "$2" && ! "$(cmp "$1" "$2" 2> /dev/null)" ]]; then
    echo "same file"
  elif [[ "$1" -ot "$2" ]]; then
    echo "destination file newer"
  fi
}
function copy_do() {
  e_success "Copying ~/$1."
  cp "$2" ~/
}

# Link files.
function link_header() { e_header "Linking files into home directory"; }
function link_test() {
  [[ "$1" -ef "$2" ]] && echo "same file"
}
function link_do() {
  e_success "Linking ~/$1."
  ln -sf ${2#$HOME/} ~/
}

# Copy, link, init, etc.
function do_stuff() {
  local base dest skip
  local files=(~/.dotfiles/$1/*)
  # No files? abort.
  if (( ${#files[@]} == 0 )); then return; fi
  # Run _header function only if declared.
  [[ $(declare -f "$1_header") ]] && "$1_header"
  # Iterate over files.
  for file in "${files[@]}"; do
    base="$(basename $file)"
    dest="$HOME/$base"
    # Run _test function only if declared.
    if [[ $(declare -f "$1_test") ]]; then
      # If _test function returns a string, skip file and print that message.
      skip="$("$1_test" "$file" "$dest")"
      if [[ "$skip" ]]; then
        e_error "Skipping ~/$base, $skip."
        continue
      fi
      # Destination file already exists in ~/. Back it up!
      if [[ -e "$dest" ]]; then
        e_arrow "Backing up ~/$base."
        # Set backup flag, so a nice message can be shown at the end.
        backup=1
        # Create backup dir if it doesn't already exist.
        [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"
        # Backup file / link / whatever.
        mv "$dest" "$backup_dir"
      fi
    fi
    # Do stuff.
    "$1_do" "$base" "$file"
  done
}

# Enough with the functions, let's do stuff.

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
  e_error "The XCode Command Line Tools must be installed first."
  exit 1
fi

# If Git is not installed...
if [[ ! "$(type -P git)" ]]; then
  # OSX
  if [[ "$OSTYPE" =~ ^darwin ]]; then
    # It's easiest to get Git via Homebrew, so get that first.
    if [[ ! "$(type -P brew)" ]]; then
      e_header "Installing Homebrew"
      true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
    fi
    # If Homebrew was installed, install Git.
    if [[ "$(type -P brew)" ]]; then
      e_header "Updating Homebrew"
      brew update
      e_header "Installing Git"
      brew install git
    fi
  # Ubuntu.
  elif [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
    # Git is fairly easy.
    e_header "Installing Git"
    sudo apt-get -qq install git-core
  fi
fi

# If Git isn't installed by now, something exploded. We gots to quit!
if [[ ! "$(type -P git)" ]]; then
  e_error "Git should be installed. It isn't. Aborting."
  exit 1
fi

# Update existing sudo time stamp if set, otherwise do nothing.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Initialize.
if [[ ! -d ~/.dotfiles ]]; then
  new_dotfiles_install=1
  # ~/.dotfiles doesn't exist? Clone it!
  e_header "Downloading dotfiles"
  git clone --recursive git://github.com/cowboy/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
else
  # Make sure we have the latest files.
  e_header "Updating dotfiles"
  cd ~/.dotfiles
  git pull
  git submodule update --init --recursive --quiet
fi

# Utilities, helpers.
source ~/.dotfiles/source/10_misc.sh

# Add binaries into the path
PATH=~/.dotfiles/bin:$PATH
export PATH

# Tweak file globbing.
shopt -s dotglob
shopt -s nullglob

# Create caches directory, if it doesn't already exist.
mkdir -p "$HOME/.dotfiles/caches"

# If backups are needed, this is where they'll go.
backup_dir="$HOME/.dotfiles/backups/$(date "+%Y_%m_%d-%H_%M_%S")/"
backup=

# Execute code for each file in these subdirectories.
do_stuff "init"
do_stuff "copy"
do_stuff "link"

# Alert if backups were made.
if [[ "$backup" ]]; then
  echo -e "\nBackups were moved to ~/${backup_dir#$HOME/}"
fi

# Lest I forget to do a few additional things...
if [[ "$new_dotfiles_install" && -e "conf/firsttime_reminder.sh" ]]; then
  e_header "First-Time Reminders"
  source "conf/firsttime_reminder.sh"
fi

# All done!
e_header "All done!"
