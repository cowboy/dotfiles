# OSX-only stuff. Abort if not OSX.
if [[ ! "$OSTYPE" =~ ^darwin ]]; then
  return
fi

# Apple, why do you put /usr/bin before /usr/local/bin?!
PATH=/usr/local/bin:$PATH
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"
