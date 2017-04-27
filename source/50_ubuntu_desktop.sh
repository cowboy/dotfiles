# Ubuntu desktop-only stuff. Abort if not Ubuntu desktop.
is_ubuntu_desktop || return 1

export BROWSER=google-chrome
alias manh='man -H'

alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'

# http://www.omgubuntu.co.uk/2016/06/install-steam-on-ubuntu-16-04-lts
function steam() {
  if [[ -e ~/.steam ]]; then
    command steam "$@"
  else
    LD_PRELOAD='/usr/$LIB/libstdc++.so.6 /usr/$LIB/libgcc_s.so.1 /usr/$LIB/libxcb.so.1 /usr/$LIB/libgpg-error.so' command steam
  fi
}
