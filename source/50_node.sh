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

function get_last_modified_js_file_recursive() {
  find . -type d \( -name node_modules -o -name .git \) -prune -o -type f \( -name '*.js' -o -name '*.jsx' \) -print0 \
    | xargs -0 stat -f '%m %N' \
    | sort -rn \
    | head -1 \
    | cut -d' ' -f2-
}

function watchlast() {
  yarn watch --testPathPattern "$(get_last_modified_js_file_recursive | sed 's#.*/#/#;s#\..*#\\.#')"
}
