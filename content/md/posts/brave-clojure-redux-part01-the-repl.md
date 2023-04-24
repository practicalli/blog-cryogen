{:title "Brave Clojure redux - part 1 - the REPL"
 :layout :post
 :date "2021-02-16"
 :topic "learning-clojure"
 :tags  ["clojure-cli"]}

Brave Clojure redux is series that revisits the code examples and tooling covered in the book: "Clojure for the Brave and the True".  The good news is you do not need to be brave or true to read the book or learn Clojure either.  It does help if you have some time and motivation though.

Brave Clojure redux uses Clojure CLI tools rather than Leiningen as used in Brave Clojure.  Code examples will be used from the book, complemented with additional examples where relevant.

Part 1 covers the Clojure REPL process, a vital part of Clojure development. The basics of building and running a project are also included.

Practicalli Clojure covers Clojure CLI tools installation, along with example aliases in `practicalli/clojure-deps-edn`, to provide a wide set of tools to support Clojure development.

A Clojure aware editor is also recommended, which part 2 will cover.

<!-- more -->

## Practicalli Clojure study group

The Practicalli Study guide playlist contains 100+ videos on Clojure and ClojureScript development.  From episode 97 onwards, the the videos are the Brave Clojure Redux series.

<iframe width="560" height="315" src="https://www.youtube.com/embed/li8dRt6JdfQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Coding with the REPL

The REPL is a process that reads Clojure code and returns the results.  Specifically, the REPL Reads the code and ensures its of a good form.  Then it Evaluates the code to return a value.  Then it Prints that value out to the terminal or editor.  Finally it Loops around again if there is more Clojure to read.

The REPL evaluates a single expression at a time, so you can see exactly what a piece of code does and see the result instantaneously.

Clojure development benefits greatly when actively using the REPL to create Clojure code.

> Static analysis tools may be more familiar with other languages (Java, C#, etc.).  and can useful in supporting Clojure development with the REPL.


## Which Clojure development tool?

The Brave Clojure book uses the Leiningen build automation tool for its examples.  Leiningen is a commonly used tool to create an manage Clojure projects for the last decade.

Brave Clojure redux uses the newer Clojure CLI tools which takes a data centric approach to the configuration, using a `deps.edn` file.  As the name suggests, this file uses the Extensible Data Notation (EDN) which the Clojure syntax is written with.  A `deps.edn` file is simply a hash-map that defines your project and the tools used with the project.

> ["A Case for Clojure" by James Reeves](https://www.youtube.com/watch?v=7d53ABMqpqU) covers in detail the EDN foundation of the Clojure language

Clojure CLI tools focuses on dependency management and running Clojure code. Community projects are added as aliases, e.g. [practicalli/clojure-deps.edn](https://github.com/practicalli/clojure-deps-edn), providing a wide range of features as and when they are needed.

Practicalli Clojure has a more in depth [comparison of Clojure CLI tools and Leiningen](http://practicalli.github.io/clojure/alternative-tools/clojure-tools/compare-with-leiningen.html).


## Creating a New Clojure project

[clj-new](https://github.com/seancorfield/clj-new) will create the directory and file structure for a Clojure project, from one of many available templates.

```shell
clojure -X:project/new :template app :name practicalli/brave-clojure-redux
```

This creates a simple project structure with matching `src` and `test` directory trees, with one `*_test.clj` file for each `*_.clj` source file.  The only difference between this project and the example in the Brave Clojure book is the project configuration file, `deps.edn` rather than `project.clj`

`deps.edn` project configuration and contains the paths used in the project, libraries required as dependencies and aliases for tasks and tools to support working with the project.

> Install [practicalli/clojure-deps.edn](https://github.com/practicalli/clojure-deps-edn) for the aliases used in this series.


## Using the REPL

The Clojure REPL can be used without a Clojure project to quickly try out some ideas with Clojure.  Its far more useful to use a Clojure project with a REPL, where code and experiments can be saved to files for later use.

Clojure CLI tools provides the `clojure` command that runs a REPL process and provides a simple terminal user interface.  `clj` is a wrapper that adds history support to the terminal REPL UI.  The Rebel readline project provides a rich terminal REPL UI experience.

Open a terminal window and change to the root of the Clojure project created previously.

Use the `:repl/rebel` alias from [practicalli/clojure-deps-edn](https://github.com/practicalli/clojure-deps-edn) to start a REPL process with the Rebel UI.

```shell
clojure -M:repl/rebel
```

Use the `:repl/rebel-nrepl` alias instead to connect a Clojure aware editor to the REPL process via the nREPL server.

```shell
clojure -M:repl/rebel-nrepl
```


## Running the Clojure project

Using the `app` tempate, the `practicalli/brave_clojure_redux.clj` file contains a definition for a function called `-main`.  You can edit the `println` in this function to return a different string if you wish, such as `"I'm a little teapot!"` from the Brave Clojure book.

Run this function with Clojure CLI tools:

```shell
clojure -M -m practicalli.brave-clojure-redux
```

The `-M` flag tells the Clojure command to use Clojure.main to look for a function called `-main` in the namespace specified by the `-m` flag.


## Building a Clojure project

A Clojure project is packaged into a Java archive file (`.jar`).  This is a zip compressed file with a particular structure and configuration files.

The `app` template used to create the project includes aliases to create jar files in the `deps.edn` configuration file.

- `:jar` packages the project code into a .jar file.  This is used for deploying libraries to a shared repository such as [Maven Central](https://mvnrepository.com/repos/central) and [Clojars](https://clojars.org/), or to a local repository such as [Artifactory](https://jfrog.com/artifactory/)

- `:uberjar` creates a .jar containing the project code and the Clojure runtime environment, so all that is required to run the uberjar is a Java Virtual Machine.

Thank you.
[@practical_li](https://twitter.com/practical_li)
