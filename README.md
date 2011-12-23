# Dotfiles

My linux / OS X dotfiles. This is a work in progress, as I'm currently rebuilding my system!

## Structure
When `dotfiles` is run:

* The `~/.dotfiles` directory is created (first run only)
* Files in `init` are executed
* Files in `copy` are copied into `~`
* Files in `link` are linked into `~`
* Files in `backups` are those that would have been overwritten by `copy` or `link` **

In addition:

* Files in `bin` are executable shell scripts (`bin` is added into the path)
* Files in `source` get sourced when a new shell is opened
* Files in `conf` just sit there, link to them explicitly
* Files in `caches` are cached files (only used by some scripts) **

_** these directories are created only when necessary_

## Commands
* `dotfiles` - (re)initialize dotfiles
* `src` - (re)source all files in `source` directory

## Installation
`bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc`

## The "init" step
In OS X, these things will be installed, but _only_ if they aren't already.

* Homebrew
  * Git
  * Node
  * Npm
  * RBEnv
  * Tree
  * Sl
* Npm
  * Nave
  * JSHint
  * Uglify-JS

(more to come)

I haven't gotten to the linux part yet.

## The "copy" step
Any file in the `copy` subdirectory will be copied into `~`. Any file that _needs_ to be modified with personal information (like [.gitconfig](https://github.com/cowboy/dotfiles/blob/master/copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit it!

## What about the "source" directory?
To keep things easy, the `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc into one of the files in the `source` directory, or add a new file. They're all automatically sourced when a new shell is opened. Take a look, I have [a lot of aliases](https://github.com/cowboy/dotfiles/tree/master/source).

## Inspiration
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>

## License
Copyright (c) 2011 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>

