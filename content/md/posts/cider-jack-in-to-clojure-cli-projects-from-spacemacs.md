{:title "CIDER jack-in to Clojure CLI projects from Spacemacs"
 :date "2019-07-16"
 :layout :post
 :topic "spacemacs"
 :tags  ["clojure-cli" "spacemacs" "cider" "figwheel-main" "emacs"]}

Running a Clojure project created with CLI tools or `clj-new` may require you to pass in an alias for the REPL to pick up the right libraries.

 A few days ago I created a new ClojureScript and reagent project, using the Clojure CLI tools and `clj-new` project creation tool, which converts Leiningen and Boot templates into a deps.edn based project.  Unfortunately when I created a project from the fighwheel-main template the REPL failed to run from CIDER using `cider-jack-in-cljs`, saying that figwheel-main was not found.  All that was required was to specify the `:fig` alias when running a REPL.

This article covers two approaches to running Clojure CLI projects from CIDER jack-in that require setting of an alias or multiple aliases e.g. `-A:fig:build:party:hammock`

> See [Practicalli Clojure: Clojure and Clojure CLI](https://practical.li/clojure/clojure-cli/) for details on using the Clojure CLI

> Article updated on 2nd Janauary 2022

<!-- more -->

## Understanding the problem

I created a new project with the Clojure CLI tools and the figwheel-main template (using the `:project/new` alias from [practicalli/clojure-deps-edn](https://github.com/practicalli/clojure-deps-edn)).

```shell
clojure -M:project/new figwheel-main practicalli/study-group-guide -- --reagent
```

The figwheel-main project template creates a `deps.edn` file in the project containing the alias `:fig` (typically renamed to `:env/figwheel` for better context).


Running `cider-jack-in-cljs` from Spacemacs (`, m s`) prompted for the build tool.  `figwheel-main` was selected and rather than being prompted for the name of the build to run, the following error was displayed in the Emacs mini-buffer.

```
error in process filter: Figwheel-main is not available.  Please check https://docs.cider.mx/cider/basics/clojurescript
```

The same error was seen when looking at the output in the `*messages*` buffer, (`SPC b m`).

```
Starting new CIDER session ...
[nREPL] Starting server via /usr/local/bin/clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version "0.9.0"} cider/piggieback {:mvn/version "0.5.2"} cider/cider-nrepl {:mvn/version "0.27.4"}} :aliases {:cider/nrepl {:main-opts ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware,cider.piggieback/wrap-cljs-repl]"]}}}' -M:cider/nrepl
[nREPL] server started on 40737
[nREPL] Establishing direct connection to localhost:40737 ...
[nREPL] Direct connection to localhost:40737 established
 error in process filter: user-error: Figwheel-main is not available.
 ```

The web page for the ClojureScript did not automatically open because figwheel-main is not running and the application was not built.

The project fails to run when using `cider-jack-in-cljs` as it cannot find the figwheel-main namespace.  This is because CIDER is not being called with the `-A:fig` alias, which has a configuration to include figwheel-main as a dependency.


## Hacking the CIDER jack-in command

Its easy to edit the `cider-jack-in-*` command that CIDER uses to start a REPL using the universal argument `C-u` (`SPC-u` in Spacemacs).

`SPC u , m s` to call the Cider session manager or `SPC u , s j s` to call `cider-jack-in-cljs` with the universal argument.  This will display an editable prompt for Cider jack-in in the mini-buffer.

![Spacemacs Clojure - CIDER jack-in command line hacking](/images/spacemacs-clojure-cider-jack-in-command-line-hacking.png)

Use the arrow keys to edit this command and add the `:fig` alias as the first alias to the `-M` execution option, so the option should be `-M:fig:cider/nrepl`

```shell
/usr/local/bin/clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version "0.9.0"} cider/piggieback {:mvn/version "0.5.2"} cider/cider-nrepl {:mvn/version "0.27.4"}} :aliases {:cider/nrepl {:main-opts ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware,cider.piggieback/wrap-cljs-repl]"]}}}' -M:fig:cider/nrepl
```

> Emacs would use C-u before a cider-jack-in-* keybinding, `C-u C-c M-J` for the same results.

The `*messages*` buffer also shows the edited command line used to start a ClojureScript REPL.

```
[nREPL] Starting server via /usr/local/bin/clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version "0.9.0"} cider/piggieback {:mvn/version "0.5.2"} cider/cider-nrepl {:mvn/version "0.27.4"}} :aliases {:cider/nrepl {:main-opts ["-m" "nrepl.cmdline" "--middleware" "[cider.nrepl/cider-middleware,cider.piggieback/wrap-cljs-repl]"]}}}' -M:fig/cider/nrepl
[nREPL] server started on 35247
[nREPL] Establishing direct connection to localhost:35247 ...
[nREPL] Direct connection to localhost:35247 established
```


## Adding CIDER configuration with `.dir-locals.el`

Rather than edit the cider jack-in command options each time, a local configuration file can be created to set a variable defining the :fig alias we want to include when running a REPL for this project.

`.dir-locals.el` is an Emacs configuration file in which you can set variables for use with all files within the current directory or its child directories.

`SPC p e` (`add-dir-local-variable`) is a simple wizard function to help you create a `.dir-locals.el` file.  First prompt is for the major mode, then a variable name and variable value.

This  variable will be used with the `clojure-mode` (using `nil` rather than `clojure-mode` the variable would be applied to all modes).

A variable called `cider-clojure-clj-global-options` will be used to set the `:fig` alias.

```clojure
((clojure-mode . ((cider-clojure-cli-global-options . "-M:fig"))))
```

`SPC SPC revert-buffer` on one of the project source code files will load the variable from `.dir-locals.el` into Spacemacs.   Otherwise, you can close the project buffer(s) and re-open them to load this variable into Emacs.  Once the buffer is loaded again, running `cider-jack-in-cljs` works perfectly.

You can check the results by looking at the `*mesages*` buffer and you will see the details of the command that `cider-jack-in-cljs` function ran.


> The `.dir-locals.el` is a list of lists.  Each inner list contains which maps major mode names (symbols) to alists (see Association Lists). Each alist entry consists of a variable name and the directory-local value to assign to that variable, when the specified major mode is enabled. Instead of a mode name, you can specify ‘nil’, which means that the alist applies to any mode; or you can specify a subdirectory (a string), in which case the alist applies to all files in that subdirectory.


## Understanding the :fig alias

deps.edn has a top-level key called `:aliases` that can include one or more alias definitions as maps.  This example is from the `figwheel-main` template and has an extra dependency for the `figwheel-main` and `rebel-readline-cljs` libraries.  So when starting a REPL with this alias, both those dependencies are available in the project.

```clojure
  :fig
  {:extra-deps
   {com.bhauman/rebel-readline-cljs {:mvn/version "0.1.4"}
    com.bhauman/figwheel-main {:mvn/version "0.2.11"}}
   :extra-paths ["target" "test"]}
```
```

The alias keeps these develop time libraries out of our application dependencies, as they are not required for running the application.


> Leiningen includes figwheel-main as a dependency in the `project.clj` file in the `:profiles {:dev ,,,}` section. The `dev` profile is used by Leiningen by default, so the figwheel-main dependency is always there.



## Summary

Using CIDER with projects created with Clojure CLI tools and `clj-new` works very well and only requires specification of which alias to use when starting the REPL from within Spacemacs.

If you have multiple aliases needed each time, you can chain them together:`-A:fig:build:custom` by editing the jack-in command line or including those aliases in the `.dir-locals.el`

Thank you.
[@practicalli](https://twitter.com/practical_li)

[Practicalli - free online books on Software Engineering and Clojure development](https://practical.li/)
