{:title "Spacemacs - raising issues and pull requests"
:layout :post
:date "2020-02-14"
:topic "spacemacs"
:tags  ["spacemacs" "pull-requests"]}

Contributing to [Spacemacs](https://www.spacemacs.org/) is very much a community activity and we can all help the maintainers continue to make [Spacemacs](https://www.spacemacs.org/) an excellent experience for everyone.

With a few simple tips, its easy to report issues and create pull requests that are ready to merge into Spacemacs `develop`.

<!-- more -->

## Spacemacs master and develop

If you have a problem with Spacemacs, there is a good chance that its already been fixed in the `develop` branch of Spacemacs.  Until Spacemacs 0.300 is released to `master` then I recommend using the `develop` branch.  There are lots of new features on `develop` too.

To change to `develop`, open a terminal and change to the `~/.emacs.d` directory and run the Git command `git checkout develop`.

Before starting Emacs with the `develop` branch, move your `.spacemacs` file to a backup.  This will create the latest version of the `.spacemacs` file from the Spacemacs template.  If you keep your original `.spacemacs` file, then use `SPC f e D` to launch ediff with your current `.spacemacs` file and the latest Spacemacs template.

> [Updating Spacemacs develop from within Spacemacs](https://www.youtube.com/watch?v=XC7LGI0Q2u8&list=PLpr9V-R8ZxiCHMl2_dn1Fovcd34Oz45su&index=3) demonstrates how to update the `develop` branch using Magit.

## Raising Issues
Take a look at the [current issue list on the Spacemacs repository](https://github.com/syl20bnr/spacemacs/issues) before creating a new issue, it might have already been raised.  The Spacemacs community is very active, so issues do get raised quickly.

> Ask on the [Spacemacs Gitter chat](https://gitter.im/syl20bnr/spacemacs) if you are not sure if its an issue, or just need help. For Clojure specific help, there is also [#spacemacs channel](clojurians.slack.com/messages/spacemacs) in the [Clojurians Slack community](http://clojurians.net/).

`SPC h I` or `M-m h I` within Spacemacs will create an issue on the Spacemacs GitHub repository, including all the useful information about your environment, including version of Spacemacs, Emacs, Operating System, etc.  All very useful to help get your issue resolved quicker.

Please be as descriptive as possible on how the issue happens and what you would expect to happen instead.

## Making changes
If you have a fix, a new feature or keybindings to add/change, then pull requests are most welcome.  Again you can create almost everything from Spacemacs, only visiting GitHub to press the **Create pull request** button at the end.

> Please read the [Spacemacs Conventions](https://github.com/syl20bnr/spacemacs/blob/develop/doc/CONVENTIONS.org) before making changes, especially the naming and keybinding conventions.

To make a change:

* *[Update to the latest `develop` branch](https://www.youtube.com/watch?v=XC7LGI0Q2u8&list=PLpr9V-R8ZxiCHMl2_dn1Fovcd34Oz45su&index=3)* and fork the project to your own GitHub repository.  Or clone Spacemacs to a different directory if you dont want to hack on your live setup.

* *Create a new branch from `develop` with a meaningful name* - `SPC g s` to open Magit Status. `b c` to start creating a branch. Select `develop` from the list of current branches as the base for you new branch.  Type in the name of your new branch and press `RET`.  You are automatically placed in the new branch.

* *Make your changes and create a single commit* - `SPC g s` for magit status, `s` to stage changes, `c c` to create a new commit, entering a commit message.


Use the **[layer-name]** convention if the PR is for a specific layer, to help everyone to find and review your pull request quickly.  For example: **[Clojure] Sesman and missing eval / format keybindings**

[![Spacemacs GitHub Pull Request - Title in square brackets convention](/images/spacemacs-github-pull-request-title-merged.png)](https://github.com/syl20bnr/spacemacs/pull/13215)


Changes in pull requests include three parts and should be all part of a **single commit**.

* CHANGELOG.develop entry - a summary of the change made that is part of the documentation for the next stable release and so everyone can find it easily
* README.org - any changes to using a layer
* The change itself - unless its just a documentation change in the README.org.

## Creating a pull request
An example of making a change to the Clojure layer from within Spacemacs, creating a single commit using Magit.

You only need to visit GitHub to press the *Create Pull Request* button.

If you need to update a Pull Request, then commit all your changes locally using Commit Amend, `c a` in Magit.  Then force push

<!-- Video - consider redoing -->
<iframe width="560" height="315" src="https://www.youtube.com/embed/OMS-3Jl05mE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


Thank you
[Practicalli](https://practicalli.github.io/)
