# Exit if rbenv is not installed.
[[ ! "$(type -P rbenv)" ]] && e_error "Gems failed to install." && return 1

# Ruby gems
gems=(
  xcodeproj
  xcoder
  liftoff
  crafter
  xcpretty
  xclisten
  bwoken
  cocoapods
  twine
  cocoadex
  nomad-cli
  fui
  htty
  docstat
  synx
  mayday
  deliver
  sigh
  pem
  frameit
  snapshot
  storyboardlint
)

# Install Ruby gems.
gems=($(setdiff "${gems[*]}" "$(gems list 2>/dev/null)"))
if (( ${#gems[@]} > 0 )); then
  e_header "Installing Ruby gems: ${gems[*]}"
  for gem in "${gems[@]}"; do
    gem install --no-ri --no-doc $gem
  done
  gem cleanup
fi