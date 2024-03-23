{:title "Desirable features of a Clojure Editor"
:layout :post
:date "2023-09-19"
:topic "clojure"
:tags  ["editor" "clojure"]}

Clojure development benefits from great tooling, typically focused around an editor (or IDE).  There are a number of great editors to choose from that support Clojure.

Practicalli uses many features of a Clojure aware editor with a bias towards highly effective interaction with the REPL, user actions driven exclusively via the keyboard and an uncluttered user interface.

Practicalli Clojure provides [an overview of Clojure editors](https://practicalli/clojure/clojure-editors/) and the plugins that provide Clojure support, e.g. Emacs, Neovim, VS Code, Pulsar and Sublime.  

Emacs (Spacemacs or Doom) & CIDER provides all the desirably functionality alone, although Portal provides additional views to further support inspecting data.

Neovim & Conjure or VSpaceCode & Calva provide the desirably functionality too, although require Portal and other tools for some functionality. 

<!-- more -->

## REPL connnection

Interaction with the REPL is the foundation of all Clojure development, so connecting the Editor to the REPL process is a fundamental feature

* connect to an existing REPL process via nREPL (optionally socket repl - maybe prepl in future)
* start a new REPL process (Clojure CLI, Leiningen)

> Starting the REPL process outside of the editor provides a useful separation of editor and REPL, also allows for a range of editors and other tooling to share the REPL state 

Practicalli typically starts the REPL process in a terminal, specifying Clojure CLI aliases to configure paths and dependencies to load libraries and toos to support development.

Practicalli uses a terminal UI REPL prompt for longer running processes, e.g. starting components such as web servers.


## Customise REPL starup

Clojure development workflows and tools may vary across projects, so customising the REPL starup is highly valuable.

- use of Clojure CLI aliases from project and user level deps.edn to support different configurations and tools when starting the REPL process

The `user` namespace is always loaded during REPL startup, allowing tools and libraries to be included via the `user.clj` file when on the class path.

The `:dev/env` and `:repl/reloaded` aliases from [Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) add the `dev` directory to the class path, loading a custom `user` namespace defined in `dev/user.clj`.  

A custom `user` namespace supports the [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/), launching Portal data inspector listening to all evaluation results and Mulog Tap Publisher sending log events to Portal.

> Calva jack-in requires a JSON mapping to use Clojure CLI user aliases, so Practicalli recommends starting the REPL process in a terminal with the desired aliases and using Calva connect


## Evaluate Clojure

Evaluates expressions as they are written, providing qualative feedback on the expected behaviour.

Expressions are evaluated in Source code window with results inline, keeping focus on the code and avoiding the need to switch namespaces in the REPL.  Larger data structures can be sent to a data inspector (Portal, Cider Inspector)

- evaluate a namespace to load all expressions the current namespace and required namespaces, except expressions in `comment` form or `#_`
- evaluate a top-level expression or nested expression (e.g. eval last s-expression)
- option to eval expression within `(comment ...)` and after `#_`

Evaluation to investigate the behaviour of the code

- pretty print the evaluation result or sent to an inspector, i.e. to navigate more interesting data structures
- print evaluation as a comment, preferably with a pretty print option, to demonstrate aspects of a function or support software archaeology
- replace expression with result of evaluation to better understand that part of the code
- macro-expand expression to see what code the macro produces

Cleaning up the REPL state 

- Un-evaluate a var to avoid running stale code and tests, e.g. remove def, defn, deftest names from the REPL process


## Maintain REPL State 

A Clojure REPL can be very long lived thanks to the stability of the Java Virtual Machine (JVM).  Removing state vars can help avoid a REPL restart, as tools that refresh namespaces and start/stop/restart a Clojure system components.

- refresh changed namespaces of the project in the REPL process, optionally with hook to restart components

For simpler applications, Practicalli loads `clojure.tools.namespace.repl` at REPL starup via a custom `user` namespace to `refresh` stale namespaces in the project and `set-refresh-dirs` to define the directory paths that should be checked for changes (excluding `dev` from the path to avoid reloading tools).

For web services and clojure projects composed of system components, the [Practicalli Service REPL workflow](https://practical.li/clojure-web-services/service-repl-workflow/) is used. The Service REPL workflow uses either [donut-party/system](https://practical.li/clojure-web-services/service-repl-workflow/donut-system/) or [Integrant & Integrant REPL](https://practical.li/clojure-web-services/service-repl-workflow/integrant/) to manage restarting of component and also reloading changed namespaces into the REPL state.


## Inspecting / Navigating Data

Many results of evaluating Clojure produce interesting and potentially complex data structures.  Tools for navigating data aid in the understanding of results produced by Clojure code.

Being able to present the results in different ways can add greater meaning and easier consumption of the results, e.g. visual charts to support data science.

- navigate data, especially nested data
- paginate through large data sets without slowing down the tooling 
- inspect results of an evaluation and follow updates after each evaluation

Emacs Cider Inspector is very powerful for paging through large data sets effectively and navigating a complex structure.

Portal can also navigate data and can show data in a range of views to add more meaning support, e.g. http responses for API development, tables & charts for data science, etc...

Practicalli configures Portal to listen over nREPL to all Clojure code evaluations, which will work with all of the Clojure editors.


## Creating projects

Creating a  a clojure project from templates can save time and provide a consistent base for an organisation.  Extending project templates with options allows for diversity whist still providing common a approach.

Projects from template are typically created via a shell command, so an editor with shell support is valuable.

[Practicalli Project Templates](https://practical.li/clojure/clojure-cli/projects/templates/practicalli/) simplifies Clojure project creation with a growing number of templates, derived from commercial and community experiences.

> [emacs-clj-deps-new package](https://github.com/jpe90/emacs-clj-deps-new) adds project creation to Emacs using clj-new and deps-new projects



#### Debugging tools
* instrument function(s) with break points
* step through functions
* display / inspect local values
* step over calls  

#### Code manipulation features
* Vim style editing (a bias of mine, but definitely worth having)
* Structural Editing (smartparents, paredit - manually driven approach)
* Refactor code (rename, add requires, extract to function / let, 
* Multi-replacement (e.g. Emacs iedit)
  * select all matches in scope, jump between matches, toggle matches and simultaneously edit them
* Narrowing (e.g Emacs narrowing) - view over part of a file, limiting scope of changes
* Multiple cursors

#### Unit Testing
* Support REPL based test runner (e.g. cider-test)
* Support externally running test runner (e.g. kaocha)
* Enable watch for changes to trigger re-run of tests
* Run all tests / namespace tests / single test / only failing test
* support test selectors to run group of tests
* easy to understand test reports 

#### Code archaeology features
* Incoming / outgoing call stack
* Navigate to definition (project, dependency and Java sources where relevant)
* Indicate uses (e.g. number of functions calling a function)
* Indicate unit tests (optional)
* Navigate to errors 

#### Live collaboration
* sharing live code view (Vs code live, floor it's, etc.)
  - VS Code Live is excellent and significant code changes could be done in a separate editor if vscode/calva unfamiliar 

#### General features

* Git client (ideally as rich as Emacs Magit or VS Code edamagit)
* Option to use 100% Keyboard driven interaction (mouse-less operation of tooling) 
* vim-style multi-modal editing
* Clojure LSP support (ideally with easily customisable client lsp UI elements)




Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
