{:title "Clojure CLI - understanding aliases"
 :layout :post
 :date "2021-12-19"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps"]}

[Clojure CLI](https://clojure.org/guides/install_clojure) provide a very flexible way to run Clojure and uses aliases in a `deps.edn` configuration file to optionally include execution options, code paths and library dependencies (Maven & Git). Aliases can be used with any of the [Clojure CLI execution options that run with either clojure.main or clojure.exec](https://practical.li/blog-staging/posts/clojure-which-execution-option-to-use/).

Aliases provide a simple way to optionally include community libraries and tools for working with Clojure projects (e.g test runner, built tools, etc.).  Community tools can be added to each Clojure project `deps.edn` configuration, or preferably to a user level `deps.edn` file for use with any Clojure project (easier to maintain as there is a central alias)

Understanding what an alias is and how to define them ensures an effective use of Clojure CLI and a smooth workflow.

> Article updated 26th November 2022

[practicalli/clojure-deps-edn](https://github.com/practicalli/clojure-deps-edn) a quick way to add [many community tools](https://practical.li/clojure/clojure-tools/install/community-tools-available.html) on top of Clojure CLI tools.  Practicalli also has [tips for creating well designed aliases](https://practical.li/blog-staging/posts/clojure-cli-aliases-deserve-designing-too/)

<!-- more -->

## The deps.edn configuration file

A `deps.edn` configuration file is a hash-map with several top level keywords.  All the keywords are optional and the Clojure CLI install defines the `src` code path, `org.clojure/clojure` library dependency with Maven Central & Clojars.org as repository sources.

* `:paths` - code directories included by default as a vector of directory names, `["src" "resources"]`
* `:deps` - library dependencies included by default as a map  ([practicalli/banking-on-clojure example](https://github.com/practicalli/banking-on-clojure-webapp/blob/live/deps.edn#L4-L19))
* `:mvn/repos` - a map of [repositories to download Maven dependencies](https://github.com/practicalli/clojure-deps-edn#library-hosting-services), Maven Central and Clojars included by default
* `:mvn/local-repo` to [specify an alternative location for the Maven cache](https://github.com/practicalli/clojure-deps-edn#maven-local-repository)
* `:aliases` - a map of optional libraries and tools, the key being the alias name and its value the configuration ([practicalli/clojure-deps-edn examples](https://github.com/practicalli/clojure-deps-edn/blob/live/deps.edn#L42))

Configuration can be defined in a `deps.edn` file in the root of a Clojure project, applying only to that specific project.

A user level `deps.edn` configuration can be used in any Clojure project and the `deps.edn` configuration file resides in either `$XDG_CONFIG_HOME/clojure` or `$HOME/.clojure`.


## What is an alias?

An alias is a way to add optional libraries, code paths or Clojure execution options (clojure.main, clojure.exec) when running Clojure CLI.

An alias name is a keyword in Clojure, e.g. `:env/test`, so the `:` is part of the alias name.

As aliases are optional, they provide a way to add libraries and tools that are only needed for development and testing of Clojure projects.  For example, adding the `test` and `dev` directories to the Classpath, or test runners such as Kaocha.

The configuration keys that can be used to define an alias are:

* `:extra-paths` - a vector of directory names added to the project class path, e.g. `["env/dev" "env/test"]`
* `:extra-deps` - a map of additional library dependencies, as a Maven library or Git repository
* `:main-opts` - a vector of command line options passed to `clojure.main`
* `:exec-fn` - the fully qualified name of a function to be run by `clojure.exec`
* `:exec-args` - default arguments passed to the function, over-ridden by matching argument keys specified on the command line

> `:replace-paths` and `:replace-deps` are used to only include specific directories and dependencies. excluding the project dependencies from the class path. Community tools that use these directives should consider adopting the tool `-T` flag approach.
>  Using `:paths` and `:deps` keys in an alias are short-hand for their `replace-*` keywords (Practicalli finds this very confusing, so prefers the explicit names for greater clarity)


## A simple project deps.edn configuration

A new Clojure project can be made by creating a `deps.edn` file and respective `src` & `test` directory trees.

A project `deps.edn` file typically contains `:path`, `:deps` and `:aliases` sections, although `deps.edn` could start with a simple `{}` empty hash-map.

```clojure
{:paths ["src" "resources"]
 :deps
 {org.clojure/clojure {:mvn/version "1.11.1"}}
 :aliases
 {:env/test {:extra-paths ["test"]}}}
```

> The `test` path and associated libraries are added as an alias as they are not required when packaging or running a Clojure application.  `:path` and `:deps` keys are always included by default, `:aliases` are optional and only included when specified with the `clojure` command, e.g. `clojure -M:env/test`


## Creating projects deps.edn from templates

[clj-new](https://github.com/seancorfield/clj-new) provides a convenient way to create a project from a wide range of templates.  [deps-new](https://github.com/seancorfield/deps-new) is a newer project with a simpler template system to help create your own templates (although fewer community templates provided as yet).

The `:project/new` alias in [practicalli/clojure-deps-edn configuration](https://github.com/practicalli/clojure-deps-edn) contains a configuration for clj-new.

In a terminal, create the project called `practicalli/simple-api-server`

```shell
clojure -X:project/new :template app :name practicalli/simple-api
```

This creates a Clojure namespace called `simple-api` in the `practicalli` domain.  The project contains the `clojure.core`, `test.check` and `test.runner` libraries by default.

The `deps.edn` includes several aliases, some aliases have been adjusted and added from the template defaults to provide greater context.

```clojure
{:paths ["src" "resources"]

 :deps {org.clojure/clojure {:mvn/version "1.10.3"}}

 :aliases
 {
  :project/run
  {:main-opts ["-m" "practicalli.simple-api"]}

  :project/greet
  {:exec-fn practicalli.simple-api-server/greet
   :exec-args {:name "Clojure"}}

  :env/test
  {:extra-paths ["test"]
   :extra-deps {org.clojure/test.check {:mvn/version "1.1.0"}}}

  :test/run
  {:extra-paths ["test"]
   :extra-deps {org.clojure/test.check {:mvn/version "1.1.1"}
                io.github.cognitect-labs/test-runner {:git/tag "v0.5.0" :git/sha "48c3c67"}}
   :main-opts ["-m" "cognitect.test-runner"]
   :exec-fn cognitect.test-runner.api/test}}}
```

* `project/run` runs the Clojure project using clojure.main, so calls the `-main` function of the specified namespace
* `project/greet` runs the fully qualified function `greet` (this could be any specified function in any of the project namespaces)
* `:env/test` includes the `test.check` library and test code files under the `test` path, useful for REPL based test runners like CIDER.
* `:test/run` sets the main namespace for the Cognitect Labs test runner, calling the `-main` function in that namespace that runs all the tests under the directory `test`.  Also provides the `:exec-fn` for running with `-X` clojure.exec

> `:test/run` alias shows an example of using a Git repository as a dependency.  It uses the fully qualified repository name with a specific Git tag and commit :sha (any commit sha or tag in the history can be used).  Clojure CLI tools will clone the repository when this alias is first used.
>
> Update: the clj-new `app` template now uses the build.tools configuration to build and package a Clojure project.


## Alias definition for clojure.main

`:main-opts` specifies the options passed to a clojure.main alias, using the `clojure -M` execution option flag.

The value is a vector containing individual string values that represent each option, i.e. option flag and value.

`-m` is used to define the fully qualified namespace in which `clojure.main` should look for the `-main` function.

The `:main-opts` vector defines arguments that are passed to the `-main` function, the same kind of arguments that would be passed via the command line.

The `"--middleware"` argument adds cider-nrepl middleware to the nREPL server, allowing Cider and other editors complete control over the REPL.  The syntax uses values wrapped in a vector.

The `"-interactive"` argument runs an interactive REPL prompt. A headless process is run without this option.

```clojure
  :repl/cider
  {:extra-deps {nrepl/nrepl                   {:mvn/version "0.9.0"}
                cider/cider-nrepl             {:mvn/version "0.27.4"}}
   :main-opts  ["-m" "nrepl.cmdline"
                "--middleware" "[cider.nrepl/cider-middleware]"
                "-interactive"]}
```

This alias is called using the command `clojure -M:repl/cider`


## Alias definition for clojure.exec

`:exec-fn` specifies the fully qualified name of the function, using the `clojure -X` execution option flag .

`:exec-args` specifies a hash-map of default key/value pairs passed to the `:exec-fn` function.  The defaults can be overriden on the command line with respective key/value pairs.

Arguments can be nested within the `:exec-args` map, especially useful on projects with several component configurations (server, database, logging) and managed by a component system (i.e Integrant)

```clojure
{:aliases
 {:project/run
  {:exec-fn practicalli.service/start
   :exec-args {:http/server {:port 8080
                             :join? fale}
               :log/mulog :elastic-search}}}}
```

To run with the default arguments:

```
clojure -X:project/run
```

Over-ride the default arguments by passing them on the command line

```bash
clojure -X:project/run '[:http/server :port]' 8888 :log/mulog :console :profile :dev
```

In this command the vector defines the path to the `:port` key and over-rides the default value. :log/mulog is a top-level key which changes the log publisher type.  `:profile` is another top-level key that sets the environment to `:dev` (e.g. to configure Integrant / Aero).

Arguments in a nested map within the alias can be traversed (as with `get-in` and `update-in` functions) to override the default values in the alias.  So to set a different port value :

Argument keys should either be a top-level key or a vector of keys to refer to a key in a nested hash-map of arguments.

> An alias can contain configuration to run both `clojure.main` and `clojure.exec` (useful if steadily migrating users from -M to -X approach without breaking the user experience)


### Form of clojure.exec command line arguments

Key/value pairs are read as EDN (extensible data notation that is the base syntax of Clojure).

The command line shell needs a little help parsing

Arguments that are vectors and hash maps should be wrapped in single quotes to avoid the command line shell splitting arguments at spaces, e.g. `'[:a :b]'`, `'{:c 1}'`.

The double quotes in an EDN string must be wrapped by single quotes, along with vectors and hash-maps

Number values and keywords should not need to be wrapped.

* `'"strings in double quotes surround by single quotes"'`
* `:key `[:service :port]` 9999`
* `:config '{:log :console}'`


## User wide alias examples

[practicalli/clojure-deps-edn](https://github.com/practicalli/clojure-deps-edn) contains numerous examples of user wide aliases that can be used across projects, especially [common community tools](https://practical.li/clojure/clojure-tools/install/community-tools-available.html).

The `:test/watch` alias adds Kaocha test runner in watch mode.

Using `clojure -M:test/watch` uses `clojure.main` to run Kaocha, passing in the `:main-opts` arguments.

Using `clojure -X:test/watch` uses `clojure.exec` to run the `exec-fn` function, passing the `exec-args` arguments.

```clojure
:aliases
{
  :test/watch
  {:extra-paths ["test"]
   :extra-deps {lambdaisland/kaocha {:mvn/version "1.60.945"}}
   :main-opts   ["-m" "kaocha.runner" "--watch" "--no-randomize" "--fail-fast"]
   :exec-fn kaocha.runner/exec-fn
   :exec-args {:watch? true
               :randomize? false
               :fail-fast? true}}
}
```

> NOTE: Configuration for both -M and -X approaches is not required, but both are often provided for convenience.
> Community tools such as Kaocha have the opportunity to migrate to the `-T` tools approach.  Read more about [which execution option flag to use for Clojure CLI aliases](/posts/clojure-which-execution-option-to-use/)

Further examples of aliases can be found in [practicalli/clojure-deps-edn configuration](https://github.com/practicalli/clojure-deps-edn) which contains configurations for over 30 community tools.


## Summary

You should have a better understanding of how to create aliases and what the individual keys in an alias configuration mean.

Practicalli also has [tips for creating well designed aliases](https://practical.li/blog-staging/posts/clojure-cli-aliases-deserve-designing-too/)

See the next article in the series on [using the most appropriate flags for Clojure CLI aliases](/posts/clojure-which-execution-option-to-use/)

Thank you

[Practicalli](https://practical.li/) | [@Practical_li](https://twitter.com/practical_li)
