[[ "$1" != init && ! -e ~/.volta ]] && return 1

export VOLTA_HOME=~/.volta
grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"

# Use npx instead of installing global npm modules
function make_npx_alias () {
  alias $1="npx $@"
}

make_npx_alias json2yaml
make_npx_alias pushstate-server
make_npx_alias yaml2json
