export NVM_DIR=~/.nvm
# nvm shell performance fix
nvm()
{
  if [[ `command -v nvm`-ne"nvm" ]]; then
    echo "loading nvm enviroment ..."
    NVM_FOLDER="$(brew --prefix nvm)"
    source "$NVM_FOLDER/nvm.sh"
    # source ~/.nvm/nvm.sh
    nvm $*
  fi
}
