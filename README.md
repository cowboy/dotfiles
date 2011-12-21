# Dotfiles

My linux / OS X dotfiles. This is a work in progress, as I'm currently rebuilding my system!

## Structure
* Files in `link` are linked into `~`
* Files in `copy` are copied into `~`
* Files in `bin` are executables (`bin` is added into the path)
* Files in `source` are sourced when a shell is opened
* Files in `conf` just sit there

## Commands
* `dotfiles` - (re)initialize dotfiles
* `src` - (re)source all files in `source` directory

## Installation
`bash -c "$(curl -s https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

## Sources
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>

## License
Copyright (c) 2011 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>

