# Exit if rbenv is not installed.
[[ ! "$(type -P rbenv)" ]] && e_error "Gems failed to install." && return 1

# Ruby gems
gems=(
  bwoken
  cocoadex
  cocoapods
  crafter
  deliver
  docstat
  fastlane
  frameit
  fui
  htty
  jekyll
  liftoff
  lunchy
  mayday
  nomad-cli
  pem
  sigh
  slather
  snapshot
  storyboardlint
  synx
  twine
  veewee
  xclisten
  xcodeproj
  xcoder
  xcpretty
)

# Install Ruby gems.
gems=($(setdiff "${gems[*]}" "$(gems list 2>/dev/null)"))
if (( ${#gems[@]} > 0 )); then
  e_header "Installing Ruby gems: ${gems[*]}"
  gem install ${gems[*]}
  gem cleanup
fi
