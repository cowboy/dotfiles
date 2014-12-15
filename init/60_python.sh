# Exit if pip is not installed.
[[ ! "$(type -P pip)" ]] && e_error "Python libs failed to install." && return 1

# Python libs
libs=(
  ansible
  beautifulsoup
  chinadns
  django
  flask
  gevent
  git-sweep
  lxml
  nose
  numpy
  pillow
  requests
  scipy
  scrapy
  shadowsocks
  sphinx
  sqlalchemy
  stormssh
  tornado
  twisted
  virtualenv
)

# Install Python libs.
libs=($(setdiff "${libs[*]}" "$(pip list 2>/dev/null)"))
if (( ${#libs[@]} > 0 )); then
  e_header "Installing Python modules: ${libs[*]}"
  pip install -q ${libs[*]}
fi