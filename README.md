# Dotfiles

My linux / OS X dotfiles. This is a work in progress, as I'm currently rebuilding my system!

[dotfiles]: https://github.com/cowboy/dotfiles/blob/master/bin/dotfiles

## Structure
When [dotfiles][dotfiles] is run:

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
* [dotfiles][dotfiles] - (re)initialize dotfiles
* [src](https://github.com/cowboy/dotfiles/blob/master/link/.bashrc#L6-15) - (re)source all files in `source` directory

## Installation
### OS X:

```sh
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```

### Ubuntu:
Notes:

* If APT hasn't been updated/upgraded recently, it might be a minute before you see anything.
* You'll have to enter your password for sudo.

```sh
sudo apt-get -qq update && sudo apt-get -qq upgrade && sudo apt-get -qq install curl && \
bash -c "$(curl -fsSL https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles)" && source ~/.bashrc
```

## The "init" step
In OS X, these things will be installed, but _only_ if they aren't already.

* Homebrew
  * Git
  * Node
  * Tree
  * Sl
  * Lesspipe
  * [non-LVVM gcc](https://github.com/adamv/homebrew-alt/blob/master/duplicates/gcc.rb) (for RBEnv)
* Nvm
  * Node latest stable
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

(more to come)

I'm working on the Ubuntu part now.

## The "copy" step
Any file in the `copy` subdirectory will be copied into `~`. Any file that _needs_ to be modified with personal information (like [.gitconfig](https://github.com/cowboy/dotfiles/blob/master/copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit it!

## What about the "source" directory?
To keep things easy, the `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc into one of the files in the `source` directory, or add a new file. They're all automatically sourced when a new shell is opened. Take a look, I have [a lot of aliases and functions](https://github.com/cowboy/dotfiles/tree/master/source). I even have a [fancy prompt](https://github.com/cowboy/dotfiles/blob/master/source/prompt.sh) that shows the current directory, time and git/svn repo status.

## And the "bin" directory?
In addition to the aforementioned [dotfiles][dotfiles] script, there are a few other [bash scripts](https://github.com/cowboy/dotfiles/tree/master/bin). This includes [ack](https://github.com/petdance/ack), which is a [git submodule](https://github.com/cowboy/dotfiles/tree/master/libs).

## Inspiration
<https://github.com/gf3/dotfiles>  
<https://github.com/mathiasbynens/dotfiles>  
(and 15+ years of accumulated crap)

## License
Copyright (c) 2011 "Cowboy" Ben Alman  
Licensed under the MIT license.  
<http://benalman.com/about/license/>


## Sample output on OS X Lion
_(first run, with XCode already installed and a few pre-existing ~/ files)_

Last login: Thu Dec 22 21:47:43 on ttys009  
Bens-MacBook-Pro:~ cowboy$ bash -c "$(curl -fsSL <https://raw.github.com/cowboy/dotfiles/master/bin/dotfiles>)" && source ~/.bashrc  
Dotfiles - "Cowboy" Ben Alman - http://benalman.com/  
  
**Downloading files**  
Cloning into /Users/cowboy/.dotfiles...  
remote: Counting objects: 189, done.  
remote: Compressing objects: 100% (150/150), done.  
remote: Total 189 (delta 107), reused 111 (delta 29)  
Receiving objects: 100% (189/189), 52.36 KiB, done.  
Resolving deltas: 100% (107/107), done.  
Submodule 'libs/ack' (git://github.com/petdance/ack.git) registered for path 'libs/ack'  
Cloning into libs/ack...  
remote: Counting objects: 5367, done.  
remote: Compressing objects: 100% (1450/1450), done.  
remote: Total 5367 (delta 3996), reused 5262 (delta 3903)  
Receiving objects: 100% (5367/5367), 886.48 KiB, done.  
Resolving deltas: 100% (3996/3996), done.  
Submodule path 'libs/ack': checked out 'a1d233a27b76a6b8b19fad00c59828388800b4d6'  
  
**Installing Homebrew**  
==> This script will install:  
/usr/local/bin/brew  
/usr/local/Library/Formula/...  
/usr/local/Library/Homebrew/...  
  
Press enter to continue  
==> Downloading and Installing Homebrew...  
==> Installation successful!  
Now type: brew help  
Initialized empty Git repository in /usr/local/.git/  
remote: Counting objects: 50656, done.  
remote: Compressing objects: 100% (21415/21415), done.  
remote: Total 50656 (delta 32183), reused 45135 (delta 28544)  
Receiving objects: 100% (50656/50656), 7.08 MiB | 1.32 MiB/s, done.  
Resolving deltas: 100% (32183/32183), done.  
From https://github.com/mxcl/homebrew  
 * [new branch]      gh-pages   -> origin/gh-pages  
 * [new branch]      master     -> origin/master  
HEAD is now at ad135fa freeradius-server 2.1.12  
Already up-to-date.  
  
**Installing Homebrew recipes: git node rbenv sl tree**  
==> Downloading http://git-core.googlecode.com/files/git-1.7.8.1.tar.gz  
######################################################################## 100.0%  
==> make prefix=/usr/local/Cellar/git/1.7.8.1 install  
==> Downloading http://git-core.googlecode.com/files/git-manpages-1.7.8.1.tar.gz  
######################################################################## 100.0%  
==> Downloading http://git-core.googlecode.com/files/git-htmldocs-1.7.8.1.tar.gz  
######################################################################## 100.0%  
==> Caveats  
Bash completion has been installed to:  
  /usr/local/etc/bash_completion.d  
  
Emacs support has been installed to:  
  /usr/local/share/doc/git-core/contrib/emacs  
  
The rest of the "contrib" is installed to:  
  /usr/local/share/git/contrib  
==> Summary  
/usr/local/Cellar/git/1.7.8.1: 1121 files, 21M, built in 18 seconds  
==> Downloading http://nodejs.org/dist/v0.6.6/node-v0.6.6.tar.gz  
######################################################################## 100.0%  
==> ./configure --prefix=/usr/local/Cellar/node/0.6.6 --without-npm  
==> make install  
==> Caveats  
Homebrew has NOT installed npm. We recommend the following method of  
installation:  
  curl http://npmjs.org/install.sh | sh  
  
After installing, add the following path to your NODE_PATH environment  
variable to have npm libraries picked up:  
  /usr/local/lib/node_modules  
==> Summary  
/usr/local/Cellar/node/0.6.6: 80 files, 7.6M, built in 2.4 minutes  
==> Downloading https://github.com/sstephenson/rbenv/tarball/v0.2.1  
######################################################################## 100.0%  
/usr/local/Cellar/rbenv/0.2.1: 33 files, 160K, built in 2 seconds  
==> Downloading http://mirrors.kernel.org/debian/pool/main/s/sl/sl_3.03.orig.tar  
  
curl: (22) The requested URL returned error: 404  
Trying a mirror...  
==> Downloading http://ftp.us.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.  
######################################################################## 100.0%  
==> make  
/usr/local/Cellar/sl/3.03: 4 files, 28K, built in 2 seconds  
==> Downloading http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz  
######################################################################## 100.0%  
==> make  
==> make install  
/usr/local/Cellar/tree/1.6.0: 6 files, 116K, built in 2 seconds  
  
**Installing Npm**  
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current  
                                 Dload  Upload   Total   Spent    Left  Speed  
100  7184  100  7184    0     0  38496      0 --:--:-- --:--:-- --:--:-- 89800  
tar=/usr/bin/tar  
version:  
bsdtar 2.8.3 - libarchive 2.8.3  
fetching: http://registry.npmjs.org/npm/-/npm-1.0.106.tgz  
0.6.6  
1.0.106  
cleanup prefix=/usr/local  
  
All clean!  
/usr/local/bin/npm -> /usr/local/lib/node_modules/npm/bin/npm-cli.js  
/usr/local/bin/npm-g -> /usr/local/lib/node_modules/npm/bin/npm-cli.js  
/usr/local/bin/npm_g -> /usr/local/lib/node_modules/npm/bin/npm-cli.js  
npm@1.0.106 /usr/local/lib/node_modules/npm   
It worked  
  
**Installing Npm modules: jshint nave uglify-js**  
/usr/local/bin/nave -> /usr/local/lib/node_modules/nave/nave.sh  
/usr/local/bin/uglifyjs -> /usr/local/lib/node_modules/uglify-js/bin/uglifyjs  
/usr/local/bin/jshint -> /usr/local/lib/node_modules/jshint/bin/hint  
nave@0.2.4 /usr/local/lib/node_modules/nave   
uglify-js@1.2.2 /usr/local/lib/node_modules/uglify-js   
jshint@0.5.5 /usr/local/lib/node_modules/jshint   
├── argsparser@0.0.6  
└── minimatch@0.0.5  
  
**Copying files into home directory**  
 ➜  Backing up ~/.gitconfig.  
 ✔  Copying ~/.gitconfig.  
  
**Linking files into home directory**  
 ✔  Linking ~/.ackrc.  
 ✔  Linking ~/.aprc.  
 ➜  Backing up ~/.bash_profile.  
 ✔  Linking ~/.bash_profile.  
 ➜  Backing up ~/.bashrc.  
 ✔  Linking ~/.bashrc.  
 ✔  Linking ~/.toprc.  
  
Backups were moved to ~/.dotfiles/backups/2011_12_22-22_03_08/  
  
**All done!**  
  
[cowboy@Bens-MacBook-Pro:~]  
[22:06:33] $
