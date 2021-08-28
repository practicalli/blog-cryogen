{:title "Clojure REPL - tips to avoid restarting the REPL"
 :layout :post
 :draft? true
 :date "2022-01-06"
 :topic "repl"
 :tags  ["clojure-cli" "tools-deps"]}

A REPL is not just for the moment, it can run for many days, weeks or months.  If you find you are regularly restarting the Clojure REPL then try the following tips to enhance your REPL workflow and minimise the need to restart the REPL.

The startup time for a REPL is usually insignificant, however, it can be valuable to maintain the state of the REPL during development, especially when developing specific states in the application.

 <!-- more -->

## Run an external REPL
Run the REPL process independently of your editor (connect rather than jack-in) is the easiest way to provide a long running REPL project. The REPL process will continue if the editor is closed or crashes.

The configuration of an external REPL can be configured to support additional tools (data inspectors & visualization) and a range of external connects and editor dependencies (nREPL, cider-nrepl, etc).

> #### Hint::Using a shared REPL for Collaboration
> Using a shared REPL model (i.e. running a REPL on a remote server) developers can pair / mob using their own editor configuration, ensuring the focus stays on the code rather than learning different tools.

> See the draft post: connect vs jack-in

## Evaluate the source code
Using cleanly structured namespaces and evaluating in source code files minimizes stale definitions in the REPL state.

Whilst it can be convenient at times to fire up and hack code directly in a REPL, it is more prone to stale definitions and less amenable to creating a record of the stable source code.

If the REPL state diverges from the source code, there becomes more reason to restart the REPL or at least clean whole the REPL state.

* [Stuart Halloway on Repl Driven Development](https://vimeo.com/223309989) – Chicago Clojure 2017-06-21


## Undefine vars before changes
Before you change vars (i.e. def, defn, deftest names) undefine them

Regardless of tools used to refactor, take a moment to undefine the var names that will change, before making the change.

The cloure.core/unmap function can remove a var definition from a specific namespace.  Use `*ns*` dynamic var to refer to the current namespace.

```clojure
(ns-unmap *ns* 'var-name)
```
Use `ns-map` to get a list of all the functions and use `map` to iterate over those names and unmap them.

Cider has `cider-undef` command that will remove a var name from the running REPL.


## Separate code experiments from design choices
REPL experiments can be useful to form living documentation on how a design evolved, something that is often hard to understand from looking at a completed design.

REPL experiments can also show other design options and include examples showing why they were not chosen.

Keeping a record of design options can minimise time spent on designs not taken, or act as a reminter of other designs should there be unresolvable challenges with the current designs.

A design journal can also be used to minimise the time to onboard developers to the project, as it helps demonstrate the thinking processes that were previously taken.

Creating a design-journal namespace for experiments creates a clean separation between code baded on a desgin choice and experimental code that helps form decisions

Use rich comment blocks in design-journal namepace to allow the same var names to be used during the design so the REPL is not polluted with stale vars (and there are fewer vars to undefine)

Rich comment block with clj-kondo ignoring duplicate var names

```
#_{:clj-kondo/ignore [:redefined-var]}
(comment

  ) ;; End of rich comment block
```

Important concepts and interactions with a namespace can also be added to a rich comment block in each namespace, usually at the bottom of that namespace.  This code is only run manually by the developer, so does not interfere with the live code.


> Place a `,` before the closing paren, `)` of a rich comment block to prevent parinfer moving the paren to the closing paren of the expression above.  This keeps evaluation of the last expression in the rich comment simple.


## REPL friendly code
https://clojure.org/guides/repl/enhancing_your_repl_workflow#writing-repl-friendly-programs

Define state related vars using `defonce` to avoid resting state in the REPL


## Reloadable code

TODO: Reloaded workflow

tools.namespace to reload namespaces in the right order


## Restarting components


Component provides an easily start & stop processes and applications in the REPL as needed – and continue to evaluate new code into the live, running application while we work.


## hotload
should this be included?

tools.alpha...


## Live patching
should this be included?  maybe a separate blog?

Use drawbridge or a secure ssh tunnel to a live system to

Using socket server / unrepl / nrepl


## any other tips


Thank you.
[@practical_li](https://twitter.com/practical_li)



> vim-fireplace you can push long-running evaluation into background with ctrl+d, making it finish asynchronously





# Designing with the Clojure REPL
Content for a separate article


## Managing state in the REPL
such as let bindings or other local vars?

## Evaluating code
Evacuating top level expressions as they are defined

writing individual expressions and evaluating them

in the design journal I start with the simplest expressons and start composing them together to represent algorithms and transformations required.

Using let bindings is a simple way to include values that are used more than once within an algorithm.  As the let is self-contained (i.e. does not require values to be passed) it is usually simpler to evaluate fragments of the overall algorithm, specific expressions and values within the let to see what they do.

Use def expressions to define values shared between algorithms (functions)

Using threading macros, especially for larger transformations.  The `#_` comment dispatch macro can be used to temporarily remove expressions from the threaded macro, which can help diagnose issues.

When starting with an established project, especially a project of any size, I'll evaluate the main namespace of the project, which should also load the required namespace the main namespace uses.  As the main namespace is usually the first node in a tree of namespaces, then all source code namespaces in the project should be loaded when evaluating the whole main namespace.


### What drives the test code
Experiments in rich code blocks and design-journal namespaces are effective ways to start discovering important data concepts and transformations required.

Once some design options around the shape of the data and associated behaviour start to form, they can be codified into unit tests.  In this way the unit tests become snapshots of a design choice eluded from working with realistic data.

This approach can minimise refactoring of tests as some experience of working within the domain has been gathered.
