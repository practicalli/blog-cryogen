{:title "Community projects for Clojure CLI tools"
 :date "2019-08-09"
 :layout :post
 :topic "clojure-cli"
 :tags  ["clojure-cli"]}

There are a number of tools from the Clojure community which add build tool features to the Clojure CLI tools.  This enables developers to have a very lightweight and customisable set of tools that just do what they need.

This article just covers the very basics of each tool, see each projects documentation to get the full benefit of each tool.

* [depot](https://github.com/Olical/depot) finds newer versions of libraries (from Clojars and Git repositories)
* [kaocha](https://github.com/lambdaisland/kaocha) full featured next gen Clojure test runner
* [depstar](https://github.com/seancorfield/depstar) to package up your application for the JVM platform

Please see earlier articles in this series for background:

* [Experimenting With Clojure CLI Tools Options](http://jr0cket.co.uk/2019/07/gaining-confidence-with-Clojure-CLI-tools.html)
* [A Deeper Understanding of Clojure CLI Tools](http://jr0cket.co.uk/2019/07/a-deeper-understanding-of-Clojure-CLI-tools.html)
* [Getting Started With Clojure CLI Tools](http://jr0cket.co.uk/2019/07/getting-started-with-Clojure-CLI-tools.html)

<!-- more -->

## [depot](https://github.com/Olical/depot) - find new library versions

[depot](https://github.com/Olical/depot) will look for newer versions of the maven (clojars, maven central) and git dependencies in the project `deps.edn` file.

Install depot by adding an alias to the project `deps.edn` file or `$HOME/.clojure/deps.edn` file

```clojure
:outdated {:extra-deps
            {olical/depot {:mvn/version "1.8.4"}}
           :main-opts ["-m" "depot.outdated.main"]}
```

To automatically update the dependency, add the `--update` option

```clojure
:depot {:extra-deps
            {olical/depot {:mvn/version "1.8.4"}}
:outdated {:main-opts ["-m" "depot.outdated.main"]}
:outdated-update {:main-opts ["-m" "depot.outdated.main" "--version"]}}
```

Show the outdated dependencies with `clojure -A:depot:outdated`.

Automatically update the dependencies with `clojure -A:depot:outdated-update`


## [koacha](https://github.com/lambdaisland/kaocha) test runner

[koacha](https://github.com/lambdaisland/kaocha) is a new test runner that works with Clojure CLI tools, Leiningen and Boot. Kaocha understands different types of tests including clojure.test, ClojureScript, Cucumber, Fudje, Expectations, allowing all tests to be handled in the same way.  This test runner also produces very useful reports using pretty printing so its easy to get meaning from them.

Install by editing your `deps.edn` file and add an alias for kaocha

```clojure
:test {:extra-deps
        {lambdaisland/kaocha {:mvn/version "0.0-529"}}}
```

Create a wrapper script called `bin/kaocha`

```bash
#!/usr/bin/env bash
clojure -A:test -m kaocha.runner "$@"
```

[Create a tests.edn file](https://cljdoc.org/d/lambdaisland/kaocha/0.0-529/doc/3-configuration) at the root of the project.  Start with a default configuration by just adding the following line:

```clojure
#kaocha/v1 {}
```

[Read the detailed documentation](https://cljdoc.org/d/lambdaisland/kaocha/0.0-529/doc/readme) to get the most out of Kaocha.


## [depstar](https://github.com/seancorfield/depstar)

[depstar](https://github.com/seancorfield/depstar) creates a jar of your application or uberjar that also includes the Clojure library and can be deployed directly on the JVM platform.  depstar does not ahead of time (aot) compile your project.

Add the `:depstar` alias to the project `deps.edn` or `$HOME/.clojure/deps.edn` to make depstar available for all projects.

```clojure
:aliases {:depstar
            {:extra-deps
               {seancorfield/depstar {:mvn/version "0.3.1"}}}}
```

Create a jar or uberjar file using the respective command:

```shell
clojure -A:depstar -m hf.depstar.jar myJar.jar
clojure -A:depstar -m hf.depstar.uberjar myUberJar.jar
```

The `-v` or `--verbose` after the filename lists all the files that are added to the jar file.

Add web assets into an uberjar by including an alias in your deps.edn:

```clojure
{:paths ["src"]
 :aliases {:webassets {:extra-paths ["public-html"]}}}
```

Then invoke depstar with the chosen aliases:

```shell
clojure -A:depstar:webassets -m hf.depstar.uberjar MyProject.jar
```

An uberjar is run using the command:

```shell
java -jar MyProject.jar -m project.core
```

## Other tools to investigate at another time

* [clj-kondo](https://github.com/borkdude/clj-kondo/) linter written in Clojure with [GraphViz based dependency graph](https://github.com/borkdude/clj-kondo/blob/master/analysis/README.md#namespace-graph) and [other tools](https://github.com/borkdude/clj-kondo/blob/master/analysis/README.md#example-tools)
* [juxt.pack](https://github.com/juxt/pack.alpha) to package your applications as a jar, uberjar, clojars, maven, lambda and docker
* [lein-tools-deps](https://github.com/RickMoynihan/lein-tools-deps) - dependencies with Leiningen
* [aka](https://github.com/matthias-margush/aka) is for sharing aliases (not very clear what that means or why its useful - see project)
* [Plum](https://laughing-banach-af1115.netlify.com/) is a tool for managing Clojure projects - a wrapper for several community projects.
* [version-clj](https://github.com/xsc/version-clj) Clojure & ClojureScript library for analysis and comparison of artifact version numbers (used by depot)
* [Meyvn](https://github.com/danielsz/meyvn) enables you to generate uberjars (executables) and jars (libraries), and to deploy them on remote servers, e.g. Clojars
* [jet](https://github.com/borkdude/jet) - CLI to transform between JSON, EDN and Transit, powered with a minimal query language.


> Visit [Sean Corfield's dot-clojure repository](https://github.com/seancorfield/dot-clojure) for more tools and how to configure them with Clojure CLI tools.


## Interesting articles on Clojure CLI tools

* [Clojure CLI projects from scratch Oli.me.uk](https://oli.me.uk/2018-02-26-clojure-projects-from-scratch/)
* [Clojure on Heroku](https://devcenter.heroku.com/categories/clojure-support) now supports Clojure CLI tools.
* [Clojure deps.edn - a basic guide](https://tomekw.com/clojure-deps-edn-a-basic-guide/)
* [Moving to deps.edn and shadow-cljs](https://manuel-uberti.github.io/programming/2018/11/14/deps-shadow-cljs/)
* [a streamlined template for developing a new Clojure+Clojurescript web application with the Clojure CLI tools](https://gitlab.com/lambdatronic/clojure-webapp-template)
*

Thank you.

[@jr0cket](https://twitter.com/jr0cket)
