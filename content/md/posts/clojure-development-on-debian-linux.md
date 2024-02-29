{:title "Clojure Development on Debian Linux"
:layout :post
:date "2023-08-26"
:topic "debian"
:tags  ["debian" "clojure"  "workflow"]}


Debian Linux is one of the original and longest running community distributions, in large part due to the excellent `deb` package management system and the openness of the contribution process.

Debian has inspired a large number of other community distributions, most notably Ubuntu.

Debian provides a highly flexible foundation for Clojure development.

<!-- more -->

> Practicalli Clojure book details more options for [Clojure Install](https://practical.li/clojure/install/) and supporting tools 

## Install Debian

Download the Debian Net install minimal ISO image and write to a CD or USB memory stick (flash drive).  Use MultiWriter (Debian) or Disk Startup Creator (Ubuntu) to create a bootable install on a USB memory stick.

> Debian Net install ISO only containes the essential debian packages to run a Linux system.  Additional requested packages are downloaded via an internet connection from a local mirror.

Boot the computer from the Debian ISO image and follow the install wizard, selecting additional software as required.  Specific packages can be added at any time after the install has completed.

### Administration

Debian recommends admistrative tasks such as installing software be carried out by the root user.  The sudo package is used by some Linux distributions to allow a non-root user account to act as root, although Debian maintainers decided this was more of a security risk.

> `sudo` package is available in the Debian package repository should that approach be required.

During the Debian install, a root user account password is set.

`su -` switches to the root user account (first prompting for the root password)

`apt` is the advance package tool that manages the install (and removal) of debian packages.

`apt install package-name` installs the specified package along with any packages it depends upon.  Recommended packages are also suggested (documentation or related packages).

`apt update` will update the list of available packages from all repositories.

`apt upgrade` installs the latest versions of packages and is typically run after `apt update`.

`apt search package-name` will search for the package-name provided.

`apt show package-name` displays details of the package, including the available version and any dependant packages


### Additional Software

Contrib and nonfree repositories provide additional packages, such as more fonts, codecs, etc.

Open **Software & Updates** and unlock the wizzard using the root account password.

Add contrib and non-free repositories, then **Close** and select **Refresh** to update the list of available packages.

![Debian Linux - software repositories contrib and nonfree](https://github.com/practicalli/graphic-design/blob/live/os/debian/debian-software-updates-repositories-contrib-nonfree.png?raw=true)


## Kitty terminal

[Kitty terminal](https://sw.kovidgoyal.net/kitty/) provides a fast and easy to configure terminal application, providing an excellent way to run Neovim or Emacs in a terminal.

Open **Terminal** and `su -` to change to the root user account.

```shell
apt install kitty
```

Practicalli recommends downloading NerdFonts to provide a rich terminal experience, especially when using Neovim.

> [Practicalli Engineering Playbook](https://practical.li/engineering-playbook/command-line/kitty-terminal/) covers Kitty configuation and use in more detail


## FreeDesktop XDG config standard

Using the XDG standard for simplifies maintenance and backup for configuration files and local caches.

> [Practicalli: Adopting FreeDesktop XDG standard for configuration files](https://practical.li/blog/posts/adopt-FreeDesktop.org-XDG-standard-for-configuration-files/)

## Clojure CLI

The Linux install script for Clojure CLI will add the `clojure` binary and `clj` wrapper to `/usr/local/bin`, making it available to all users.

Open a **Terminal** and copy/paste these commands to download and run the Clojure CLI installer.

```shell
curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh && \
chmod +x linux-install.sh && \
sudo ./linux-install.sh
```

> The install path can be overridden using the `--prefix` option.


Clojure CLI install includes a configuration:

- adds `src` directory to the class path
- adds the latest stable version of the Clojure standard library as a dependency
- defines `:deps` alias to enable Clojure CLi built-in functions




```clojure title="/usr/local/lib/clojure/deps.edn"
{
  :paths ["src"]

  :deps {
    org.clojure/clojure {:mvn/version "1.11.1"}
  }

  :aliases {
    :deps {:replace-paths []
           :replace-deps {org.clojure/tools.deps.cli {:mvn/version "0.9.10"}}
           :ns-default clojure.tools.deps.cli.api
           :ns-aliases {help clojure.tools.deps.cli.help}}
    :test {:extra-paths ["test"]}
  }
### Clojure CLI functions

  :mvn/repos {
    "central" {:url "https://repo1.maven.org/maven2/"}
    "clojars" {:url "https://repo.clojars.org/"}
  }
}
The `:deps` alias is used to access the Clojure CLi built-in functions.  These functions are also described in the Clojure CLI help documentation, `clojure --help`

```shell
 -X:deps list              List full transitive deps set and licenses
 -X:deps tree              Print deps tree
 -X:deps find-versions     Find available versions of a library
 -X:deps prep              Prepare all unprepped libs in the dep tree
 -X:deps mvn-pom           Generate (or update) pom.xml with deps and paths
 -X:deps mvn-install       Install a maven jar to the local repository cache
 -X:deps git-resolve-tags  Resolve git coord tags to shas and update deps.edn
```


### Practicalli Clojure CLI Config

A wide range of community tools that extend the features of Clojure CLI are defined as `:aliases` in Practicalli Clojure CLI Config.

```shell
git clone git@github.com:practicalli/clojure-cli-config.git $XDG_CONFIG_HOME/clojure
```

Tools can be used using the `clojure` command with one or more aliases.

List the available aliases


```shell
clojure -X:deps aliases
```



## Neovim

Debian 12 includes Neovim 0.7.2, although Practicalli recommends downloading the [latest Neovim release from GitHub](https://github.com/neovim/neovim/releases/tag/stable).

Move the `nvim.appimage` file to the local bin directory, adding it to the operating system execution path.

```shell
mv nvim.appimage ~/.local/bin/nvim.appimage
```

Create a symbolic link to allow neovim to be run using the command `nvim`

```shell
ln -s ~/.local/bin/nvim.appimage ~/.local/bin/nvim
```


### Treesitter parsers

Install a suitable compiler for the language parsers used by Treesitter in Neovim.

The `cpp` package is installed by default, however it seems `g++` package is also required

```shell
apt install g++
```

### Lint and format tools

Many lint and format tools are available as NPM packages, so `node` and `npm` are required.

Although nodejs and npm are available as debian packages, the `npm` package has a huge amount of dependencies.

Practicalli recommends the [Linux release from the nodejs website](https://nodejs.org/), installing in the local apps directory for the user account for Clojure development (your normal login account).

Extract the downloaded nodejs archive

```shell
tar Jvxf node-v18.17.1-linux-x64.tar.xz 
```

Create a local app directory and move the extracted directory there, creating a symbolic link called current (which can be easily changed if a different version of node is required)

```shell
mkdir ~/.local/apps/nodejs/ && \
mv ~/Downloads/node-v18.17.1-linux-x64/ ~/.local/apps/nodejs/ && \
ln -s ~/.local/apps/nodejs/node-v18.17.1-linux-x64 ~/.local/apps/nodejs/current
```

Create symbolic links to the `node` and `npm` binaries within the `~/.local/bin/` directory, placing the binaries on the path.  Using `current` in the link ensures these symbolic links do not need to be updated when switching to another nodejs version.

```shell
ln -s ~/.local/apps/nodejs/current/bin/node ~/.local/bin/node && \ 
ln -s ~/.local/apps/nodejs/current/bin/npm ~/.local/bin/npm 
```


Install neovim npm package to support Neovim nodejs provider.

```shell
npm install neovim
```


## Emacs

Debian 12 packages Emacs version 28.2, although Emacs 29.1 is the latest stable release.

Practicalli recommends [building Emacs from source](https://practical.li/blog/posts/build-emacs-from-source-on-ubuntu-linux/) as it is a relatively easy task although will take a little time to compile.

## Slack

[Download the .deb file](https://slack.com/intl/en-gb/downloads/linux) from Slack website

`su -` in a terminal to change to the root user account

```shell
apt install /home/practicalli/Downloads/slack-desktop-4.33.90-amd64.deb
```

Slack can be run from the Desktop launcher, `Super`

