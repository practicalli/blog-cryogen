{:title "Spacemacs - Share Buffers via Github Gists"
 :date "2016-03-13"
 :layout :post
 :topic "spacemacs"
 :tags  ["spacemacs" "emacs" "github"]}

> The Spacemacs **github** layer has been deprecated and gist.el is longer a reliable tool to work with GitHub gists unfortunately

[Github Gists](https://gist.github.com/) proved a simple way to share a piece of code, configuration or documentation without setting up a full version control project.  Rather than use copy & paste, a Gist can be created from any [Spacemacs](https://github.com/syl20bnr/spacemacs) buffer or region with a single command.

Add the `github` layer to the `~/.spacemacs` configuration file and reload your configuration, `SPC f e R`, or restart Spacemacs `SPC q r`.  Lets see just how easy it is to use Gists with Spacemacs.

> You can also use [gist.el](https://github.com/defunkt/gist.el) with your own Emacs configuration

<!-- more -->

## Configure GitHub Access

Spacemacs will use the [GitHub account name and an access token added to your Git configuration](https://practical.li/spacemacs/source-control/github-configuration.html) to avoid the need to provide username, password and 2Factor code each time Spacemacs interacts with GitHub.

Add your GitHub account name by editing `~/.gitconfig` or using the following command

```
git config --global github.user practicalli

```

Visit your Github profile page and view the **personal acccess tokens** section.  Create a token with the **gist** and **repo** access permissions and copy the long token string. Add the token to your `~/.gitconfig` file using the command:

```
 git config --global github.oauth-token therealtokenvalueshouldbepastedhere
```

The `~/.gitconfig` configuration file should contain a `[github]` section with `user` and `oauth-token` key/value pairs

```
[github]
    user = practicalli
    oauth-token = thisishweretherealtokenshouldbepasted
```

> Practicalli Spacemacs contains Git and GitHub configurations and

## GitHub Gist Menu keybindings

![Spacemacs GitHub Gist menu](https://raw.githubusercontent.com/practicalli/graphic-design/live/spacemacs/screenshots/practicalli-spacemacs-github-gist-menu.png)

- `SPC g g b` : create a public gist from the current Spacemacs buffer
- `SPC g g B` : create a private gist from the current Spacemacs buffer
- `SPC g g r` : create a public gist from the highlighted region
- `SPC g g R` : create a private gist from the highlighted region
- `SPC g g l` : list all gists on your github account

> Replace `SPC` with `M-m` if using Spacemacs Holy (Emacs) mode


## Create a Gist from Spacemacs

`SPC g g b` (`gist-buffer`) creates a GitHub Gist from the current buffer and copies the URL of that Gist into the kill ring.

![Gist - create a Gist from the current buffer](/images/spacemacs-gist-create-from-buffer.png)

`SPC g g r` (`gist-region`) creates a gist from the selected region of the buffer.  Select a region using `v` or `C-SPC` and vim navigation keys or arrow keys.


## Updating a Gist

A Gist created from a buffer has no direct link between your buffer and the Gist.  So if you make changes to your buffer you want to share, you can generate a new gist using `M-x gist-buffer` & delete the original one (see listing & managing gists below).

Alternatively, once you have created a Gist, you can open that Gist in a buffer and make changes.  When you save your changes in the Gist buffer, `C-x C-s`, the gist on gist.github.com is updated.


## Listing & managing Gists

Use the command `M-x gist-list` or keybinding `M-m g g l` to show a list of your current Gists.

![Spacemacs - Gist list](/images/spacemacs-gist-list.png)

In the buffer containing the list of your gists, you can use the following commands

- `RETURN` : opens the gist in a new buffer
- `g` : reload the gist list from server
- `e` : edit the gist description, so you know what this gist is about
- `k` : delete current gist
- `b` : opens the gist in the current web browser
- `y` : show current gist url & copies it into the clipboard
- `*` : star gist (stars do not show in gist list, only when browsing them on github)
- `^` : unstar gist
- `f` : fork gist - create a copy of your gist on gist.github.com
- `+` : add a file to the current gist, creating an additional snippet on the gist
- `-` : remove a file from the current gist

# Creating Gists from files

If you open a dired buffer you can make gists from marked files, `m`, by pressing `@`.  This will make a public gist out of marked files (or if you use with a prefix, it will make private gists)

![Gist - create a gist from the marked files in dired](/images/spacemacs-gist-dired-gist-from-file.png)

# Summary

Its really easy to share code and configuration with [Github Gists](https://gist.github.com/).  Its even easier when you use [Spacemacs]([Spacemacs](https://github.com/syl20bnr/spacemacs)) to create and manages gists for you.  Have fun sharing your code & configurations with others via gists.

Thank you.
[@jr0cket](https://twitter.com/jr0cket)
