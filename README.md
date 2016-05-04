# Dotfiles

My shell configuration files.

## Why is this a git repo?

To keep track of these files.  My dotfiles are based very heavily on [Cowboy](https://github.com/cowboy)'s [dotfiles](https://github.com/cowboy/dotfiles).

That command is [dotfiles][dotfiles], and this is my "dotfiles" Git repo.

[dotfiles]: bin/dotfiles
[bin]: https://github.com/evanchiu/dotfiles/tree/master/bin

## What, exactly, does the "dotfiles" command do?

It's really not very complicated. When [dotfiles][dotfiles] is run, it does a few things:

1. Git is installed if necessary, via APT or Homebrew (which is installed if necessary).
2. This repo is cloned into the `~/.dotfiles` directory (or updated if it already exists).
2. Files in `init` are executed (in alphanumeric order, hence the "50\_" names).
3. Files in `copy` are copied into `~/`.
4. Files in `link` are linked into `~/`.

Note:

* The `backups` folder only gets created when necessary. Any files in `~/` that would have been overwritten by `copy` or `link` get backed up there.
* Files in `bin` are executable shell scripts (Eg. [~/.dotfiles/bin][bin] is added into the path).
* Files in `source` get sourced whenever a new shell is opened (in alphanumeric order, hence the "50\_" names).
* Files in `conf` just sit there. If a config file doesn't _need_ to go in `~/`, put it in there.
* Files in `caches` are cached files, only used by some scripts. This folder will only be created if necessary.

## Installation
### OS X Notes

* You need to be an administrator (for `sudo`).
* You need [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools) or a full installation of [XCode](https://developer.apple.com/downloads/index.action?=xcode). Running `git` on the command line triggers OS X to offer an automatic install of XCode Command Line Tools.

### Ubuntu Notes

* You need to be an administrator (for `sudo`).

### Actual Installation

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/evanchiu/dotfiles/master/bin/dotfiles)" && source ~/.zshrc
```

## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [.gitconfig](copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~/`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit that data!

## Scripts
In addition to the aforementioned [dotfiles][dotfiles] script, there are a few other [scripts][bin]. This includes [ack](https://github.com/petdance/ack), which is a [git submodule](libs).

* [dotfiles][dotfiles] - (re)initialize dotfiles. It might ask for your password (for `sudo`).
* [source](source) - (re)source all files in `source` directory
* Look through the [bin][bin] subdirectory for a few more.

## Inspiration
<https://github.com/cowboy/dotfiles>

## License
Copyright (c) 2016 Evan Chiu

Licensed under the MIT license
