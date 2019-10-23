{:title "Clojure CLI and tools.deps"
 :layout :post
 :date "2019-07-13"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps"]}

Clojure Command Line Interface (CLI) tools provide a fast way for developers to get started with Clojure and simplify an already pretty simple experience.   With tools.deps it also provides a more flexible approach to including libraries, including the use of code from a specific commit in a Git repository.

 [Practicalli Clojure 35 - Clojure CLI tools - an introduction](https://www.youtube.com/watch?v=JsdgIKUD_6Q&list=PLpr9V-R8ZxiDjyU7cQYWOEFBDR1t7t0wv&index=37) is a video of a live broadcast of this content (inclucing typos)

Clojure CLI tools provide:
* Running an interactive REPL (Read-Eval-Print Loop)
* Running Clojure programs
* Evaluating Clojure expressions
* Managing dependencies via tools.deps

Clojure CLI tools allow you to use other libraries to, referred to as dependencies or 'deps'. These may be libraries you are writing locally, projects in git (e.g. on GitHub) or libraries published to Maven Central or [Clojars](https://clojars.org/).

The Clojure CLI tools can cover the essential features of Clojure Build tools Leiningen and Boot, but are not designed as a complete replacement.  Both these build tools are mature and may have features you would otherwise need to script in Clojure CLI tools.

This article is a follow on from [new Clojure REPL Experience With Clojure CLI Tools and Rebel Readline](http://jr0cket.co.uk/2018/07/New-Clojure-REPL-experience-with-Clj-tools-and-rebel-readline.html)

<!-- more -->

## Getting started

Clojure is packaged as a complete library, a JVM JAR file, that is simply included in the project like any other library you would use.  You could just use the Java command line, but then you would need to pass in quite a few arguments as your project added other libraries.

Clojure is a hosted language, so you need to have a Java runtime environment (Java JRE or SDK) and I recommend installing this from [Adopt OpenJDK](https://adoptopenjdk.net/).  Installation guides for Java are covered on the [ClojureBridge London website](https://clojurebridgelondon.github.io/workshop/development-tools/java.html)

The [Clojure.org getting started guide](https://clojure.org/guides/getting_started) covers instructions for Linux and MacOXS operating systems.  There is also an early access release of clj for windows


## Basic usage

The installation provides the command called `clojure` and a wrapper called `clj` that provides a readline program called rlwrap that adds completion and history once the Clojure REPL is running.

Use `clj` when you want to run a repl (unless you are using rebel readline instead) and `clojure` for everything else.

Start a Clojure REPL using the `clj` command in a terminal window.  This does not need to be in a directory containing a Clojure project for a simple REPL.

```
clj
```

A Clojure REPL will now run. Type in a Clojure expression and press `Return` to see the result

![Clojure CLI Tools REPL](https://clojure.org/images/content/guides/repl/show-terminal-repl.gif)

Exit the REPL by typing `Ctrl+D` (pressing the `Ctrl` and `D` keys at the same time).


Run a Clojure program in a the given file.  This would be useful if you wanted to run a script or batch jobs.

```
clojure script.clj
```

Aliases can be added that define configurations for a specific build task:

```
clojure -A:my-task
```

> You can use and legal Clojure keyword name for an alias and include multiple aliases with the `clojure` command.  For example in this command we are combining three aliases:
> `clojure -A:my-task:my-build:my-prefs`

## What version of Clojure CLI tools are installed?

The `deps.edn` file allows you to specify a particular version of the Clojure language the REPL and project use.  You can also evaluate `*clojue-version*` in a REPL to see which version of the Clojure language is being used.

`clj -Sdescribe` will show you the version of the Clojure CLI tools that is currently installed.

![clojure cli tools - describe install version](/images/clojure-cli-tools-install-version-describe.png)

> `clj -Sverbose` will also show the version of Clojure CLI tools used before it runs a Rimages


## deps.edn

`deps.edn` is a configuration file using extensible data notation (edn), the language that is used to define the structure of Clojure itself.

Configuration is defined using a map with top-level keys for `:deps`, `:paths`, and `:aliases` and any provider-specific keys for configuring dependency sources (e.g. GitHub, GitLab, Bitbucket).

`~/.clojure/deps.edn` for global configurations that you wish to apply to all the projects you work with

`project-directory/deps.edn` for project specific settings

The installation directory may also contain a `deps.edn` file.  On my Ubuntu Linux system this location is `/usr/local/lib/clojure/deps.edn` and contains the following configuration.

```clojure
{
  :paths ["src"]

  :deps {
    org.clojure/clojure {:mvn/version "1.10.1"}
  }

  :aliases {
    :deps {:extra-deps {org.clojure/tools.deps.alpha {:mvn/version "0.6.496"}}}
    :test {:extra-paths ["test"]}
  }

  :mvn/repos {
    "central" {:url "https://repo1.maven.org/maven2/"}
    "clojars" {:url "https://repo.clojars.org/"}
  }
}
```

> Note: the install `deps.edn` is now depreciated and will not be included in a future version of the Clojure CLI tools.

The deps.edn files in each of these locations (if they exist) are merged to form one combined dependency configuration. The merge is done in the order above install/config/local, last one wins. The operation is essentially merge-with merge, except for the :paths key, where only the last one found is used (they are not combined).

You can use the `-Sverbose` option to see all of the actual directory locations.

Much more detail is covered in the Clojure.org article - [deps and cli](https://clojure.org/reference/deps_and_cli)


## Using Libraries - deps.edn

`deps.edn` file in the top level of your project can be used to include libraries in your project.  These may be libraries you are writing locally, projects in git (e.g. on GitHub) or libraries published to Maven Central or [Clojars](https://clojars.org/).

Include a library by providing its name and other aspects like version.  This information can be found on [Clojars](https://clojars.org/) if the library is published there.

Libraries as JAR files will be cached in the `$HOME/.m2/repository` directory.

### Example clj-time

Declare [`clojure.java-time`](https://github.com/dm3/clojure.java-time) as a dependency in the `deps.edn` file, so Clojure CLI tools can downloaded the library and add it to the classpath.

```clojure
{:deps
 {org.clojure/clojure {:mvn/version "1.10.1"}
  clojure.java-time {:mvn/version "0.3.2"}}}
```

## Writing code

For larger projects you should definately find an editor you find productive and has great CLojure support.  You can write code in the REPL and you can just run a specific file of code, if you dont want to set up a full project.

Create a directory `what-time-is-it`.

Create a `deps.edn` file in this directory with the following code:

```clojure
{:paths ["src"]
 :deps {org.clojure/clojure {:mvn/version "1.10.1"}
        clojure.java-time {:mvn/version "0.3.2"}}}
```

Create a `src` directory and the source code file `src/practicalli/what_time_is_it.clj` which contains the following code:

```clojure
(ns practicalli.what-time-is-it
  (:require [java-time :as time]))

(defn -main []
  (println "The time according to Clojure java-time is:"
           (time/local-date-time)))
```
The code has a static entry point named `-main` that can be called from Clojure CLI tools. The `-m` option defines the main namespace and by default the `-main` function is called from that namespace.  So the Clojure CLI tools provide program launcher for a specific namespace:

```shell
clojure -m practicalli.what-time-is-it

The time according to Clojure java-time is: #object[java.time.LocalDateTime 0x635e9727 2019-08-05T16:04:52.582]
```

## Using libraries from other places

With `deps.edn` you are not limited to using just dependencies from JAR files, its much easier to pull code from anywhere.

* [Using local libraries](https://clojure.org/guides/deps_and_cli#_using_local_libraries)
* [Using git libraries](https://clojure.org/guides/deps_and_cli#_using_git_libraries)


> TODO: Expand on this section in another article with some useful examples


## rebl readline

[Rebel readline](https://github.com/bhauman/rebel-readline) enhances the REPL experience by providing multi-line editing with auto-indenting, language completions, syntax highlighting and function argument hints as you code.

 {% youtube u8B65_a_QYE %}


* [New Clojure REPL experience with Clj tools and rebel readline](http://jr0cket.co.uk/2018/07/New-Clojure-REPL-experience-with-Clj-tools-and-rebel-readline.html)
* [rebel-readline in Clojure CLI REPL](https://www.youtube.com/watch?v=u8B65_a_QYE)


## clj-new

[clj-new](https://github.com/seancorfield/clj-new) is a tool to generate new projects from its own small set of templates.  You can also create your own clj-new templates.  It is also possible to generate projects from Leiningen or Boot templates, however, this does not create a `deps.edn` file for Clojure CLI tools, it just creates the project as it would from either Leiningen or Boot.

Add `clj-new` as an alias in your `~/.clojure/deps.edn` like this:

```clojure
{

:aliases
 {:new {:extra-deps {seancorfield/clj-new
                     {:mvn/version "0.7.6"}}
        :main-opts ["-m" "clj-new.create"]}}

}
```
Create a Clojure CLI tools project using the `clj-new` app template

```shell
clj -A:new app myname/myapp
cd myapp
clj -m myname.myapp
```

The `app` template creates a couple of tests to go along with the sample code.  We can use the cognitec test runner to run these tests using the `:test` alias

```shell
clj -A:test:runner
```

`clj-new` currently has the following built-in templates:

`app` -- a `deps.edn` project with sample code, tests and the congnitect test runner, clj -A:test:runner.  This project includes `:gensys` directive, so can be run as an application on the command line via `clj -m`
`lib` -- the same as the `app` template, but without the `:gensys` directive as this is mean to be a library.
`template` -- the basis for creating your own templates.


##   figwheel-main

Use the [figwheel-main template](https://github.com/bhauman/figwheel-main-template) to create a project for a simple Clojurescript project, optionally with one or reagent, rum or om libraries.


## Defining aliases

An alias is a way to add optional configuration to your project which is included when you use the alias name when running `clojure` or `clj`.

We will cover examples of using aliases as we discover more about Clojure CLI tools.  For now, take a look at [Clojure CLI and deps.edn](https://www.youtube.com/watch?v=CWjUccpFvrg) - video by Sean Corfield


## Multiple versions of Clojure CLI tools

Installing CLI tools downloads a tar file that contains the installation files, the executables, man pages, a default `deps.edn` file, an `example-deps.edn` and a Jar file.

![Clojure cli tools - install - tar contents](/images/clojure-cli-tools-install-tar-contents.png)

The jar file is installed in a directory called `libexec` is not removed when installing newer versions of the Clojure CLI tools, so you may find multiple versions inside the `libexec` directory.

![Clojure CLI tools - install - multiple versions](/images/clojure-cli-tools-install-multiple-versions.png)

## Summary

Despite the seemingly stripped-down set of options available in deps.edn (just :paths, :deps, and :aliases), it turns out that the `:aliases` feature really provides all you need to bootstrap a wide variety of build tasks directly into the clojure command.  The Clojure community is building lots of tools on top of Clojure CLI tools to provide richer features that can simply be added as an alias.

What I really like best about this approach is that I can now introduce new programmers to Clojure using command line conventions that they are likely already familiar with coming from many other popular languages like perl, python, ruby, or node.


## References
* [Clojure CLI webapp template](https://gitlab.com/lambdatronic/clojure-webapp-template) - @lambdatronic
* [A sample full stack Clojure CLI project](https://github.com/oakes/full-stack-clj-example) - @oakes
* [JUXT Edge - a clojure application foundation](https://github.com/juxt/edge) - @juxt


Thank you.
[@jr0cket](https://twitter.com/jr0cket)
