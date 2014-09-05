#!/usr/bin/env bash

function help() {
cat <<HELP
Git Jump (Forward & Back)
http://benalman.com/

Usage: $(basename "$0") [command]

Commands:
  next       Jump forward to the next commit in this branch
  prev       Jump backward to the next commit in this branch
  clean      Remove current unstaged changes/untracked files**
  cleanall   Remove all saved tags, unstaged changes and untracked files**

** This action is destructive and cannot be undone!

Git config:
  git-jump.branch   Branch to jump through. If not set, defaults to master

Description:
  "Replay" Git commits by moving forward / backward through a branch's
  history. Before jumping, any current unstaged changes and untracked
  files are saved in a tag for later retrieval, which is restored when
  jumped back to.

Copyright (c) 2014 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/
HELP
}

function usage() {
  echo "Usage: $(basename "$0") [next | prev | clean | cleanall]"
}

# Get branch stored in Git config or default to master
git_branch="$(git config git-jump.branch || echo "master")"

# Get some (short) SHAs
function git_branch_sha() {
  git rev-parse --short "$git_branch"
}
function git_head_sha() {
  git rev-parse --short HEAD
}
function git_prev_sha() {
  git log --format='%h' "$git_branch" "$@" | awk "/^$(git_head_sha)/{getline; print}"
}
function git_next_sha() {
  git_prev_sha --reverse
}

# Get absolute path to root of Git repo
function git_repo_toplevel() {
  git rev-parse --show-toplevel
}

# Get subject of specified commit
function git_commit_subject() {
  git log --format='%s' -n 1 $1
}

# Save changes for later retrieval
function save() {
  local status=""
  local head_sha=$(git_head_sha)
  # Checkout current HEAD by SHA to force detached state
  git checkout -q $head_sha
  # Add all files in repo
  git add "$(git_repo_toplevel)"
  # Commit changes (if there were any)
  git commit --no-verify -m "Git Jump: saved changes for $head_sha" >/dev/null
  # If the commit was successful, tag it (overwriting any previous tag)
  if [[ $? == 0 ]]; then
    status="*"
    git tag -f "git-jump-$head_sha" >/dev/null
  fi
  echo "Previous HEAD was $head_sha$status, $(git_commit_subject $head_sha)"
}

# Restore previously-saved changes
function restore() {
  local status=""
  # Save current changes before restoring
  save
  # Attempt to restore saved changes for specified commit
  git checkout "git-jump-$1" 2>/dev/null
  if [[ $? == 0 ]]; then
    # If the restore was successful, figure out exactly what was saved, check
    # out the original commit, then restore the saved changes on top of it
    status="*"
    local patch="$(git format-patch HEAD^ --stdout)"
    git checkout HEAD^ 2>/dev/null
    echo "$patch" | git apply -
  else
    # Otherwise, just restore the original commit
    git checkout "$1" 2>/dev/null
  fi
  echo "HEAD is now $1$status, $(git_commit_subject $1)"
}

# Clean (permanently) current changes and remove the current saved tag
function clean() {
  local head_sha=$(git_head_sha)
  git tag -d "git-jump-$head_sha" &>/dev/null
  if [[ $? == 0 ]]; then
    echo "Removed stored data for commit $head_sha."
  fi
  local repo_root="$(git_repo_toplevel)"
  git reset HEAD "$repo_root" >/dev/null
  git clean -f -d -q -- "$repo_root" >/dev/null
  git checkout -- "$repo_root" >/dev/null
  echo "Unstaged changes and untracked files removed."
}

# Remove (permanently) all saved tags
function clean_all_tags() {
  git for-each-ref refs/tags --format='%(refname:short)' | \
  while read tag; do
    if [[ "$tag" =~ ^git-jump- ]]; then
      git tag -d "$tag"
    fi
  done
}

# Jump to next commit
function next() {
  local next_sha=$(git_next_sha)
  if [[ "$next_sha" == "$(git_head_sha)" ]]; then
    # Abort if no more commits
    echo "Already at last commit in $git_branch. Congratulations!"
  else
    # Checkout branch by name if at its HEAD
    if [[ "$next_sha" == "$(git_branch_sha)" ]]; then
      next_sha="$git_branch"
    fi
    echo "Jumping ahead to next commit."
    restore $next_sha
  fi
}

# Jump to previous commit
function prev() {
  local prev_sha=$(git_prev_sha)
  if [[ "$prev_sha" == "$(git_head_sha)" ]]; then
    # Abort if no more commits
    echo "Already at first commit in $git_branch."
  else
    echo "Jumping back to previous commit."
    restore $prev_sha
  fi
}

# Show help if requested
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  help
  exit
fi

# Check if branch is valid
git rev-parse "$git_branch" &>/dev/null
if [[ $? != 0 ]]; then
  echo "Error: Branch \"$git_branch\" does not appear to be valid."
  echo "Try $(basename "$0") --help for more information."
  exit 1
fi

# Handle CLI arguments
if [[ "$1" == "next" ]]; then
  next
elif [[ "$1" == "prev" ]]; then
  prev
elif [[ "$1" == "clean" ]]; then
  clean
elif [[ "$1" == "cleanall" ]]; then
  clean_all_tags
  clean
else
  usage
  exit 1
fi
