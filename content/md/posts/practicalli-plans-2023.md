{:title "Practicalli future plans"
:layout :post
:date "2023-04-24"
:topic "practicalli"
:tags  ["practicalli"]}


The plan of work for Practicalli during 2023 focuses on improving the developer experience for Clojure curious and experienced developers alike. A slow start to the year has changed into very good pace, especially after updating the tooling and theme for all the Practicalli books.  My health is much improved and motivation is very high (although still working on my fitness).

New work will follow the [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/) and will include videos showing how I work, based on my commercial experiences with Clojure. I am also keen to start a regular live broadcast of Hacking Clojure, these will be live and unscripted, allowing for an experimental experience and an opportunity to understand what information would be useful to create in the more polished Practicalli books and videos.

UPDATE: Practicalli was not selected for [Clojurists Together](https://www.clojuriststogether.org/) for funding this time around, so the planned work will take more time as I look for commercial work. 

Although I get some funding from Cognitect/Nubank and a few generous people this only covers the regular maintaintenance and mintor updates to the work. Most of the effort is (and mostly has been) on my own time. This does mean that I will be working on what is most useful for myself and any commercial work I obtain.  Thank you to everyone who has provided financial and emotional support.

<!-- more -->

## Book refresh

[Practical.li books](https://practical.li/) are now using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) and provide a light and dark theme, toggled via the sun icon in the top menu bar of each book.

![Practicalli Clojure themes comparison - light and dark](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/practicalli-clojure-theme-comparison.png "Practicalli Clojure dark and light themes")

Books can be edited directly via the pencil icon and changes added as a pull request.  A full CI workflow checks all pull requests via MegaLinter. If a pull request is merged by Practicalli a new version of the book is build and published automatically.

Please read the contributing guide for each book, e.g. <https://practical.li/clojure/introduction/contributing/>

Practicalli Clojure also had a significant re-write of many sections, updating and elaborating on the use of Clojure CLI tools (deps.edn) and [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/)[Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/).


## Practicalli Project Templates

[seancorfield/deps-new](https://github.com/seancorfield/deps-new) is a great tool for creating your own projects and your own templates to create projects.

[Practicalli Project Templates](https://github.com/practicalli/project-templates/) adds `practicalli/application` and `practicalli/service` to the built-in and community templates available and I plan to add even more project templates.  I will also be extend the capabilities of these templates with some programmatic transformations to allow different options during project creation.

Practicalli Templates include the Practicalli REPL Reloaded tools (Hotload, Portal, Namespace reload), tools.build scripts, Make and Babashka (TODO) automation, Dockerfile & compose.yaml configurations (healthcheck, conditional container startup, etc.).

General templates:

* `practicalli/api` - production grade API service (reitit-ring, clojure.spec validation)
* `practicalli/library` - general library, deployment to Maven/Clojars
* `practicalli/blog` - Cryogen project with Practicalli Customisation for staging and live publication workflow

Currently `practicalli/service` uses Integrant & Integrant REPL, this will be updated to have a simple service with basic reloading without tooling, Integrant & Integrant REPL and Donut-party/system options.


Web UI templates:

* `practicalli/landing-page` - a simple landing page with figwheel and Bulma.io CSS
* `practicalli/single-page-app` - a simple landing page with figwheel and Bulma.io CSS
* `practicalli/catalog` - a catalogue front-end webapp with [firebase persistence](https://firebase.google.com/), user OAuth authentication, figwheel, Reagent, Bulma.io CSS
* `practicalli/store-front` - a front-end webapp with stripe integration, [firebase persistence](https://firebase.google.com/), OAuth authentication, figwheel, Reagent, Bulma.io CSS


## Clojure Web Services

The production grade project guides have slipped from last year due to my covid illness.  Integrant & Integrant REPL content is published, along with a Service REPL workflow.  These sections will be extended and link to new guides for building specific kinds of projects.

* Building REST API’s with Reitit and clojure.spec (experiences from the last 2 commercial projects)
* elaborate guide on managing system with Integrant REPL, Integrant and Aero
* Donut-party/system guide for system management (current mini-project)
* sharing commercial experiences logging with mulog and publishing events
* Docker configuration for services and databases (healthcheck, conditional container startup, etc.)


## Practicalli ClojureScript

Provide updated guides for ClojureScript development, especially aimed at those developers new to front end development and with a focus on ClojureScript rather than JavaScript.

* building a landing page, single page app, catalog, shopfront
* authentication & Authorization (with Auth0 service)
* ClojureScript front-end and Firebase back-end database service
* create deps-new project templates to enhance developer experience


## Neovim Configuration

Neovim with Conjure has been an excellent development tool for Clojure.  I initially created the [fennel based practicalli/neovim-config-redux configuration](https://github.com/practicalli/neovim-config-redux) to provide a feature-rich workflow and tools, all via a mnemonic key-driven menu.  The config already provides a good Clojure experience thanks to Conjure, especially when adding Portal into the mix with the Practicalli REPL Reloaded workflow. There is much scope for improvement though, especially around the developer experience. 

Telescope and its extensions already provide an excellent experience.  Adding the Lazy package manager and Mason for LSP plugins will provide an excellent UI and greatly simplify interacting with packages and parsers. 

I would like to create an experience with Neovim that is comparable to [Spacemacs](https://practical.li/spacemacs/)) whilst still having a minimal footprint, similar to [AstroNvim](https://astronvim.com/) although preferably still created using Fennel.

Neovim 0.9 onward provides [a simple mechanism to try out different configurations](https://github.com/practicalli/neovim-config/issues/2), so it is much easier to discover features from other configurations.


## Summary

I am excited about adding more content to Practicalli this year and continue to help those new to Clojure as well as existing developers make the most from the language, tooling and workflows.

There is a lot of work planned and [more ideas in the Practicalli Todo board](https://github.com/orgs/practicalli/projects/2), although I feel like I'm making significant progress and [my GitHub stats](https://github.com/practicalli-john) are also looking very good too.

Without Clojurists Together funding I'll still be working on Practicalli, although the work will take far longer in order to make time for some commercial work.

Feedback and ideas are welcome via the #practicalli channel of the Clojurians Slack Community or via issues on the [Practicalli Todo board](https://github.com/orgs/practicalli/projects/2) (and issues on the associated repositories)

Many thanks to everyone who has supported the work in the past and those that continue to sponsor this ever growing project.

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practical_li)
