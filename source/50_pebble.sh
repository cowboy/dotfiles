path=~/pebble-dev/PebbleSDK-current/bin
if [[ -e "$path" ]]; then
  export PATH=$path:"$(path_remove $path)"
fi
