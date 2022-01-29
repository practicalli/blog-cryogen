{:title "Code Snippets for Clojure LSP"
:layout :post
:date "2022-01-28"
:topic "clojure"
:tags  ["clojure" "clojure-lsp" "snippets"]}

[Clojure LSP snippets](https://clojure-lsp.io/features/#snippets) are an editor agnostic approach to expanding common code forms from snippet names, saving typing and acting as a guide to the syntax of a Clojure form.  Practicalli also uses snippets for rich comments, documentation and highlighting logical sections of code in a namespace.

Clojure LSP snippets are defined using the EDN syntax and have the same tab stop syntax as [Yasnippets](/posts/yasnippets-for-faster-clojure-development/) and other snippet tools.

> [Clojure LSP snippets are covered in Practiclli Spacemacs](https://practical.li/spacemacs/snippets/clojure-lsp/), including a large number of examples of custom snippets

<!-- more -->

## Clojure-lsp snippets

Clojure LSP includes snippets as part of the completion feature, so when typing the name of a snippet it will appear in a completion popup.  In the same way that happens for Clojure functions and other symbols.

![Spacemacs LSP snippets - deps snippets in completion menu](https://raw.githubusercontent.com/practicalli/graphic-design/live/spacemacs/screenshots/spacemcs-snippets-completion-menu-deps-snippets.png)

* [Built-in clojure-lsp snippets ](https://clojure-lsp.io/features/#snippets)

> The current 2022.01.22-01.31.09 release of Clojure LSP only supports snippets within an existing form, such as a `(comment ,,)` form.  A fix has already been applied to the main branch and will be included in the next release.


## Writing Custom snippets

[Creating custom snippets](https://clojure-lsp.io/settings/#snippets) by adding `:additional-snippets` key to the Clojure LSP configuration, either `.lsp/config.edn` in the root of the project or in the global config (`$XDG_CONFIG_HOME/clojure-lsp/config.edn` or `$HOME/.lsp/config.edn`)

The `:additional-snippets` key is associated with a vector or hash-maps, `[{}{},,,]` with each hash-map defining a snippet using the keys:

`:name` - name of the snippet, typed into the editor for completion

`:detail` - a meaningful description of the snippet

`:snippet` - the definition of the snippet, with tab stops and current-form syntax

The `:snippet` can be any text, ideally with syntax that is correct for the particular language

> [practicalli/clojure-lsp-config](https://github.com/practicalli/clojure-lsp-config) defines additional snippets, including clojure.core functions, documentation, rich comments and Clojure CLI dependencies.


### Snippets and Tab Stops

Tab stops are a way to customise the generated snippet text, so unique values for that snippet can be added.

Include `$` with a number, e.g. `$1`,`$2`,`$3`,  to include tab stops in the snippet.  Once the snippet code has been generated, `TAB` key jumps through the tab stops in sequence, allowing customisation of a generic snippet.

`${1:placeholder-text}` adds placeholder text on a first tab stop, providing a guide to the type of value should be entered.  The default text is replaces when typing in the tab stop.

Using a tab stop number multiple times will concurrently add text to all matching tab stops

`$0` marks the final position of the cursor, after which `TAB` has no more positions in the snippet to jump to.

```clojure
{:name "deps-git-url"
 :detail "Git URL dependency"
 :snippet
 "${1:domain/library-name}
    {:git/url \"https://github.com/$1:\"
     :git/sha \"${2:git-sha-value}\"}$0"}
```


### Snippet current-form

Snippets using `$current-form` will pull in the next Clojure form when expanding the snippet

```clojure
{:additional-snippets
 [{:name "wrap-let-sexp"
   :detail "Wrap sexpr in let form"
   :snippet "(let [${1:name} $current-form] $0)"}]}
```

Expanding `wrap-let-sexp` before the form `(* 2 21)` will create the form `(let [life (* 2 21)])` (when `life` is typed into the first tab stop placeholder).


### Clojure code driven snippet - built-in snippets only

The built-in `defn` snippet uses Clojure code to help generate the snippet.

`%s` is a substitution point within a snippet, used by the standard Clojure `format` command. The value substituted is either `defn ^:private` or `defn-`, depending on the value returned from the `if` expression.

`:use-metadata-for-privacy?` is a key from the Clojure LSP configuration, set to `true` or `false`

```clojure
 {:label "defn-"
  :detail "Create private function"
  :insert-text (format "(defn%s ${1:name} [$2]\n  ${0:body})"
                       (if (:use-metadata-for-privacy? settings)
                         " ^:private"
                         "-"))}
```

The syntax for built-in snippets is slightly different that the `:additional-syntax` form.  The internal form uses `:label` for `:name` and `:insert-text` for `:snippet`.

> Clojure code only works for built-in snippets and not `:additional-snippets`. Clojure LSP is compiled by Graal to a native binary, including the built-in snippets.  To include Clojure code in a snippet then consider submitting a pull request to the Clojure LSP project to add a built-in snippet.


Clojure LSP snippets are [defined in `clojure-lsp.feature.completion-snippet` namespace](https://github.com/clojure-lsp/clojure-lsp/blob/master/src/clojure_lsp/feature/completion_snippet.clj).


## Summary

Clojure LSP can define quite rich text expansions and built-in snippets can go further using Clojure code to expand the text.

[Clojure LSP snippets and Yasnippets are covered in more detail in Practiclli Spacemacs](https://practical.li/spacemacs/snippets/clojure-lsp/), including a large number of examples of custom snippets

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
