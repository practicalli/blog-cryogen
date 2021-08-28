{:title "Clojure LSP with Spacemacs develop"
 :layout :post
 :draft? true
 :date "2022-04-16"
 :topic "clojure-lsp"
 :tags  ["clojure-lsp"]}

Microsoft Language Server Protocol is being adopted by editor and tool developers to standardise the features available across all programming languages.


## Install

A clojure-lsp server will be installed if one cannot be found on the executable path.  TODO where is the clojure-lsp binary downloaded to?

Installing the clojure-lsp binary should help you control which version is being used.  There are very regular updates, sometimes daily, so using an external binary helps you manage which version is used.  ASSUMPTION: a new version is downloaded by the package manager when a new version of the package is installed... However, it might not update once its already got one...

Install the clojure-lsp binary on the executable path that Emacs is aware of.  Use `SPC e e` to see the environment variables that Spacemacs is aware of.


## Finding references
Finding where a function definition is called from is the feature I have found most useful so far with LSP.

Joining a new development team has a steep learning curve, especially where there is a lot of existing code to try and understand.  Ideally the code would be easy to work with and functions can be easily evaluated in the REPL with example data (i.e. rich comment blocks).

Finding where in the code a function definition is called can help navigation through the code base, especially where naming of symbols has been less thought out.

Finding references enables more confidence when the code refactor


## Highlight matching symbols
A basic tool to help see where symbols are uses within the buffer.

The same thing can be done with Spacemacs symbolic highlighting which can then also jump between highlighted symbols, as well as a search across the project for that symbol and a

## Changes in Spacemacs

`, g d` to jump to definition instead of `, g g`


## If the code doesnt compile
If you cant run the repl then LSP can be used to help... to a point... perhaps... TODO


## Simplifying tool development
When development tools are simpler to create then everyone benefits, not just those developers building tools.  LSP has the promise of delivering more features to developers with their tooling.

Whether these features are required, I can only share my own experiences and encourage others to do the same.
