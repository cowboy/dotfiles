# Dotfiles

My linux / OS X dotfiles. This is a work in progress, as I'm currently rebuilding my system!

## Structure
* Files in `link` are linked into `~`
* Files in `copy` are copied into `~`
* Files in `bin` are executables (`bin` is added into the path)
* Files in `source` are sourced when a shell is opened
* Files in `conf` just sit there
* Files in `backups` are backups (from the copy/link process) **
* Files in `caches` are cached files (used by some scripts) **

_** these directories are created only when necessary_

## Commands
* `dotfiles` - (re)initialize dotfiles
* `src` - (re)source all files in `source` directory

## Installation
`bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

## Example Output
```
[cowboy@Bens-MacBook-Pro:~]
[22:31:12] $ ssh test.benalman.com
Welcome to Ubuntu 11.04 (GNU/Linux 2.6.35.4-rscloud x86_64)

cowboy@totoro:~$ bash -c "$(curl -s https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
Downloading files...
Cloning into /home/cowboy/.dotfiles...
remote: Counting objects: 104, done.
remote: Compressing objects: 100% (72/72), done.
remote: Total 104 (delta 49), reused 79 (delta 24)
Receiving objects: 100% (104/104), 40.11 KiB, done.
Resolving deltas: 100% (49/49), done.
Submodule 'libs/ack' (git://github.com/petdance/ack.git) registered for path 'libs/ack'
Cloning into libs/ack...
remote: Counting objects: 5367, done.
remote: Compressing objects: 100% (1450/1450), done.
remote: Total 5367 (delta 3996), reused 5262 (delta 3903)
Receiving objects: 100% (5367/5367), 886.48 KiB, done.
Resolving deltas: 100% (3996/3996), done.
Submodule path 'libs/ack': checked out 'a1d233a27b76a6b8b19fad00c59828388800b4d6'

Copying files into home directory...
 ✔  Copying ~/.gitconfig.

Linking files into home directory...
 ✔  Linking ~/.ackrc.
 ✔  Linking ~/.aprc.
 ✔  Linking ~/.bash_profile.
 ➜  Backing up ~/.bashrc.
 ✔  Linking ~/.bashrc.
 ✔  Linking ~/.toprc.

Backups were moved to ~/.dotfiles/backups/2011_12_22-03_33_01/

All done!

[cowboy@totoro:~]
[03:33:01] $ dotfiles
Updating files...
From git://github.com/cowboy/dotfiles
 * branch            master     -> FETCH_HEAD
Already up-to-date.

Copying files into home directory...
 ✖  Skipping ~/.gitconfig, same file.

Linking files into home directory...
 ✖  Skipping ~/.ackrc, same file.
 ✖  Skipping ~/.aprc, same file.
 ✖  Skipping ~/.bash_profile, same file.
 ✖  Skipping ~/.bashrc, same file.
 ✖  Skipping ~/.toprc, same file.

All done!
```

## Sources
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>

## License
Copyright (c) 2011 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>

