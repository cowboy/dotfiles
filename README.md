# Dotfiles

My OS X / Ubuntu dotfiles.

## Why is this a git repo?

I've been using bash on-and-off for a long time (since Slackware Linux was distributed on 1.44MB floppy disks). In all that time, every time I've set up a new Linux or OS X machine, I've copied over my `.bashrc` file and my `~/bin` folder to each machine manually. And I've never done a very good job of actually maintaining these files. It's been a total mess.

I finally decided that I wanted to be able to execute a single command to "bootstrap" a new system to pull down all of my dotfiles and configs, as well as install all the tools I commonly use. In addition, I wanted to be able to re-execute that command at any time to synchronize anything that might have changed. Finally, I wanted to make it easy to re-integrate changes back in, so that other machines could be updated.

That command is [~/bin/dotfiles][dotfiles], and this is my "dotfiles" Git repo.

[dotfiles]: https://github.com/cowboy/dotfiles/blob/master/bin/dotfiles
[bin]: https://github.com/cowboy/dotfiles/tree/master/bin

## What, exactly, does the "dotfiles" command do?

It's really not very complicated. When [dotfiles][dotfiles] is run, it does a few things:

1. Git is installed if necessary, via APT or Homebrew (which is installed if necessary).
2. This repo is cloned into the `~/.dotfiles` directory (or updated if it already exists).
2. Files in `init` are executed (in alphanumeric order).
3. Files in `copy` are copied into `~/`.
4. Files in `link` are linked into `~/`.

Note:

* The `backups` folder only gets created when necessary. Any files in `~/` that would have been overwritten by `copy` or `link` get backed up there.
* Files in `bin` are executable shell scripts ([~/.dotfiles/bin][bin] is added into the path).
* Files in `source` get sourced whenever a new shell is opened (in alphanumeric order)..
* Files in `conf` just sit there. If a config file doesn't _need_ to go in `~/`, put it in there.
* Files in `caches` are cached files, only used by some scripts. This folder will only be created if necessary.

## Installation
### OS X
Notes:

* You may need to be an administrator.
* You may need to install XCode first.

```sh
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```

### Ubuntu
Notes:

* If APT hasn't been updated/upgraded recently, it might be a minute before you see anything.
* You'll have to enter your password for sudo.

```sh
sudo apt-get -qq update && sudo apt-get -qq upgrade && sudo apt-get -qq install curl && echo &&
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```

## The "init" step
These things will be installed, but _only_ if they aren't already.

### OS X
* Homebrew
  * git
  * node
  * tree
  * sl
  * lesspipe
  * [non-LVVM gcc](https://github.com/adamv/homebrew-alt/blob/master/duplicates/gcc.rb) (OS X only)

### Ubuntu
* APT
  * build-essential
  * libssl-dev
  * git-core
  * tree
  * sl
* Node (built from source)

### Both
* Npm
  * JSHint
  * Uglify-JS
* Rbenv
  * Ruby 1.9.2-p290 (default)
  * Ruby 1.8.7-p352
* Ruby Gems
  * bundler
  * awesome_print
  * interactive_editor

## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~`. Any file that _needs_ to be modified with personal information (like [.gitconfig](https://github.com/cowboy/dotfiles/blob/master/copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit it!

## Aliases and Functions
To keep things easy, the `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc into one of the files in the `source` directory, or add a new file. They're all automatically sourced when a new shell is opened. Take a look, I have [a lot of aliases and functions](https://github.com/cowboy/dotfiles/tree/master/source). I even have a [fancy prompt](https://github.com/cowboy/dotfiles/blob/master/source/prompt.sh) that shows the current directory, time and current git/svn repo status.

## Scripts
In addition to the aforementioned [dotfiles][dotfiles] script, there are a few other [bash scripts][bin]. This includes [ack](https://github.com/petdance/ack), which is a [git submodule](https://github.com/cowboy/dotfiles/tree/master/libs).

## Scripts
* [dotfiles][dotfiles] - (re)initialize dotfiles. On Ubuntu, it might ask your your password (sudo).
* [src](https://github.com/cowboy/dotfiles/blob/master/link/.bashrc#L6-15) - (re)source all files in `source` directory
* Look through the [bin][bin] subdirectory for a few more.

## Inspiration
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>  
(and 15+ years of accumulated crap)

## License
Copyright (c) 2011 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>
