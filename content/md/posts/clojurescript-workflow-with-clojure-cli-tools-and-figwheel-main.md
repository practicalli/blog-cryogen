{:title "ClojureScript workflow with Clojure CLI tools and Figwheel-main"
 :layout :post
 :date "2022-08-04"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps" "figwheel-main"]}

Getting started with ClojureScript development by creating a new project, using [Figwheel-main](https://figwheel.org/) build tool and [Rebel rich terminal UI](https://practical.li/clojure/clojure-cli/repl/).

The [figwheel-main template](https://github.com/bhauman/figwheel-main-template) creates a project with Clojure CLI configuration, providing example code and build configurations for development, testing and deployment workflows which are explored in some detail.

> Updated from an article first written in 2019 and originally covered in [Practicalli Clojure study group #38 video](https://youtu.be/uuxEYsX-1eg)

<!-- more -->


## Creating projects from templates

Previous articles used [clj-new](https://github.com/seancorfield/clj-new) to create projects using a variety of templates.

[clj-new](https://github.com/seancorfield/clj-new) uses the Leiningen template format and some template developers will include project configuration for Clojure CLI. Each template designer is responsibility as to which project and build tools it supports.

The [figwheel-main template](https://github.com/bhauman/figwheel-main-template) provides an option to create a Leiningen or Clojure CLI project and clj-new will create a Clojure CLI configuration by default.

> Where a template only provides a Leiningen configuration, dependencies listed in `project.clj` should be added to the `:deps` section of `deps.edn`. `dev-dependencies` in `project.clj` should be satisfied by aliases in the project or user-level `deps.edn` configuration.


## ClojureScript project using figwheel

Use the [figwheel-main template](https://github.com/bhauman/figwheel-main-template) to create a ClojureScript project that uses figwheel-main to manage the build.

In a terminal, use the following command:

```shell
clojure -M:project/new figwheel-main practicalli/hello-world -- --reagent
```

> The `:project/new` alias is defined in [practicalli/clojure-deps-edn user-level configuration](https://practical.li/clojure/clojure-cli/install/community-tools.html) and supports `-M`, `-X` and `T` execution flags.
> The `-X` and `-T` flags use a command with key value arguments
>
> `clojure -T:project/new :template figwheel-main :name practicalli/landing-page :args '["+reagent"]'`


The `practicalli/hello-world` defines the main application namespace as `hello-world` and `practicalli` as the domain.

`--` after the name tells clj-new to pass the following text to the template.

`--reagent` is a template option to add reagent React-style library dependencies to the generated project. `--rum` and `--react` are other React-style libraries that could be used instead of `--reagent`


## Project configuration

A new project is created in the `hello-world` directory and contains a `deps.edn` configuration

```clojure
 {:deps {org.clojure/clojure {:mvn/version "1.10.0"}
        org.clojure/clojurescript {:mvn/version "1.11.4"}
        cljsjs/react {:mvn/version "17.0.2-0"}
        cljsjs/react-dom {:mvn/version "17.0.2-0"}
        reagent/reagent {:mvn/version "1.1.1" }}
 :paths ["src" "resources"]
 :aliases {:fig {:extra-deps
                 {com.bhauman/rebel-readline-cljs {:mvn/version "0.1.4"}
                  org.slf4j/slf4j-nop {:mvn/version "1.7.30"}
                  com.bhauman/figwheel-main {:mvn/version "0.2.17"}}
                 :extra-paths ["target" "test"]}
           :build {:main-opts ["-m" "figwheel.main" "-b" "dev" "-r"]}
           :min   {:main-opts ["-m" "figwheel.main" "-O" "advanced" "-bo" "dev"]}
           :test  {:main-opts ["-m" "figwheel.main" "-co" "test.cljs.edn" "-m" "practicalli.test-runner"]}}}
```

Aliases were added by the template to run figwheel and build the ClojureScript code:

* `:fig` adds figwheel-main and rebel-readline libraries as dependencies, slf4j-nop provides a no-operation logger (suppresses default logger warning)
* `:build` runs figwheel-main which generates JavaScript from the ClojureScript code in the project
* `:min` creates a minified single JavaScript file for deployment
* `:test` runs all tests under `tests/practicalli` directory using the figwheel-main test-runner


`dev.cljs.edn` is the build configuration referred to by the `:build` and `:min` aliases using the `dev` name

```clojure
^{:watch-dirs ["test" "src"]
  :css-dirs ["resources/public/css"]
  :auto-testing true
   }
{:main practicalli.hello-world}
```

* `:watch-dirs` defines the directories to monitor files for saved changes
* `:css-dirs` defines the location of the CSS configuration
* `:auto-testng` to [automatically discover and run tests](https://figwheel.org/docs/testing.html)
* `:main` defines the main namespace for the application


## Check figwheel configuration

Ensure figwheel is configured correctly by calling `figwheel.main` without a build configuration.  The ClojureScript code for the project is not compiled so cannot be the cause of any failure or warnings.

This is quick way to identify if issues are from figwheel configuration or from ClojureScript code.

```shell
clojure -M:fig -m figwheel.main
```

A web browser window will open showing the figwheel website, contains the fundamental documentation for developing with Figwheel.

![Figwheel-main - REPL host page](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-main-repl-host-page.png)


## Rich REPL UI with Rebel

Figwheel will run Rebel readline to start the REPL, as the `:fig` alias includes `com.bhauman/rebel-readline-cljs` as an extra dependency.

Rebel provides syntax highlighted code, auto-completion, commands to manage the REPL and Clojure documentation help, all within its rich command line.


![Clojure CLI tools - Figwheel-main - rebel readline](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/clojure-cli-figwheel-main-without-build.png)


Typing `:repl/help` as a command at the Rebel prompt shows characters are syntax highlighted. The command provides a quick reference for Rebels capabilities.

![Figwheel-main - repl help](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/rebel/rebel-repl-help-menu.png)


Evaluate expressions by typing them at the Rebel prompt and pressing `RET`, e.g. `(map inc [2 4 6 8])`

JavaScript interop code also works from the Rebel prompt, e.g. `(js/alert "Notification from the command line")` will display an alert in the browser.

> Practicalli Clojure provides examples of [using Rebel as a rich terminal UI for the Clojure REPL](https://practical.li/clojure/clojure-cli/repl/)
>
> The `clojure` command should be used to run Rebel.  The `clj` wrapper script calls `rlwrap` which conflicts with Rebel, as they are both readline tools.


## Running figwheel and building the project

Calling figwheel with a build configuration compiles the project ClojureScript code into JavaScript as figwheel starts.  The JavaScript code is sent to the JavaScript engine in the browser window that figwheel opened.

Saved changes to the project ClojureScript files will automatically generate updates to the JavaScript code and send them to the JavaScript engine in the browser.

The `:build` alias is used during development of a ClojureScript project

```shell
clojure -M:fig:build
```

![Figwheel-main - project - hello world](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-main-project-hello-world-page.png)


> The `:build` alias defines `figwheel.main` as the main namespace and the arguments passed to the `-main` function in that namespace.
> `"-b" "dev"` will used `dev.cljs.edn` as the configuration, `-r` option to run a REPL prompt (in this case using Rebel)
>
> `:build {:main-opts ["-m" "figwheel.main" "-b" "dev" "-r"]}`
>
> This configuration is the equivalent of running the command `clojure -M:fig -m figwheel.main -b dev -r`


## Run Figwheel-main from Emacs Cider

Figwheel-main projects can be run from Emacs with CIDER using the `cider-jack-in-cljs` command.  The user is prompted for the build name to use.

[Emacs CIDER Jack-in with Clojure CLI projects](https://practicalli.github.io/blog/posts/cider-jack-in-to-clojure-cli-projects-from-spacemacs/) benefits from a `.dir-locals.el` file to set the `:fig` alias (and any other aliases) and the figwheel build configuration when starting the Clojure REPL.

```elisp
((clojure-mode . ((cider-preferred-build-tool          . clojure-cli)
                  (cider-clojure-cli-aliases           . ":fig")
                  (cider-default-cljs-repl             . figwheel-main)
                  (cider-figwheel-main-default-options . "dev")
                  (cider-repl-display-help-banner      . nil))))
```

> Use `cider-connect-cljs` to connect Emacs to a REPL (nREPL) process that is already running, i.e. via the `clojure -M:fig:build` command in the terminal.


## Running tests once

The `test` directory contains source code for unit tests, using a directory path matching the namespace they are testing from the `src` directory.  `-test` is added to the end of the test namespaces.  For example, if we have a source namespace of `practicalli.hello-world`, the tests would be in `practicalli.hello-world-test`.

![ClojureScript - figwheel-main src and test trees](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-project-src-and-test-trees.png)

Use the `:test` alias with the `:fig` alias to run the Figwheel test runner

```shell
clojure -M:fig:test
```

This will open a browser and connect to its JavaScript REPL and run the tests.

![Figwheel-main test runner - test host page](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-main-test-runner-test-host-page.png)

The results of the test run are printed to the terminal

![Figwheel-main - test output in terminal](/images/figwheel-main-test-output-terminal.png)

> Running tests this way may not be as fast as using the continuous testing approach (covered next)

### test configuration

The `:test` alias uses the `test.cljs.edn` build configuration to start the Figwheel test runner and runs all the test namespaces under the `test` directory.

`:test  {:main-opts ["-m" "figwheel.main" "-co" "test.cljs.edn" "-m" practicalli.test-runner]}`

The `test.cljs.edn` build configuration defines a separate URL to open the test host page, to avoid clashing with the URL to connect to the ClojureScript application itself.

```clojure
^{
  ;; alternative landing page for the tests to avoid launching the application
  :open-url "http://[[server-hostname]]:[[server-port]]/test.html"

  ;; launch tests in a headless environment - update path to chrome on operating system
  ;; :launch-js ["/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" "--headless" "--disable-gpu" "--repl" :open-url]
  }
{:main practicalli.test-runner}
```

## Continuous testing during development

Running a figwheel-main build includes continuous testing service, so you can instantly see the results of your tests once the application has started.

```shell
clojure -M:fig:build
```

[http://localhost:9500/figwheel-extra-main/auto-testing](http://localhost:9500/figwheel-extra-main/auto-testing) will show the live results of running the tests.

![Figwheel-main - tests - auto-testing webpage results](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-main-tests-auto-testing-webpage.png)


You may see the auto-testing host page display before showing the test results, or if the web page is reloaded (or if your tests take a long time to run or there are no tests to run)

![Figwheel-main - tests - auto-testng host page](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojurescript/figwheel/figwheel-main-tests-auto-testing-host-page.png)


## Packaging up a single compiled artefact for production

Building ClojureScript applications with Figwheel generates lots of files under `target/public`, as this is the most efficient way to push changes to the JavaScript engine application during development.  Using only a single file when deploying your application to the live system makes your application website faster to load (only one http request).

> The ClojureScript compiler has four :optimizations modes :none, :whitespace, :simple and :advanced.

The `figwheel-main` template provides a `:min` alias to generate a single minified file that has been run through the Google Closure compiler to eliminate any uncalled code.  This generates a single file called `target/public/cljs-out/dev-main.js`

Publish the application by manually copying the file to a suitable deployment directory (or write a script to do so) when you publish your application live.


### Deploying to GitHub pages

[GitHub pages](https://pages.github.com/) and [GitLab pages](https://docs.gitlab.com/ee/user/project/pages/) provide fast and free service for running an HTML website, serving HTML, CSS and JavaScript files.

By placing all the web pages and asset files in a `docs` directory, these services can be configured to serve those assets publicly.

Create a new build configuration to output the single JavaScript file to the `docs` directory, typically in a `js` sub-folder or any preferred directory structure.

Create a file called `pages.cljs.edn` to represent a new build and add the following configuration

```clojure
{:main practicalli.hello-world
 :output-to "docs/js/hello-world.js"}
```

Edit the project `deps.edn` file and add a new alias to deploy to GitHub/GitLab pages directory

```clojure
:pages {:main-opts ["-m" "figwheel.main" "-O" "advanced" "-bo" "pages"]}
```

Create the deployable JavaScript file using the following command:

```shell
clojure -M:fig:pages
```

Copy the `/resources/public/index.html` and any other web assets to the `/docs` directory and update the `/docs/index.html` to refer to the correct location of the JavaScript file generated by Figwheel.

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link rel="icon" href="https://clojurescript.org/images/cljs-logo-icon-32.png">
  </head>
  <body>
    <div id="app">
    </div> <!-- end of app div -->
    <script src="js/hello-world.js" type="text/javascript"></script>
  </body>
</html>
```

> See [package a single file for production](https://figwheel.org/tutorial#packaging-up-a-single-compiled-artifact-for-production) for more details.


## Summary

Using Figwheel provides an simple way to develop, test and deploy ClojureScript projects, providing instant feedback as you develop to see exactly what the code does and help minimise bugs and avoid inappropriate design choices.

> lambdaisland/kaocha-cljs enables using kaocha test runner with ClojureScript project, although I am still working on an example once I've resolved [an issue with the configuration](https://github.com/lambdaisland/kaocha-cljs/issues/48)

Add aliases and build configurations customise the workflows for greater flexibility.  The configuration files are EDN, so are Clojure maps that are simple to work with and understand.

There are more examples of options for figwheel-main projects on the <https://figwheel.org/> website.

Please see earlier articles in the Clojure CLI series for background:

* [Clojure CLI and tools.deps](https://practical.li/blog/posts/clojure-cli-and-tools-deps/)
* [A Deeper Understanding of Clojure CLI Tools](https://practical.li/blog/posts/a-deeper-understanding-of-clojure-cli-tools/)
* [Gaining confidence with Clojure CLI tools](https://practical.li/blog/posts/gaining-confidence-with-Clojure-CLI-tools/)
* [Development workflow with Clojure CLI tools](https://practical.li/blog/posts/development-workflow-with-clojure-cli-tools/)
* [Community Projects for Clojure CLI tools](https://practical.li/blog/posts/community-tools-for-clojure-cli/)


Thank you.
[Practicalli website](https://practical.li) | [@practical_li](https://twitter.com/practical_li)
