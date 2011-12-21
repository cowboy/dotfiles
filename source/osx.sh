# OSX-only stuff. Abort if not OSX.
if [[ ! "$OSTYPE" =~ ^darwin ]]; then
  return
fi

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"
