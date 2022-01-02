{:title "Emacs CIDER removing old cider-compat namespace"
:layout :post
:date "2022-01-02"
:topic "spacemacs"
:tags  ["spacemacs" "cider" "packages"]}

The latest snapshot of CIDER includes some welcome tidy up of the code.  One [notable removal is `cider-compat`](https://github.com/clojure-emacs/cider/commit/c60598fa4df6cdd3331c29b8e319cc23de1b7cc6) which was added to support Emacs versions previous to 25.  As most of the Emacs world is on version 27 (or 28 / 29) then there is no need to include `cider-compat` any more.

However, some Emacs packages that haven't change in a while may still used `cider-compat`, although the only one to date that has been found is `helm-cider`.  Unfortunately is causing Clojure file to fail to load when used with the latest CIDER snapshot.

When helm-cider is enabled, Emacs is unable to load Clojure files.  The error reported is:

```
helm-cider-spec.el:27:1:Error: Cannot open load file: No such file or directory, cider-compat
```

Here are a few options to work around this issue

> The maintainer of helm-cider has merged a fix already (Thank you Bozhidar) and a new package has been built by MELPA - https://melpa.org/#/helm-cider (see Build log for details)


<!-- more -->


## Hack helm-cider code

There is only one line of code that is causing the issue, on line 27 of helm-cider-spec.el, so this can be deleted.

![helm-cider cider-compat issue](https://raw.githubusercontent.com/practicalli/graphic-design/live/spacemacs/screenshots/emacs-helm-cider-spec-compat-line.png)

Restarting Emacs after this removal should resolve the issue.

The helm-cider package has not been updated since 2018 (it works very well, so no reason for an update until now).  So hacking the helm-cider code should be a relatively quick and safe option

## Fixing Helm-cider

An [issue was raised on the helm-cider repository](https://github.com/clojure-emacs/helm-cider/issues/12) describing the issue.

It would seem that cider-compat namespace is not actually used by helm-cider-spec.el namespace, so the fix would be to remove the `(reqiure 'cider-compat)` line.

`cider-compat` provides macros to define `if-let*` and `when-let*` if they are not already present.  The helm-cider-spec namespace does not actually call either of these with the current code, so its superfluous anyway.

A [pull request has been raised to delete the require](https://github.com/clojure-emacs/helm-cider/pull/13).  Hopefully the maintainer is able to push out a new version of the package.


## Pinning CIDER package

Emacs configuations such as Spacemacs and Doom tend to use the latest snapshot available for a package.  In this case you could either use a backup of a version of CIDER from before 29th December, or pin an earlier version.


#### Pinning a package in Spacemacs

Pin CIDER to an earlier version by adding the following recipe to `dotspacemacs/additional-packages`

```elisp
(cider :location
   (recipe :fetcher github
           :repo "clojure-emacs/cider"
           :commit "ae376429a8cf22b82a9e18ff844bdfbe5fc7ecc1"))
```

Delete the packages `cider-*`, `clojure-mode-*` and `cider-eval-sexp-fu-*` from `~/.emacs.d/elpa/<emacs-version>/develop/`

Comment out `cider` or `(cider ,,,)` from the `dotspacemacs-configuration-layers` (as that will automatically download the latest version)

Restart and the pinned version of Cider will be installed.

If you have clojure variables set in the layer list, then you can uncomment them and restart for those to take effect (this will not update the package, that will only be done if using `SPC f e U` )


#### Pinning a package in Doom

All of Doom's packages are pinned by default. A pinned package is a package locked to a specific commit. So to pin CIDER to a version is of the form:

```elisp
(package! cider :pin "ae376429a8")
```

> Practicalli has only dabbled with Doom, so this hasn't been tested yet.  Please let me know if this needs altering.


## Summary

Using snapshot features does provide early access to improvements in packages and an opportunity to provide feedback to the maintainers.  However, there is a small risk of having to manage an occasional issue such as this.

It is recommended that packages are only updated when you have spare capacity to resolve possible issues and do not have any time sensitive work to be done.

Most issues are fixed pretty quickly or at least have a work-around.

Thank you
[Practicalli](https://practical.li/)
