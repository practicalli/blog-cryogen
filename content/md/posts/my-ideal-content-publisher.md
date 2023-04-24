{:title "Content publishing with Clojure"
 :layout :post
 :draft? true
 :date "2022-10-23"
 :topic "clojure-cli"
 :tags  ["clojure" "blogging"]}


## My ideal content publisher

* Supports content writing in org, markdown and asciidoc simultaneously
* meta-data written in edn, org-mode, markdown
* configuration in edn format or aero
* Supports different output types, blog, website, landing page, workshop, book
* templating for content - i.e. selma
* RSS feeds - tailored to specific tag or topic content
* Uses tools.deps
* Clojure CLI support, eg. `clojure site build`, `clojure site drafts` or `clojure site test` where site is the name of the application.  With aliases this should be possible with `clojure -Asite:build`
* Easy to use test framework
* Can be built using continuous integration server (PR accepted and new version of site is built and published)
* deploy to GitHub pages easily (no need for an unsophisticated script)
* import from other blog sites

## Existing projects

## Cryogen

Pros

* simple to use
* nice themes, easily customisable
* edn for post metadata and configuration

Cons

* doesnt support markdown defined tables in posts


## [Bootleg](https://github.com/retrogradeorbit/bootleg)

Bootleg is a command line tool that rapidly renders clojure based templates. With inbuilt support for html, hiccup, hickory, mustache, enlive, json, yaml and edn, it enables you to pull together disparate elements and glue them together to generate the static website of your dreams.


## [Stasis](https://github.com/magnars/stasis) - magnars

A Clojure library of tools for developing static web sites.


## [Blog](https://github.com/Olical/blog) - Olical

A new project to generate blog websites from asciidoc


## [Static](https://nakkaya.com/static.html) - nakkaya

Pros

* Supported markup languages - markdown org-mode (via emacs) clojure (hiccup) cssgen html

Cons

* very basic styles for theme

## [incise](https://github.com/RyanMcG/incise)

Pros

* a deployer (does this support Github pages ??)
* extensible

Cons

* Eclipse public license
* no new development in 5 years

Summary
Possible source of inspiration

### [Misaki](https://github.com/liquidz/misaki)

A jekyll inspired static site generator

Pros

* expandable built in functions

Cons

* project archived by owner - no new development in 5 years
* no klipse integration (although probably not hard as you can add your own cljs compiler)
* leiningen

Summary
Could be a useful source of inspiration


Thank you.
[@practicalli](https://twitter.com/practicalli)
