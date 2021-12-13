{:title "Clojure CLI tools - which execution option to use"
 :layout :post
 :date "2021-12-20"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps"]}

Clojure CLI tools provide a very flexible way to run Clojure, using aliases to include community libraries and tools to enhance clojure projects and provide independent tools. Understand the execution options (exec-opts) on the command line options ensures an effective use of Clojure CLI tools.

Clojure CLI tools was [first released in February 2020](https://clojure.org/releases/tools#v1.10.1.510) with a specific focus on running Clojure code quickly and easily, which also required the management of dependencies from Maven, Git and a local file space.

Since that release the design has evolved to provide clojure.exec (`-X`) to run any Clojure function not just `-main` as with clojure.main (`-M`). In July 2021, the ability to run tools (`-T`) which are independent from the Clojure project classpath was also introduced.

The exec-opts command line flags have evolved to enable these features, so lets explore those flags and show how each flag is typically used.

<!-- more -->

## Summary of use

In very simple terms, the Clojure CLI tools flags are used as follows

`-A` - [Deprecated] use `-M` instead

`-M` for running the `-main` function of the current project, using the `-m` flag to specify the namespace containing `-main`

`-X` for running any fully qualified function from the current project

`-P` a dry run, downloading all dependencies

`-T` running a separate tool

> The tools flag, `-T` removes the need for other aliases to run tools and eventually all community tools should move to use the -T approach.  However, some tools still need to be run using the `-M` or `-X` flag (as the `-T` flag is quite new).


## clojure.main -M

[`clojure.main` namespace](https://clojure.org/reference/repl_and_main) has been the way Clojure code was run (including a REPL) for most of its history.  This is now evolving with the addition of [clojure.exec](#clojure-exec--X).

`clojure.main/main` function looks for a `-main` function in the given namespace (`-m fully-qualified.namespace`) or if no main namespace is found then a REPL session is run.  This is the approach Leiningen has always used and still uses today.

Running a project using Clojure CLI tools without any additional aliases on the command line

```bash
clojure -M -m practicalli.sudoku-solver
```

`-M` flag instructs Clojure CLI tools to use `clojure.main` to run the Clojure code.

`-m` flag is an argument to `clojure.main` which specifies the namespace to search for a `-main` function.

The same approach is taken when including an alias, in this example `:alias/name`.

```bash
clojure -M:alias/name -m practicalli.sudoku-solver
```

This command will merge values defined in the alias for `:extra-paths` and `extra-deps` into the call.

> When the command line includes the `-m` flag with a namespace it will over-ride the `:main-opts` value if defined in the alias


Adding a `:project/run` alias to the project `deps.edn` file provides a simpler way to run the project on the command line

```clojure
  :project/run
  {:main-opts ["-m" "practicalli.sudoku-solver"]}

```

Now the project code can be run using the simple command line form

```bash
clojure -M:project/run
```


### Chaining aliases together

Alises can be used together by chaining their names on the command line

```bash
clojure -M:env/dev:env/test:lib/cider:repl/rebel
```

Using several aliases on the command line will merge their `:extra-paths` and `:extra-deps` values.

The `:main-opts` values are not merged and the value from the last `:main-opts` in the alias chain is used with `clojure.main`

Again, if the command line includes the `-m` flag with a namespace, then that namespace is passed to `clojure.main`, ignoring the values from the aliases.

> Aliases can be chained together to merge their configuration, e.g. `clojure -M:env/dev:repl/rebel` will included the configuration from both `:env/dev` and `:repl/rebel`.  With the `-M` flag, only the `:main-opts` from the last alias in the chain is used.  If `-m namespace/name` is also part of the command, this will be used instead of any values from alias `:main-opts` keys.


## clojure.exec -X

`-X` flag provides the flexibility to call any fully qualified function, so Clojure code is no longer tied to `-main`



Arguments are passed as EDN key value pairs and can therefore be included in any order

> The namesapce of the function to be called is automatically loaded using `requiring-resolve!` (TODO: explanation)

Thus you can now define programs as functions that take a map and execute them via clj:

Call the `status` function from the namespace `practicalli.service` in the current project

```bash
clojure -X practicalli.service/status
```

Pass arguments to a `start` function in the `practicalli.service` namespace

```bash
clojure -X practicalli.service/status :port 8080 :join? false
```

As the arguments are key/value pairs, it does not matter in which order the pairs are used in the command line.

### Built in clojure.exec functions
Clojure CLI tools has some built in tools under the special `:deps` alias (not to be confused with the `:deps` configuration in a `deps.edn` file)

* `-X:deps mvn-install` - install a maven jar to the local repository cache
* `-X:deps git-resolve-tags` - Resolve git coord tags to shas and update deps.edn
* `-X:deps find-versions` - Find available versions of a library
* `-X:deps prep` - [prepare source code libraries](https://clojure.org/reference/deps_and_cli#prep) in the dependency tree

> See `clojure --help` for other descriptions and examples (or just read this article further)


## Tools -T

Install, run and remove a tool that can be used independently from a Clojure project configuration.

The `-T` flag is based on the `clojure.exec` approach, except it only uses the `:extra-deps` and `:extra-path` from the alias, ignoring the `:deps` and `:path` values from the project `deps.edn` file.

`-Ttools` is a built in tool for `install` and `remove` of other tools.

The  `:as` directive specifying a name for the too
l

In this example, the antq tool is installed using the name `libs-outdated`

```bash
clojure -Ttools install com.github.liquidz/antq '{:git/tag "1.3.1"}' :as libs-outdated
```

To update a tool, simply run the install again with the latest version of the library or git reference.

Installing a tool adds an EDN configuration file using the name of the tool in `$HOME/.clojure/tools/` (or $XDG_HOME/.clojure/tools/) directory.

Once a tool is installed, run by using the name of the tool.

```bash
clojure -Tlibs-outdated
```

Options to the tool are passed as key/value pairs (as the tool is called by clojure.exec)

```bash
clojure -Tlibs-outdated :upgrade true
```

`-Ttools remove` will remove the configuration of the tool of the given name

```bash
clojure -Ttools remove :tool libs-outdated
```


> Minimise installs between computers by placing the `.clojure/tools` directory in version control. It would be great to have antq also update tools aliases to their latest versions as it does with other aliases (assuming this doesnt already happen).


Example tools include

* [liquidz/antq](https://github.com/liquidz/antq) - search dependencies for newer library versions
* [seancorfield/deps-new](https://github.com/seancorfield/deps-new) - create new projects using templates


## Prepare -P

`-P` flag instructs the `clojure` command to download all library dependencies to the local cache and then stop without executing a function call.

The `-P` flag is often used with Continuous Integration workflows and to create pre-populated Container images, to avoid repeatedly downloading the same library jar files.

If used with just a project, then the Maven dependencies defined in the project `deps.edn` file will be downloaded, if not already in the users local cache (`~/.m2/repository/`).

If `:git` or `:local/root` dependencies are defined, the respective code will be downloaded and added to the classpath.

Prepare flag by itself download dependencies defined in the `:deps` section of the `deps.edn` file of the current project.

```bash
clojure -P
```

Including one or more aliases will preparing all the dependencies from every alias specified

```bash
clojure -M:project/hotload:env/dev:lib/cider -P
```

As prepare is essentially a dry run, then the `clojure` command does not call `:main-opts` or `:exec-fn` functions, even if they exist in an alias or on the command line.

> `-P` will warn if a project has dependencies that [require building from source](https://clojure.org/reference/deps_and_cli#prep) (i.e Java code) or resource file manipulation.  If so then `clojure -X:deps prep` will prepare these source based dependencies.

## Summary

There are many options when it comes to running Clojure CLI tools that are not covered here, however, this guide gives you the most common options used.

The `-J` and `:jvm-opts` are useful to configure the Java Virtual machine and deserve an article to themselves as there are many possible options.

See the [Deps and CLI Reference Rationale for more details and description of these options](https://clojure.org/reference/deps_and_cli#prep).


## References

* [Inside Clojure - clj exec](https://insideclojure.org/2020/07/28/clj-exec/)
* [Inside Clojure - clj exec update](https://insideclojure.org/2020/09/04/clj-exec/)
