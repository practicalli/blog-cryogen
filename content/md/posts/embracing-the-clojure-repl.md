{:title "Embracing the Clojure REPL"
:layout :post
:date "2022-02-17"
:topic "practicalli"
:tags  ["practicalli"]}


The Clojure REPL runs Clojure code in production and during development.  The REPL is always present, the only difference being the REPL typically runs headless in production and interactively during development.

Programming languages may have interactive shells, but only LISP languages have a REPL as the central runtime for the language.

With a REPL, rather than compile the whole source code each time in a separate step, compiling Clojure happens when selecting a single expression (or namespace of expressions) to evaluate.  So compiling is effectively hidden from view.  Evaluating code as its written becomes as natural as saving code to a file when changes happen.

Developing Clojure without the REPL only provides a small understanding of the benefits available from the language and tooling.

<!-- more -->

## Evaluating code as its written

Clojure code can be read, evaluated and results printed in the REPL as soon as its typed, ideally in correctly written expressions (forms).  This can be done in a REPL user interface, although realistically this is done from a REPL connected editor.

Expressions that call existing functions can be called, `(,,,)`.  Expressions that define names for data `(def ,,,)`.  Expressions that define behaviour `(defn ,,,)

![Clojure REPL - evaluate code as its typed](https://raw.githubusercontent.com/jr0cket/developer-guides/master/clojure/clojure-repl-driven-development-clojure-aware-editor.png)

## Spikes and REPL based design

The REPL is an ideal tool for experimenting with data models and algorithms, providing instant feedback at each increment of the design experiments.

This approach can be a spike to evolve a specific aspect of the design, or it can simply be part of the Clojure development workflow.

![Clojure REPL Driven Development](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/clojure-repl-driven-development-lifecycle-concept.png)


## Capture the design journey

Whilst correctly running code is the desired overall outcome, code is really a bi-product of many software engineering aspects.

Understanding and effective communication of that understanding is essential aspect. Without understanding it is very hard to continue development or even maintain the current system without considerable extra effort.

Rich comments are an effective means of creating living documentation within the code base itself.  Developers can evaluate specific expressions within the `comment` expression and instantly see the return value.

```clojure
(comment
  ;; expressions that show evolution of design and choices not taken
)
```


## Rich Comment blocks - living documentation

The `(comment ,,,)` function is used to included code that is only run by the developer directly.  Unlike `;;` comments, expressions inside a comment block can be evaluated using a [Clojure aware editor](/clojure-editors/).

Expressions in rich comment blocks can represent how to use the functions that make up the namespace API.  For example, starting/restarting the system, updating the database, etc.  Expressions provide examples of calling functions with typical arguments and make a project more accessible and easier to work with.

![Practicalli Clojure Repl Driven Development - Rich comment blocks example](/images/practicalli-clojure-repl-driven-development-rich-comment-blocks.png)

Rich comment blocks are very useful for rapidly iterating over different design decisions by including the same function but with different implementations.  Hide [clj-kondo linter](/clojure-cli/install/install-clojure.html#clj-kondo-static-analyser--linter) warnings for redefined vars (`def`, `defn`) when using this approach.

```clojure
;; Rich comment block with redefined vars ignored
#_{:clj-kondo/ignore [:redefined-var]}
(comment
  (defn value-added-tax []
    ;; algorithm design - first try)

  (defn value-added-tax []
    ;; algorithm design - first try)

  ) ;; End of rich comment block
```

> The "Rich" in rich comments is also used as a tribute to Rich Hickey, the author and benevolent dictator of Clojure.


## Design Journal

Creating a journal of the decisions made as code is designed makes the project easier to understand and maintain.  Journals avoid the need for long hand-over or painful developer on-boarding processes as the journey through design decisions are already documented.

A design journal can be added as a `(comment ,,,)` section at the bottom of each namespace, or more typically in its own namespace.

A journal should cover the following aspects

* Relevant expressions use to test assumptions about design options.
* Examples of design choices not taken and discussions why (saves repeating the same design discussions)
* Expressions that can be evaluated to explain how a function or parts of a function work

The design journal can be used to create meaningful documentation for the project very easily and should prevent time spent on repeating the same conversations.

> #### HINT::Add example journal
> [Design journal for TicTacToe game using Reagent, ClojureScript and Scalable Vector Graphics](https://github.com/jr0cket/tictactoe-reagent/blob/master/src/tictactoe_reagent/core.cljs#L124)


## Viewing data structures
Pretty Print show results of function calls in a human-friendly form. When results are data structures, pretty print makes it easier for a developer to parse and more likely to notice incorrect results.

[Clojure Data Browsers](/clojure-cli/data-browsers/reveal.md) ([cider-inspect](/clojure-cli/data-browsers/clojure-inspector.md), [Reveal](/clojure-cli/data-browsers/reveal.md), [Portal](/clojure-cli/data-browsers/portal.md)) provide effective ways to navigate through a nested data structures and large data sets.

![Clojure - viewing large data sets](/images/spacemacs-clojure-inspect-java-lang-persistent-vector.png)


## Code Style and idiomatic Clojure
Clojure aware editors should automatically apply formatting that follows the [Clojure Style guide](https://github.com/bbatsov/clojure-style-guide).  For example, line comments as `;;`, 2 space indents and aligning forms.

Live linting with [clj-kondo](https://github.com/borkdude/clj-kondo) highlights a wide range of syntax errors as code is written, minimizing bugs and therefore speeding up the development process.

![clj-kondo static analysis for live linting of Clojure code](/images/spacemacs-clojure-linting-code-marks-and-flycheck-list-errors.png)


## Test Driven Development and REPL Driven Development
Test Driven Development (TDD) and REPL Driven Development (RDD) complement each other as they both encourage incremental changes and continuous feedback.

RDD supports rapid design with different approaches easily explored and evaluated. Unit tests focus the results of those experiments to guide delivery of the correct outcomes. Tests also provide critical feedback when changes break that design.

![Clojure REPL driven development (RDD) and Test Driven Development (TDD)](https://raw.githubusercontent.com/practicalli/graphic-design/live/repl-tdd-flow.png)

[Unit tests](/testing/unit-testing/) should support the public API of each namespace in a project to help prevent regressions in the code.  Its far more efficient in terms of thinking time to define unit tests as the design starts to stabilize than as an after thought.

`clojure.test` library is part of the Clojure standard library that provides a simple way to start writing unit tests.

[Clojure spec](/clojure-spec/) can also be used for generative testing, providing far greater scope in values used when running unit tests.  Specifications can be defined for values and functions.

Clojure has a number of [test runners](/testing/test-runners/) available.  Kaocha is a test runner that will run unit tests and function specification checks.






## Summary

REPL driven development is central to the [Practicalli books and videos](https://practical.li/) and used in all the code examples and tutorials

Other useful resources include:

* [Clojure Design Club episode 14 discusses fiddle with the REPL](https://clojuredesign.club/episode/014-fiddle-with-the-repl/), which is exactly the same concept as the rich comments approach.

* [Running With Scissors: Live Coding With Data presentation from Strangeloop by Stuart Halloway](https://youtu.be/Qx0-pViyIDU) is a deep dive into using the Clojure REPL that covers this concept amongst many others.
