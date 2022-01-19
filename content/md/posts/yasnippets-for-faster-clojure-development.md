{:title "YASnippets for faster clojure coding"
:layout :post
:date "2016-07-23"
:topic "spacemacs"
:tags  ["spacemacs" "emacs" "snippets"]}

Yasnippets to minimise typing for commonly used Clojure forms and documentation structures, or any other text regularly created. Yasnippets have placeholders that allow jumping (tabbing) to points in the snippet, so specific text can be added to the more generic text of the snippet.

Emacs YASnippet package uses [mode-specific snippets](https://github.com/AndreaCrotti/yasnippet-snippets "Yasnippet official snippet collections") that expand to anything from a simple text replacement to an intricate code block structure using placeholders to add specific values to the general form.

See YASnippet in action in this [Emacs Yasnippet video](https://www.youtube.com/watch?v=-4O-ZYjQxks).

[Add custom snippets](spacemacs-adding-your-own-yasnippets.html) for Clojure or any other language you use with Spacemacs / Emacs

> Additional ways to speed up typing Clojure code include creating projects from templates or general abbreviations with [Emacs Abbrev mode](http://ergoemacs.org/emacs/emacs_abbrev_mode.html)
> [Snippets are also part of Clojure LSP](https://clojure-lsp.io/features/#snippets "Clojure LSP website") and can be used with any supporting editor.

<!-- more -->

## Using snippets

Start typing the snippet name and press `M-/` to `yas-expand` which replaces the name with the full text of the snippet.

Type `defn` and press `M-/` to expand to the code of a function definition form.  Use `TAB` to move through the placeholders to complete the name, doc-string, arguments and body of the function.

> Smartparens is disabled when tabbing through a snippet


## List snippets for current major mode

`SPC i s` (`helm-yas`) displays a completion buffer that lists the matching snippets available for the current major mode.

`C-j` and `C-k` to navigate the list and `RET` to insert and expand the snippet.

![yasnippets yas-helm for clojure mode](https://raw.githubusercontent.com/practicalli/graphic-design/live/spacemacs/screenshots/spacemacs-snippets-helm-yas-clojure-mode.png)


## Add snippets to completion menu

The auto-completion layer shows a completion popup menu, with matching functions and other names from the REPL or Clojure LSP (clj-kondo). Configure the `auto-completion` layer to show YASnippets when typing.

Add the `auto-completion-enable-snippets-in-popup` variable to show snippets in the auto-completion popup.

Add `auto-completion-enable-sort-by-usage` to show the most commonly used snippets first in the list.

```lisp
(auto-completion :variables
                 auto-completion-enable-snippets-in-popup t
                 auto-completion-enable-sort-by-usage t)
```

Matching snippets will now appear in the completion menu whilst typing

![Spacemacs helm snippet gitbook example](https://raw.githubusercontent.com/practicalli/graphic-design/live/spacemacs/screenshots/spacemacs-helm-snippet-gitbook-deps-lein.png)


## Default snippets for Clojure

The snippets available in Spacemacs can be found in the [yasnippet github repository](https://github.com/AndreaCrotti/yasnippet-snippets).

`defn`, `require`, `let`, `ifl` and `for` are often used by Practicalli.

> NOTE: The `test` snippet generates a `deftest` form which by convention uses a name post-fixed with `-test`.  Pressing `TAB` after `test` will expand that word into another deftest form within the current deftest form.
>
> Press space after teh `-test` name to prevent `test` being expanded to a `deftest` form.


The [current snippets for Clojure mode](https://github.com/AndreaCrotti/yasnippet-snippets/tree/master/snippets/clojure-mode) are in the following table, indicating which tab stops they have.  [mpenet/clojure-snippets](https://github.com/mpenet/clojure-snippets) include a few additional Clojure snippets (although are not part of yasnippets by default).


| Snippet    | Description                                                                                                             | Tab Stops                              |
|------------|-------------------------------------------------------------------------------------------------------------------------|----------------------------------------|
| bench      | benchmark an expression, using the `time` function                                                                      | body                                   |
| def        | `def` expression                                                                                                        | N/A                                    |
| defm       | `defmacro` expression, with name, doc-string, arguments & body tabstops                                                 | name, docstring, args, body            |
| defn       | `defn` expression, with name, doc-string, arguments & body tabstops                                                     | name, docstring, args, body            |
| fn         | `fn` - anonymous function                                                                                               | name, body                             |
| for        | `for`                                                                                                                   | condition, body                        |
| if         | `if`                                                                                                                    | condition, body                        |
| ifl        | `if-let` - if true, bind a local name                                                                                   | binding, body                          |
| import     | `import` java library                                                                                                   | library name                           |
| is         | `is` - clojure test assertion                                                                                           | value, expected                        |
| let        | `let` - bind a local name to a value                                                                                    | name, value, body                      |
| map        | `map`                                                                                                                   | fn, col, col                           |
| map.lambda | `map` with anonymous function `#()`                                                                                     | fn, body                               |
| mdoc       | metadata docstring                                                                                                      | docstring                              |
| ns         | `ns` - expression with the current namespace inserted automatically                                                     | N/A                                    |
| opts       | [destructure](http://clojure.org/guides/destructuring) map with `:keys`, `:or` for default values, `:as` for arg vector | :key binding, or defaults, :as binding |
| pr         | `prn` - print function                                                                                                  | string/value                           |
| print      | `println` - print function                                                                                              | string/value                           |
| reduce     | `reduce` - reduce expression with an anonymous function                                                                 | args, body                             |
| require    | `:require` expression with library and alias                                                                            | library, alias                         |
| test       | `deftest` expression (not including testing part of a deftest expression)                                               | test description, value/expected       |
| try        | `try` & `catch` expression                                                                                              | try expression, exception name, body   |
| use        | depreciated: use require instead                                                                                        |                                        |
| when       | `when`                                                                                                                  | when expression, body                  |
| whenl      | `when-let` - local binding on when condition                                                                            | binding, body                          |


## Summary

Have fun speeding up the writing of your Clojure code (and any other common text structures) in [Spacemacs](https://spacemacs.org) / [Emacs](https://www.gnu.org/software/emacs/).

Consider [writing custom snippets](/posts/writing-custom-snippets-for-yasnippets/) to extend those available via Yasnippets.

> Article originally published on [jr0cket.co.uk](https://jr0cket.co.uk/) and has been migrated to [practical.li/blog](https://practical.li/blog/) with some minor updates.


Thank you.
[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
