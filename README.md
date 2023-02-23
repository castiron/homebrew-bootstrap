# Homebrew Bootstrap

This repository is Cast Iron Coding's homebrew tap used to support setting up projects and running services on development workstations. It supports the [one script to rule them all](https://github.com/github/scripts-to-rule-them-all) convention that we will use going forward. We used to use Boxen. Now we use [Strap](https://github.com/MikeMcQuaid/strap) and this tap.

The functionality in this repository is not compatible with Boxen. Boxen should be completely removed from your machine before attempting to use this tap. **Things will break if you try to use this alongside Boxen.**

## Prerequisites

1. Boxen has been [fully removed from your machine](https://stackoverflow.com/c/cic/questions/26).
2. You have a current, up-to-date version of homebrew. Run `brew update` and address any problems until you can run it without issue.
3. You can run `brew doctor` without any problems being reported.

## Installation

Installation is simple. Run the following command to install. The tap command clones this repository to `/usr/local/Homebrew/Library/Taps/castiron/homebrew-bootstrap`. If you're going to be contributing to this repo, consider symlinking `~/src/homebrew-bootstrap` to that path.

```bash
brew tap castiron/bootstrap
```

## Usage

This tap provides homebrew commands and formulas. Any script (ruby or bash) in the `cmd` directory can be called through homebrew. For example, `cmd/brew-bootstrap-rbenv-ruby.rb` is executed with the following command:

```bash
brew bootstrap-rbenv-ruby
```

Some of the commands take arguments. Most do not.

### bootstrap-nodenv-node

Ensures that nodenv is installed, that your bash_profile is initializing nodenv correctly, and installs the version of node specified in `.node-version` if necessary. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-nodenv-node
```

### bootstrap-phpenv-php

Ensures that phpenv is installed, that your bash_profile is initializing phpenv correctly, and installs the version of php specified in `.php-version` if necessary. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-nodenv-node
```

### bootstrap-rbenv-ruby

Ensures that rbenv is installed, that your bash_profile is initializing rbenv correctly, and installs the version of ruby specified in `.ruby-version` if necessary. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-rbenv-ruby
```

### boootstrap-project-all

Include any bootstrapping that is common to all languages and projects. Currently, it checks for a Brewfile and installs homebrew dependencies if it finds one. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-project-all
```

### bootstrap-project-php

Include any bootstrapping that is common to all php projects. This command will 1) execute bootstrap-project-all; 2) install Node, Ruby, and PHP if necessary; 3) install any gem dependencies; 4) install node dependencies from package.json; 4) install composer; and 5) install composer dependencies. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-project-php
```

### bootstrap-project-rails

Include any bootstrapping that is common to all Rails projects. This command will 1) execute bootstrap-project-all; 2) install Node and Ruby if necessary; and 3) install any gem dependencies. This command is a helper command meant to be called from scripts.

```
$ brew bootstrap-project-rails
```

### check-strta-enabled

This command will ensure that the machine is ready to utilize the one script to rule them all approach. Currently, it assumes that any machine without Boxen installed is suitable. This command is a helper command meant to be called from scripts.

```
$ brew check-strta-enabled
```

### ensure-nginx-executable

To run nginx on port 80 and 443, which are privileged ports, nginx needs to run as root. This command modifies the nginx executable so that the non-privileged user can start and restart nginx. It needs to be run after any update to nginx, and it references in the caveats of our (slightly) modified nginx formula.

```
$ brew ensure-nginx-executable
```

### setup-nginx-conf

Sets up an nginx virutal host file (typically in ./config/dev) and symlinks to it from global nginx configuration. It ensures nginx is installed and generates self-signed SSL certificates. It restarts nginx as necessary. This command is a helper command meant to be called from scripts.

```
$ brew setup-nginx-conf [--root] [--extra-val=variable=value] <project_name> <project_root_path> <nginx.conf.erb>
```

### scaffold

The scaffold command, which currently supports `october`, `rails`, and `typo3` projects, will install scripts, a procfile, gitignores, and generally setup the project. Users will be prompted before files are overwritten. When starting a new project, the scaffold command should be run to get the various scripts in place.

```
$ brew scaffold october
$ brew scaffold docker_october
$ brew scaffold rails
$ brew scaffold typo3
$ brew scaffold wordpress
```

### setup-ssl

Generates a self-signed SSl certificate for the project

```
$ brew bootstrap-project-ssl <project_name> <ssl_storage>
```

## Troubleshooting Resources

1. [Homebrew Documentation](https://docs.brew.sh/)
2. The [Launch Control](http://www.soma-zone.com/LaunchControl/) application provides a gui for mananging launchd services, which can be useful.
3. [Homebrew Bundle README](https://github.com/Homebrew/homebrew-bundle)
4. [Zach's Boxen uninstall gist](https://gist.github.com/zdavis/4b59449ee5c9954cedd41687733c3d48)


## Contributing

To contribute, the first step is to tap this repository (see installation, above). If you've already tapped it, you'll want to "[unshallow](https://docs.brew.sh/Taps.html)" the tap:

```bash
brew tap castiron/bootstrap --full
```

Once that's done, this repository will be cloned at `/usr/local/Homebrew/Library/Taps/castiron/homebrew-bootstrap`. To make development easier, create a symlink to it in your `~/src` directory:

```bash
cd ~/src
ln -s /usr/local/Homebrew/Library/Taps/castiron/homebrew-bootstrap
```

Assuming this was done correctly, you should see the scripts listed at the top of this repo show up as homebrew commands:

```bash
brew commands list
```

Keep in mind that brew will only include executable files as commands. If you add a new command to this repository, be sure to set permissions correctly. We can write our commands as shell scripts or using ruby. Read the [homebrew documentation on external commands](https://docs.brew.sh/External-Commands) for more information.

## Status

This approach to managing development environments is being actively developed at Cast Iron Coding. Our current intention is to replace Boxen with this set of brew commands, [Strap](https://github.com/MikeMcQuaid/strap), [brew bundle](https://github.com/Homebrew/homebrew-bundle), and a customized version of Github's [one script to rule them all](https://github.com/github/scripts-to-rule-them-all).

## Maintainers
- [@zdavis](https://github.com/zdavis/)
- [@rclarkburns](https://github.com/rclarkburns/)

## License
Homebrew Bootstrap is licensed under the [MIT License](http://en.wikipedia.org/wiki/MIT_License).
The full license text is available in [LICENSE.txt](https://github.com/github/homebrew-bootstrap/blob/master/LICENSE.txt).
