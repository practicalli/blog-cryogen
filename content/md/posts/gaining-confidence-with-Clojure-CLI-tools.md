{:title "Gaining confidence with Clojure CLI tools"
 :layout :post
 :date "2019-07-26"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "tools-deps"]}

We are going to try out the different command line options available as we continue our journey into the Clojure CLI tools..

 We explore the different ways to running Clojure code, from a single expression to a full project.  We include examples of aliases for optional configuration and combining aliases to create specific configurations when running a project.  Finally we will see how to diagnose a project and understand potential sources of conflicts.

> Newer content can be found in [Using Clojure tools section of Practicalli Clojure](http://practicalli.github.io/clojure/clojure-tools/using-clojure-tools.html)

Please see earlier articles in thise series for background:

* [A Deeper Understanding of Clojure CLI Tools](http://jr0cket.co.uk/2019/07/a-deeper-understanding-of-Clojure-CLI-tools.html)
* [Getting Started With Clojure CLI Tools](http://jr0cket.co.uk/2019/07/getting-started-with-Clojure-CLI-tools.html)

<!-- more -->


## CLI options - getting help

`clojure -h`, `-?` or `--help` lists the options are available for the Clojure CLI tool. You should see output as follows:


```
clojure --help
Usage: clojure [dep-opt*] [init-opt*] [main-opt] [arg*]
       clj     [dep-opt*] [init-opt*] [main-opt] [arg*]

The clojure script is a runner for Clojure. clj is a wrapper
for interactive repl use. These scripts ultimately construct and
invoke a command-line of the form:

java [java-opt*] -cp classpath clojure.main [init-opt*] [main-opt] [arg*]

The dep-opts are used to build the java-opts and classpath:
 -Jopt          Pass opt through in java_opts, ex: -J-Xmx512m
 -Oalias...     Concatenated jvm option aliases, ex: -O:mem
 -Ralias...     Concatenated resolve-deps aliases, ex: -R:bench:1.9
 -Calias...     Concatenated make-classpath aliases, ex: -C:dev
 -Malias...     Concatenated main option aliases, ex: -M:test
 -Aalias...     Concatenated aliases of any kind, ex: -A:dev:mem
 -Sdeps EDN     Deps data to use as the last deps file to be merged
 -Spath         Compute classpath and echo to stdout only
 -Scp CP        Do NOT compute or cache classpath, use this one instead
 -Srepro        Ignore the ~/.clojure/deps.edn config file
 -Sforce        Force recomputation of the classpath (don't use the cache)
 -Spom          Generate (or update existing) pom.xml with deps and paths
 -Stree         Print dependency tree
 -Sresolve-tags Resolve git coordinate tags to shas and update deps.edn
 -Sverbose      Print important path info to console
 -Sdescribe     Print environment and command parsing info as data

init-opt:
 -i, --init path     Load a file or resource
 -e, --eval string   Eval exprs in string; print non-nil values
         --report target     Report uncaught exception to "file" (default), "stderr", or "none",
                             overrides System property clojure.main.report

main-opt:
 -m, --main ns-name  Call the -main function from namespace w/args
 -r, --repl          Run a repl
 path                Run a script from a file or resource
 -                   Run a script from standard input
 -h, -?, --help      Print this help message and exit

For more info, see:
 https://clojure.org/guides/deps_and_cli
 https://clojure.org/reference/repl_and_main
```


## Running code - the REPL

`clojure --repl`  or `clojure -r` runs a repl, so you can create your application right there in the command line terminal.

```shell
clojure --repl

Clojure 1.10.1
user=>
```

This seems to be the same as the default behaviour when running `clojure`


## Running Code - just an expression
We can just evaluate a Clojure expression using the `--eval string` or `-e` option.  This option takes the expression as a string, so dont forget those double quotes.

```shell
clojure -e "(+ 1 2 3)"

6
```

Calling code this way will print non-nil values.  So if we have an expression that returns nil as a side effect, then that value will not be printed.

```shell
clojure -e "(println (+ 1 2 3))"

6
```

And if an expression only returns nil, then nothing is printed

```shell
clojure -e "(if (= 1 2) true nil)"
```


## Running code - from a project
We saw in the Practicalli study group that you can run a project just by specifying the main namepsace.

Using the project [practicalli/first-cli-app](https://github.com/practicalli/first-cli-app) we can Run the project using the command:

```shell
clojure -m practicalli.first-app
```

The command called the `-main` function defined in `practicalli.first-app` namespce (`src/practicalli/first_app.clj`)




## `-Aalias` - include configuration sections when running `clojure`

Use aliases to define additional configuration sections that will be pulled into the overall configuration, as you call `clojure` on the command line.

From the ### Combining Aliases

As this is Clojure [practicalli/first-cli-app](https://github.com/practicalli/first-cli-app) we have two aliases defined, `:We have already been combining configurations and so its not surprising that we can combine aliases


```clojure
{:paths ["resources" "src"]

 :deps {org.clojure/clojure {:mvn/version "RELEASE"}}

 :aliases {:test {:extra-paths ["test"]
                  :extra-deps {org.clojure/test.check {:mvn/version "RELEASE"}}}

           :runner {:extra-deps
                     {com.cognitect/test-runner
                      {:git/url "https://github.com/cognitect-labs/test-runner"
                       :sha "76568540e7f40268ad2b646110f237a60295fa3c"}}
                    :main-opts ["-m" "cognitect.test-runner" "-d" "test"]}}}
```


`clojure -A:test` will add `test` to the search path and include the `org.clojure/test.check` library.

`clojure -A:runner` will add the `com.congnitect/test-runner` library from GitHub and then run with the `cognitect.test-runner` as the main namespace.  `clojure` will also include configuration from the `test` build configuration.

> The [practicalli/first-cli-app](https://github.com/practicalli/first-cli-app) does not yet define a `dev` build, so no additional configuration is added when using the `-A:runner` alias.


### Combining Aliases

We have already been combining configurations and so its not surprising that we can combine aliases too.

The practicalli/study-group-guide defines several aliases

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

`clojure -A:fig` will include the library for `figwheel-main` library and include the `:extra-paths` of `target`, where JavaScript is generated and `test` for project unit tests.

`clojure -A:fig:build` will do the above and also build the project with figwheel-main, first loading in the `dev` build configuration.

The `dev` build is defined in `dev.cljs.edn` file.

```clojure
^{:watch-dirs ["test" "src"]
  :css-dirs ["resources/public/css"]
  :auto-testing true}
{:main practicalli.study-group-guide}
```


## `-Sdeps` - adding dependencies to deps.edn

The `-Sdeps` option will also add the given dependency to the current projects `deps.edn`

Create a new project directory called packing-code

Create and edit a file called `deps.edn`

Add the following simple configuration


Add a dependency to this file using the Clojure CLI tools


```shell
clojure -Sdeps '{:deps {pack/pack.alpha {:git/url "https://github.com/juxt/pack.alpha.git" :sha "dccf2134bcf03726a9465d2b9997c42e5cd91bff"}}}' -m mach.pack.alpha.inject 'd9023b24c3d589ba6ebc66c5a25c0826ed28ead5'

```

The command should execute without error and if so no output is returned.  So open the `deps.edn` file in the project and check the dependency has been added.

> It does seem easier to simply edit the `deps.edn` file and add project dependencies, especially as the code may need formatting.
> If you are working with a bigger project then using the CLI to add a dependency to an existing `deps.edn` project configuration could be a convenient way to share new dependencies between teams or others who want to use your project, reducing the risk of copy/paste errors or adding different versions.
>
> It could be useful to create a script that populates a project `deps.edn` file with all the same depencencies.  What happens if you try add the same dependency but with different versions?
> Maybe using `clojure - script-to-set-dependencies.sh`



### Error: no `deps.edn` file

if you are not in a project with a `deps.edn` file then the call to `clojure -Sdeps ,,,` will fail with the following error

```shell
Execution error (FileNotFoundException) at java.io.FileInputStream/open0 (FileInputStream.java:-2).
deps.edn (No such file or directory)

Full report at:
/tmp/clojure-3813266914468340055.edn
```

[A gist of the complete error](https://gist.github.com/0e94ed1d772ad6b051a382c8410c3f78) if you are interested


## `-Stree` - adding dependencies to deps.edn

`clojure -Stree` in a project directory will show all the library dependencies you added to the project along with all the depencencies that each of those libraries have.

`-Stree` is a very useful diagnostic tool when you have clashes between dependencies, or more likely the version of dependencies that the libraries you added as dependences have as dependencies (I think that needs a diagram).

In the [practicalli/first-cli-app](https://github.com/practicalli/first-cli-app) we can see that the `org.clojure/clojure` library we added has two libraries as its dependencies.

```shell
clojure -Stree

org.clojure/clojure 1.10.1
  org.clojure/spec.alpha 0.2.176
  org.clojure/core.specs.alpha 0.2.44
```

If we look at [practicalli/study-group-guide](https://github.com/practicalli/study-group-guide) project which uses Clojure, ClojureScript and reagent libraries, the dependency tree is much larger.

```shell
clojure -Stree
org.clojure/clojure 1.10.0
  org.clojure/core.specs.alpha 0.2.44
  org.clojure/spec.alpha 0.2.176
org.clojure/clojurescript 1.10.339
  org.clojure/data.json 0.2.6
  org.clojure/google-closure-library 0.0-20170809-b9c14c6b
    org.clojure/google-closure-library-third-party 0.0-20170809-b9c14c6b
  org.mozilla/rhino 1.7R5
  com.cognitect/transit-clj 0.8.309
    com.cognitect/transit-java 0.8.332
      commons-codec/commons-codec 1.10
      com.fasterxml.jackson.core/jackson-core 2.8.7
      org.msgpack/msgpack 0.6.12
        com.googlecode.json-simple/json-simple 1.1.1
        org.javassist/javassist 3.18.1-GA
  org.clojure/tools.reader 1.3.0-alpha3
  com.google.javascript/closure-compiler-unshaded v20180610
    com.google.errorprone/error_prone_annotations 2.0.18
    com.google.jsinterop/jsinterop-annotations 1.0.0
    com.google.javascript/closure-compiler-externs v20180610
    com.google.guava/guava 22.0
      org.codehaus.mojo/animal-sniffer-annotations 1.14
      com.google.j2objc/j2objc-annotations 1.1
    args4j/args4j 2.33
    com.google.protobuf/protobuf-java 3.0.2
    com.google.code.findbugs/jsr305 3.0.1
    com.google.code.gson/gson 2.7
reagent/reagent 0.8.1
  cljsjs/react-dom 16.3.2-0
  cljsjs/react 16.3.2-0
  cljsjs/react-dom-server 16.3.2-0
  cljsjs/create-react-class y15.6.3-0
```


### Managing dependency clashes

In the figwheel-main project we saw that reagent/reagent library had 4 additional dependencies it relied upon.  If one of those dependencies were causing an issue, we could define an exclusion on the `reagent/reagent` dependency entry

```clojure
{:deps {org.clojure/clojure {:mvn/version "1.10.0"}
        org.clojure/clojurescript {:mvn/version "1.10.339"}
        reagent {:mvn/version "0.8.1"
                 :exclusions [cljsjs/react-dom
                              cljsjs/react-dom-server]}}
```

`clojure -Stree` would now show that `reagent/reagent` only brings in two additional dependencies.


```shell
clojure -Stree

reagent/reagent 0.8.1
  cljsjs/react 16.3.2-0
  cljsjs/create-react-class y15.6.3-0
```


## `-Sresolve-tags` - adding dependencies to deps.edn

TODO: investigate



## `-Sverbose` - Clojure version and paths before running REPL

`clojure -Sverbose` simply shows the version of Clojure and all the paths and files used to run the REPL.  Then it runs a REPL as normal.

```shell
clojure -Sverbose
version      = 1.10.1.447
install_dir  = /usr/local/lib/clojure
config_dir   = /home/jr0cket/.clojure
config_paths = /usr/local/lib/clojure/deps.edn /home/jr0cket/.clojure/deps.edn deps.edn
cache_dir    = .cpcache
cp_file      = .cpcache/1067532457.cp

Clojure 1.10.1
user=>
```

The `config_paths` configuration shows which `deps.edn` files are used to build up the configuration, very useful for debugging missing or incorrect configuration (if its pulling in unexpected files into the configuration).

> Read the [Development Workflow with Clojure CLI tools article](../development-workflow-with-clojure-cli-tools/) for and example of Clojure CLI tools with a figwheel-main project


## `-Sdescribe` - showing the configuration and where it came from

The `-Sdescribe` option provides a simple way to understand where `clojure` is getting its configuration from and what the key parts of that configuration are.

```shell
clojure -Sdescribe

{:version "1.10.1.447"
 :config-files ["/usr/local/lib/clojure/deps.edn" "/home/jr0cket/.clojure/deps.edn" "deps.edn" ]
 :install-dir "/usr/local/lib/clojure"
 :config-dir "/home/jr0cket/.clojure"
 :cache-dir ".cpcache"
 :force false
 :repro false
 :resolve-aliases ""
 :classpath-aliases ""
 :jvm-aliases ""
 :main-aliases ""
 :all-aliases ""}
```


Thank you.
[@practicalli](https://twitter.com/practicalli)
