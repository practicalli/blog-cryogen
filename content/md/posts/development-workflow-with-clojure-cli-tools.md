{:title "Development Workflow with Clojure CLI tools"
 :layout :post
 :date "2019-08-04"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps" "figwheel-main"]}

Continuing our exploration with Clojure CLI tools, we will discuss what what templates are available to help us create project,  Then we will create a new ClojureScript project using figwheel-main and show the different builds we can use to provide several workflows for developing, testing and deploying an application.

We will create a new project using the [figwheel-main template](https://github.com/bhauman/figwheel-main-template), explaining that we need to specify `organisation/project-name` or `organisation.project-name` for the `clj-new` templates to work properly.

Then run the project using the `-A:fig:build` alias to run with rebel readline to our user account version of `deps.edn` so it is available for all projects.  Then we will run a test runner and see the auto-testing monitoring.  Finally we will show ways to configure a deploy workflow that we can use with GitHub

This article is also covered in [Practicalli Clojure study group #38 video](https://youtu.be/uuxEYsX-1eg)

Please see earlier articles in this series for background:

* [Experimenting With Clojure CLI Tools Options](http://jr0cket.co.uk/2019/07/gaining-confidence-with-Clojure-CLI-tools.html)
* [A Deeper Understanding of Clojure CLI Tools](http://jr0cket.co.uk/2019/07/a-deeper-understanding-of-Clojure-CLI-tools.html)
* [Getting Started With Clojure CLI Tools](http://jr0cket.co.uk/2019/07/getting-started-with-Clojure-CLI-tools.html)

<!-- more -->

## Creating projects from templates

In previous articles we have seen that we can use `clj-new` to create projects using a number of templates.  This tool works with most Leiningen and Boot projects, however, it does not provide a `deps.edn` configuration file if the template itself does not.  It should be easy enough to create your own from the project configuration file that is created by a Leiningen or Boot template (depending on how complex the template is).


## Create a new project using the figwheel-main template

Using the [figwheel-main template](https://github.com/bhauman/figwheel-main-template) we can create a new figwheel-main project with the comand:


```shell
clojure -A:new figwheel-main hello-world.core -- --reagent
```

This creates a basic project with several aliases defined in the `deps.edn` file for the project

```clojure
{:deps {org.clojure/clojure {:mvn/version "1.10.0"}
        org.clojure/clojurescript {:mvn/version "1.10.339"}
        reagent {:mvn/version "0.8.1"}}
 :paths ["src" "resources"]
 :aliases {:fig {:extra-deps
                  {com.bhauman/rebel-readline-cljs {:mvn/version "0.1.4"}
                   com.bhauman/figwheel-main {:mvn/version "0.1.9"}}
                 :extra-paths ["target" "test"]}
           :build {:main-opts ["-m" "figwheel.main" "-b" "dev" "-r"]}
           :min   {:main-opts ["-m" "figwheel.main" "-O" "advanced" "-bo" "dev"]}
           :test  {:main-opts ["-m" "figwheel.main" "-co" "test.cljs.edn" "-m" practicalli.test-runner]}}}
```

* `:fig` adds the figwheel-main and rebel-readline libraries as dependencies
* `:build` runs figwheel-main and creates a build of the project code and tests
* `:min` creates a minified single JavaScript file for deployment
* `:test` runs all the tests once using the test-runner

We will explore these builds and the workflow they provide as we go through this article.


## Running figwheel

We can run figwheel by specifying `figwheel-main` as the main namespace.  Figwheel will run a browser and connect to its JavaScript REPL, sending any code we type there to be evaluated..

```shell
clojure -A:fig -m figwheel.main
```

>
> [Running a deps.edn project from CIDER (Emacs/Spacemacs)](https://practicalli.github.io/blog/posts/cider-jack-in-to-clojure-cli-projects-from-spacemacs/) may require a `.dir-locals.el` file to set which alias you wish to run by default.  CIDER version 0.23 onwards should offer you a choice of alias to run.


The browser will show the default figwheel website that contains basic instructions on how to work with figwheel.

![figwheel-main - REPL host page](/images/figwheel-main-REPL-host-page.png)

`com.bhauman/rebel-readline-cljs` is defined as a dependency in the `:fig` alias in the project `deps.edn`.  This allows figwheel to detect the presence of rebel readline and use it when starting the ClojureScript REPL, to give a very interactive command line.  If rebel readline is dectected you will see the following line a few lines before the `cljs.user=>` prompt.

```
[Rebel readline] Type :repl/help for online help info
This confirms that we are using Rebel Readline.
```

![Clojure CLI tools - Figwheel-main - rebel readline](/images/clojure-cli-tools-figwheel-main-rebel-readline-map.png)


If you type :repl/help command at the prompt, as you type you immediately notice that :repl/help character are syntax highlighted. Upon hitting enter, you will see a useful reference for the REPL’s capabilities displayed.

![Figwheel-main - repl help](/images/figwheel-main-repl-help.png)


> Use the `clojure` command when using rebel-readline.  The `clj` command provides it’s own terminal line reader

We can call expressions in the REPL prompt, for example some typical ClojureScript such as `(map inc [2 4 6 8])`

Or we can evaluate some JavaScript interop code and see things change in the browser `(js/alert "Notification from the command line")`


## Running figwheel and building the project

So far we have only run figwheel, however, our template did create some simple code that we can run that displays a website.

The template also added more aliases that defined different ways to build a project.

When developing we would typically run the `:build` alias along with `:fig`

`clojure -A:fig:build`


![Figwheel-main - project - hello world](/images/figwheel-main-project-hello-world.png)


> when we look in the project `deps.edn` file we can see the details of the command that the `build` alias uses
> `:build {:main-opts ["-m" "figwheel.main" "-b" "dev" "-r"]}`
>
>  This configuration is the equivalent of running the command
`clojure -A:fig -m figwheel.main -b dev -r`
>
> This command uses the `:fig` alias to add figwheel-main and rebel readline libraries, sets `figwheel-main` as the main namespace, the build as `dev` and `-r` to run a REPL.



## Running tests once

The source code for tests are placed under the top level `test` directory and uses a directory path that matches their namespace, matching those in `src`.  Source code files test a matching namespace and have `-test` added to the end of their name.  For example, if we have a source namespace of `practicalli.hello-world`, the tests would be in `practicalli.hello-world-test`.

We can run tests created by the `figwheel-main` template by running `clojure` with the `:test` alias.

> As before, the `:fig` alias pulls in the `figwheel-main` and `rebel-readline` dependencies.

```shell
clojure -A:fig:test
```

This will open a browser and connect to its JavaScript REPL and run the tests.  The results can be seen in the terminal window from where you ran the `clojure` command.

![Figwheel-main - test output in terminal](/images/figwheel-main-test-output-terminal.png)

The `:test` alias sets `figwheel.main` as the main namespace so it can run the figwheel test-runner functions

`:test  {:main-opts ["-m" "figwheel.main" "-co" "test.cljs.edn" "-m" practicalli.test-runner]}`


## Continuous testing

Running a figwheel-main build will also include continuous testing service, so you can instantly see the results of your tests.

```shell
clojure -A:fig:build
```

http://localhost:9500/figwheel-extra-main/auto-testing will show the live results of running the tests.

![Figwheel-main - tests - auto-testing webpage results](/images/figwheel-main-tests-auto-testing-webpage.png)


You may see the auto-testing host page display before showing the tests

![Figwheel-main - tests - auto-testng host page](/images/figwheel-main-tests-auto-testing-host-page.png)


## Packaging up a single compiled artifact for production

The building of ClojureScript applications generates lots of files under `target/public`, as this is the most efficient way to manage changes to your application during development.  Using only a single file when deploying your application to the live system makes your application website faster to load (only one http request).

> The ClojureScript compiler has four :optimizations modes :none, :whitespace, :simple and :advanced.

The `figwheel-main` template provides a `:min` alias to generate a single minified file that has been run through the Google Closure compiler to eliminate any uncalled code.  This generates a single file called `target/public/cljs-out/dev-main.js`

You can manually copy this file to a suitable deployment directory when you publish your application live.

### Deploying to GitHub pages

[GitHub pages](https://pages.github.com/) provides a fast and free service for running a website (html, css and JavaScript files).  You can run a website by placing all the files in a `docs` directory.

Rather than manually copy the `dev-main.js` file each time you want to deploy, create a new build configuration to output the single JavaScript file to a different location.

Create a file called `github-pages.cljs.edn` to represent a new build and add the following configuration

```clojure
{:main practicalli.hello-world
 :output-to "docs/cljs-out/dev-main.js"}
```

Then edit the `deps.edn` file and change the `:min` alias to use the `deploy` build

```clojure
:min {:main-opts ["-m" "figwheel.main" "-O" "advanced" "-bo" "github-pages"]}
```

Instead of changing the `:min` alias, you could also add a new alias to deploy to GitHub pages directory.

```clojure
:github-pages {:main-opts ["-m" "figwheel.main" "-O" "advanced" "-bo" "github-pages"]}
```

> See [package a single file for production](https://figwheel.org/tutorial#packaging-up-a-single-compiled-artifact-for-production) for more details.


## Summary

It is very easy to add aliases and build configurations to customise the workflows you use for your Clojure CLI tools project.  As all the configuration files are in EDN, they are Clojure maps and therefore very easy to work with and understand.

There are more examples of options for figwheel-main projects on the https://figwheel.org/ website.

Thank you.
[@jr0cket](https://twitter.com/jr0cket)
