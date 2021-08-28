{:title "Regolith - the batteries included tiling desktop environment"
:layout :post
:date "2019-12-23"
:topic "ubuntu"
:tags  ["ubuntu"]}

Regolith is an easy to use tiling destkop manager that just works, no need to spend a lot of time configuring it before its useful.  Regolith is the i3 window manager with extra modules and very good default configuration.  It uses the Gnome tooling in the background, so everything just works.

I installed Regolith on a Lenovo X1 Extreme with Ubuntu 19.10, volume and screen brightness keys work straight away.  Connecting an external monitor spaned the desktop over both displays, mirroring and the other Gnome display options work as normal too.


You can run Regolith by installing its own Linux distribution, or just install it as a package in Ubuntu as I did.

<!-- more -->

## Install in an existing Ubuntu machine

```
sudo apt install ...
```




When you select an account to login, click the settings cog and select i3-regolith as the desktop.


## Essential use of Regolith

Driving the desktop with the Super key

moving apps around

The Regolith terminal
`Super + pageUp` and `Super + pageDown` keys to scale the terminal font

> How to set the default font size ??  Is it possible in st, or do we need another terminal application.  You can change the default in ...?

## Customise Regolith


Copy the base configuration files into the root directory of your home account.

Copy `/etc/regolith/styles/root` to `~/.Xresources-regolith`

```shell
cp /etc/regolith/styles/root ~/.Xresources-regolith
```

> Use the command `xrdb -merge ~/.Xresources-regolith && reload i3` to apply the changes, or restart Regolith


If you want to create your own custom themes or have a deeper customisation, then also copy the Regolith styles

```shell
cp /etc/regolith/styles/* ~/.Xresources.d/
```

You can create your own themes using the existing themes as examples.  If you create a custom theme, then be sure to include that theme in the `~/.Xresources-regolith` configuration file.

> See the Regolith documentation for a [complete list of configuration file locations](https://github.com/regolith-linux/regolith-desktop/wiki/Customize#config-files)

## Creating the practicalli configuration

TODO: refactor for new release of regolith

rough guide - what I should have done (probably)
1. copy the ubutnu configuration to ~/.local/regolith/practicalli

update all the configs to point to the other practicalli files

2. Create a ~/.Xresources-regolith file and point it to the new theme

```
#include "$HOME/.local/practicalli/root"
```

TODO: check that works with $HOME

TODO: check /etc/regolith/styles/practicalli for changes



### Ubuntu fonts ###

The default font is source code pro, which is not available by default on Ubuntu.  The ubuntu fonts are just as good (better in my opinion) and are already installed.

Edit `~/.Xresources-regolith` and include the `typeface-ubuntu` font family

```
! -- Styles - Fonts
#include "/etc/regolith/styles/typeface-ubuntu"
```


## Changing to a light theme


When presenting and broadcasting I use a light theme which provides the best contrast of colours when viewing code.The regolith desktop is dark by default.

Change the Styles - Colours to change the destktop bar and `st` terminal application.  This does not change the Gnome settings app which uses a Gnome GTK theme.

Edit `~/.Xresources-regolith` and include the `color-solarized-light` colour definition.

```
! This is the Regolith root-level Xresources file.
!
! -- Styles - Colors
!
#include "/etc/regolith/styles/color-solarized-light"
```
