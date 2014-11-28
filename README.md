# `~/.dotfiles`

__A fork of [cowboy/dotfiles](https://github.com/cowboy/dotfiles) focused on OS X.__

__[dotfiles][dotfiles]__ - A single command to "bootstrap" a new system to pull down all of my dotfiles and configs, as well as install all the tools I commonly use. In addition, I wanted to be able to re-execute that command at any time to synchronize anything that might have changed. Finally, I wanted to make it easy to re-integrate changes back in, so that other machines could be updated.

[dotfiles]: bin/dotfiles

## How the "dotfiles" command works

When [dotfiles][dotfiles] is run for the first time, it does a few things:

1. This repo is cloned into your user directory, under `~/.dotfiles`.
1. Files in `/copy` are copied into `~/`. ([read more](#the-copy-step))
1. Files in `/link` are symlinked into `~/`. ([read more](#the-link-step))
1. You are prompted to choose scripts in `/init` to be executed. The installer attempts to only select relevant scripts, based on the detected OS and the script filename.
1. Your chosen init scripts are executed (in alphanumeric order, hence the funky names). ([read more](#the-init-step))

On subsequent runs, step 1 just updates the already-existing repo, and step 4 remembers what you selected the last time. The other steps are the same.

### Other subdirectories

* The `/backups` directory gets created when necessary. Any files in `~/` that would have been overwritten by files in `/copy` or `/link` get backed up there.
* The `/bin` directory contains executable shell scripts (including the [dotfiles][dotfiles] script) and symlinks to executable shell scripts. This directory is added to the path.
* The `/caches` directory contains cached files, used by some scripts or functions.
* The `/conf` directory just exists. If a config file doesn't **need** to go in `~/`, reference it from the `/conf` directory.
* The `/source` directory contains files that are sourced whenever a new shell is opened (in alphanumeric order, hence the funky names).
* The `/test` directory contains unit tests for especially complicated bash functions.

### The "copy" step
Any file in the `/copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [copy/.gitconfig](copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

### The "link" step
Any file in the `/link` subdirectory gets symlinked into `~/` with `ln -s`. Edit one or the other, and you change the file in both places. Don't link files containing sensitive data, or you might accidentally commit that data! If you're linking a directory that might contain sensitive data (like `~/.ssh`) add the sensitive files to your [.gitignore](.gitignore) file!

### The "init" step
Scripts in the `/init` subdirectory will be executed. A whole bunch of things will be installed, but _only_ if they aren't already.

* Minor XCode init via the [init/10_osx_xcode.sh](init/10_osx_xcode.sh) script
* Homebrew via the [init/20_osx_homebrew.sh](init/20_osx_homebrew.sh) script
* Homebrew recipes via the [init/30_osx_homebrew_recipes.sh](init/30_osx_homebrew_recipes.sh) script
* Homebrew casks via the [init/30_osx_homebrew_casks.sh](init/30_osx_homebrew_casks.sh) script
* [Fonts](/lexrus/dotfiles/tree/master/conf/osx/fonts) via the [init/50_osx_fonts.sh](init/50_osx_fonts.sh) script
* Node.js, npm via the [init/50_node.sh](init/50_node.sh) script
* Vim plugins via the [init/50_vim.sh](init/50_vim.sh) script
* Ruby, gems and rbenv via the [init/60_ruby.sh](init/60_ruby.sh) and [init/61_ruby_gems.sh](init/61_ruby_gems.sh) script

## Hacking my dotfiles

Because the [dotfiles][dotfiles] script is completely self-contained, you should be able to delete everything else from your dotfiles repo fork, and it will still work. The only thing it really cares about are the `/copy`, `/link` and `/init` subdirectories, which will be ignored if they are empty or don't exist.

If you modify things and notice a bug or an improvement, [file an issue](https://github.com/lexrus/dotfiles/issues) or [a pull request](https://github.com/lexrus/dotfiles/pulls) and let me know.

Also, before installing, be sure to [read my gently-worded note](#heed-this-critically-important-warning-before-you-install).

## Installation

You need to have [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

The easiest way to install the XCode Command Line Tools in OSX 10.9+ is to open up a terminal, type `xcode-select --install` and [follow the prompts](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/).

_Tested in OSX 10.10_

### Heed this critically important warning before you install

**If you're not me, please _do not_ install dotfiles directly from this repo!**

Why? Because I often completely break this repo while updating. Which means that if I do that and you run the `dotfiles` command, your home directory will burst into flames, and you'll have to go buy a new computer. No, not really, but it will be very messy.

### Actual installation (for you)

1. [Read Ben's gently-worded note](#heed-this-critically-important-warning-before-you-install)
1. Fork this repo
1. Open a terminal/shell and do this:

```sh
cd ~;git clone https://github.com/lexrus/dotfiles.git .dotfiles
.dotfiles/bin/dotfiles
```

There's a lot of stuff that requires admin access via `sudo`, so be warned that you might need to enter your password here or there.

## Aliases and Functions
To keep things easy, add your aliases, functions, settings, etc into one of the files in the `source` subdirectory, or add a new file. They're all automatically sourced when a new shell is opened. Take a look, I have [a lot of aliases and functions](source).

## Scripts
In addition to the aforementioned [dotfiles][dotfiles] script, there are a few other [bin scripts](bin).

* [dotfiles][dotfiles] - (re)initialize dotfiles. It might ask for your password (for `sudo`).
* [src](link/.zshrc#L63-71) - (re)source all files in `/source` directory
* Look through the [bin](bin) subdirectory for a few more.

## Inspiration
<https://github.com/cowboy/dotfiles>
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>  
(and 13+ years of accumulated crap)

## License of [cowboy/dotfiles](https://github.com/cowboy/dotfiles)
Copyright (c) 2014 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>