{:title "Writing custom snippets for yasnippet"
:layout :post
:date "2016-07-23"
:topic "spacemacs"
:tags  ["spacemacs" "emacs" "snippets"]}

Snippets are names that expand to code or documentation, to minimise typing commonly used code pattern and can serve as a reminder of common Clojure forms.

YASnippets templates are defined in plain text, so are very easy to learn and write.

The content of a snippet can be anything, from a simple piece of text or a more involved code structure with placeholders for tab stops.  Snippets can even include Emacs lisp (elisp) code which is evaluated, allowing the snippet to tap into all the features of Emacs.

> See a [detailed writing snippets guide](https://joaotavora.github.io/yasnippet/snippet-development.html) for other example than presented here.

<!-- more -->


## Yasnippet Template metadata

Metadata directives have the form `# property: value` and appear before a `# --` line in the snippet file.

* `# key:` abbreviation typed to expand a snippet (not be expandable if not specified)
* `# name:` one-line description of the snippet, displayed in the completion menu (ideally unique for the Emacs mode). File name used if not specified
* `# uuid:` unique identifier for a snippet, independent of its name
* `# contributor:` name of the snippet author
* `# condition:` expansion condition in Elisp, snippet only expands if condition non-nil
* `# group:` group snippets for a given Emacs mode into sub-menus (Yasnippet menu)
* `# expand-env:` Elisp varlist to override variable values during snippet expansion
* `# binding:` define Emacs keybinding to expand snippet
* `# type:` body is `snippet` (parse text template) or `command` (interpret Elisp)

`key` and `name` directives should be part of all snippets for consistency and ease of use.

## Creating a snippet

Each snippet template is defined in its own file, named after the alias of the snippet and located in the directory names after the Emacs mode the snippet should be available in.

Load a new snippet using the `M-x yas-load-snippet-buffer` command in the buffer of the new snippet (or restart Emacs, `SPC q r`)


### Example: Simple expansion

Practicalli use markdown mode when writing book and blog content and it can be useful to mark some pages as work in progress

```
# contributor: Practicalli
# key : todo-wip
# name : TODO callout work in progress
# --
> #### TODO::Work in progress
```

When you expand this snippet with `M-/` then the snippet name is replaced by the content.


## Tab Stops

Tab stops are fields to navigate forward or backward through the template using `TAB` and `S-TAB`.

A tab stop is defined with `$` followed with a number, e.g. `$1`, `$2`, `$3`, etc.

`$0` defines the exit point of the snippet and navigation stops when reaching this point.

`$>` at the end of a line in the snippet ensures that line is correctly indented, according to the rules of the Emacs mode the snippet is from.


### Example: end tab stop

An example snippet to add a section comment to logically separate sections of a Clojure namespace.  Section comments are useful for navigating a namespace and identifying opportunities to refactor one namespace into others.

```
# contributor: Practicalli
# key : ns-section
# name : namespace section separator
# --
;; $0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
```

`$0` is our exit point from the snippet, so pressing `TAB` reverts to the usual behaviour outside of YASnippet.


### Example: multiple tab stops

An HTML form expressed in Clojure hiccup syntax has a standard structure with multiple custom values.  Adding tab stops within the snippet structure makes the form values simple to complete.

```
# contributor : Practicalli
# key : hiccup-form
# name : [:form {:method "..." :id "..." :action "..."}]
# --
[:form {:method "$1"$>
        :id "$2"$>
        :action "$3"}$>
$0
```

`TAB` will jump to each tab stop in turn, ending when `$0` location is reached.

Each line of the snippet will have the correct indentation applied from the Clojure mode.


## Placeholders

Snippets benefit from placeholders which can guide the completion of tab stop values by providing a default value.  That value is replaced when entering the tab stop so does not interfere with adding specific values into the expanded snippet.

A placeholder is defined using `{}` around the tab stop number and the default value, i.e. `${1:name}` is tab stop 1 with a default value of name.


### Example: deftest

Expand to a complete `deftest` form, including a `testing` form for grouping assertions along with the first assertion.

The `deftest` name has a placeholder to update the specific part of the name, with `-test` post-fixed to the name (a common Clojure test naming convention).

The `testing` string has a placeholder between the `""` double quotes, so only the text within `""` are replaced when entering the tab stop

In `$3` the assertion-value is completely replaced when entering the tab stop.

```
# -*- mode: snippet -*-
# name: deftest clojure.test function
# key: deftest
# contributor: practicalli
# --
(deftest ${1:name}-test
  (testing "${2:Context of the test assertions}"$>
    (is (= ${3:assertion-values}))$4))$>
$0
```

## Mirrors

Tab stops with the same number will mirror each other, so if the snippet has `$1` in multiple places, each value will be updated when any value at `$1` is updated.

```
# -*- mode: snippet -*-
# contributor: Practicalli
# name: for-let
# key: for :let
# --
(for [$1 $2
  :let [${3:local-name} $4]]$>
  $3)$>
```

Updating tab stop 3 will update the local-name and also the value to be returned (the last part of the `for` expression).


## Creating a snippet from a region

A quick way to create a snippet is to select a region of text that is a specific instance of what the snippet would be used to create.

`v` and motion keys to select the relevant region of text

`SPC SPC helm-yas-create-snippet-on-region` to start creating a snippet from that selected region

Enter a file name in the respective Emacs mode for the snippet, defaulting to the current mode.

A new file is created with the following metadata directives

```none
# -*- mode: snippet -*-
#name : delete-me
#key : delete-me
#contributor : Practicalli
# --
The region of text that was selected.  Edit me to make the desired snippet.
```

Edit the body of your snippet to replace the specific names and values with tab stop placeholders, `$1` `$2`, `$3`, etc.

`C-c C-c` to save the snippet buffer and load the snippet into the respective Emacs mode, making it immediately available.


## Update an existing snippet

`SPC SPC helm-yas-visit-snippet-file` opens a helm popup.

Start typing the name of the snippet to narrow the list.

`C-j` and `C-k` to navigate the list and `RET` to select the snippet.

Edit the snippet and `C-c C-c` to save and apply the changes, making the updated snippet immediately available.


## Testing your snippets

Once you have written your snippet, you can quickly test it using `M-x yas-tryout-snippet`.  This opens a new empty buffer in the appropriate major mode and inserts the snippet so you can then test it with `M-/`.

If you just want to try the snippet in an existing buffer, then use `M-x yas-load-snippet-buffer` to load this new snippet into the correct mode.  `M-x yas-load-snippet-buffer` does exactly the same except it kills the snippet buffer (prompting to save first if necessary).

> Spacemacs does not define key bindings for these commands, although bindings could be create under `SPC o`, for example `SPC o s t` to try a snippet and `SPC o s l` to load a snippet.


## Spacemacs snippet locations

Using `~/.spacemacs.d/` directory for the Spacemacs configuration (rather than `.spacemacs`), adding `~/.spacemacs.d/snippets/` directory will automatically save custom snippets there. Snippets are saved in a directory named after the Emacs mode under that snippet directory, i.e. `~/.spacemacs.d/snippets/modename-mode/`

Otherwise custom snippets are saved to the `~/.emacs.d/private/snippets` directory and their respective Emacs mode directory.


## Summary

Find out more about YASnippets and autocompletion from the [Github repository for Spacemacs autocompletion layer](https://github.com/syl20bnr/spacemacs/tree/master/layers/auto-completion).

For more details and examples on writing your own snipplets, take a look at:

* [Emacs YASnippet video tutorial](https://www.youtube.com/watch?v=-4O-ZYjQxks)
* [Snippet development](https://joaotavora.github.io/yasnippet/snippet-development.html).
* [Adding YASnippets snippets](http://jotham-city.com/blog/2015/03/21/adding-yasnippets-snippets/)
* [Snippet expansion with YASnippet](http://cupfullofcode.com/blog/2013/02/26/snippet-expansion-with-yasnippet/index.html)


> Article originally published on [jr0cket.co.uk](https://jr0cket.co.uk/) and has been migrated to [practical.li/blog](https://practical.li/blog/)

Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
