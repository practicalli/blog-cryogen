{:title "Practicalli plans for 2024"
:layout :post
:date "2023-11-17"
:topic "practicalli"
:tags  ["practicalli"]}

I'm seeking feedback work by Practicalli that would be considered valuable to the Clojure community in 2024

Most Practicalli work is created from my own commercial experiences with Clojure.  I also include aspects I've learned for my own interest and to answer some questions posed by the community (e.g. Slack, Clojureverse, etc.)

[Practicalli GitHub project](https://github.com/orgs/practicalli/projects/2) visualises current work progress and lists many ideas for more work to come.  Please comment on specific tickets, raise new ones or chat to me on #practicalli channel of [Clojurians Slack Community](https://practical.li/blog/posts/cloure-community-getting-help/).


<!-- more -->

## Which Clojure Library

The "Which Clojure Library" project would provide a consistent way to find and understand the purpose of Clojure libraries. Each library description would be an unbiased review based on commercial and community experiences. The community would be able to update aspects of each library description to keep the information as relevant as possible.

Major Features
- search for libraries by topic, e.g. web server, routing, html template, etc
- consistent information for each library (integration with Git for common project information)
- provide rationale, characteristics and usefulness of each project
- common stacks and describe their benefits and constraints (in a consistent way)
- link to the major libraries that compose the stack

The first phase of the project would provide a website that included the most commonly used libraries, each with a comprehensive description of their purpose and related libraries / stacks.

Clojurists Together funding has been applied for to help make this project happen. 


## Practicalli Clojure

Practicalli Clojure gained more focus on the Clojure workflow in 2023, which I think is now covered quite well.

- examples of using portal to visualise information
- move REPL reloaded as a top-level entry in side-bar navigation
- move automation under Clojure Projects, add examples of using babashka tasks to manage projects


Specification
- additional example projects using spec
- comparison of spec and malli
- example projects using malli


More focus on education, specifically extending challenge walkthroughs and design journals in more detail to complement the videos

- written walkthrough guides from the 4EverClojure and Exercism video playlists


## Clojure 1.12 release
- update all book and project examples to use clojure 1.12 stable release (once its released)
- update Practicalli Clojure & Clojure Web Services to use new add-libs and sync-deps tools


## Practicalli Neovim
- extend user guide to cover more aspects of development (clojure and general development workflows)
- consider nfnl configuration (extending or building-on from Cajus)

- Extend Clojure API guides and example projects
  - using ring-reitit with ring middleware
  - deeper understanding of reitit middlware and libraries

- Extend use of Donut-party/system for system components
  - use donut-part/system as main library for all examples
  - move integrant and mount examples to reference section


## Practicalli Project Templates

Create additional general templates:

* `practicalli/api` - production grade API service (reitit-ring, clojure.spec validation)
* `practicalli/library` - general library, deployment to Maven/Clojars
* `practicalli/blog` - Cryogen project with Practicalli Customisation for staging and live publication workflow


Create web UI templates:

* `practicalli/catalog` - a catalogue front-end webapp with [firebase persistence](https://firebase.google.com/), user OAuth authentication, figwheel, Reagent, Bulma.io CSS
* `practicalli/store-front` - a front-end webapp with stripe integration, [firebase persistence](https://firebase.google.com/), OAuth authentication, figwheel, Reagent, Bulma.io CSS


## Clojure Web Services

The production grade project guides have slipped from last year due to my covid illness.  Integrant & Integrant REPL content is published, along with a Service REPL workflow.  These sections will be extended and link to new guides for building specific kinds of projects.

* Building REST API’s with Reitit and clojure.spec (experiences from the last 2 commercial projects)
* Donut-party/system guide for system management (current mini-project)
* sharing commercial experiences logging with mulog and publishing events
* Docker configuration for services and databases (healthcheck, conditional container startup, etc.)




## Video content

Creating video content is very time consuming, but can be very valuable to the community.  To produce a polished 10 minute video can easily take a day (or more).

The live coding videos typically took much of the prior week to prepare, mostly due to learning the concepts and identifying how to meaningfully present them. 


- create polished versions of the 100+ hours of live coding video content created in 2018-2019

New content will follow the [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/) and will include videos showing how I work, based on my commercial experiences with Clojure. I am also keen to start a regular live broadcast of Hacking Clojure, these will be live and unscripted, allowing for an experimental experience and an opportunity to understand what information would be useful to create in the more polished Practicalli books and videos.




## Practicalli Blog

- migrate [Practicalli Blog to Material for MkDocs](https://practicalli-john.github.io/blog-material/) (more content presentation options)
- update the older Clojure CLI content
- further examples of usint Clojure CLI and its associated workflows
- import relevant articles from jr0cket.co.uk website, updating were neccessary


## Practicalli Spacemacs



## Notable changes in 2023

- [Practical.li books](https://practical.li/) using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) and provides a light and dark theme and interactive presentation options
- Practicalli Clojure significant re-write elaborating on the use of Clojure CLI tools (deps.edn) and [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/)
- Defined Service REPL Reloaded workflow in Practicalli Clojure Web Service book
- Created [Practicalli Project Templates](https://github.com/practicalli/project-templates/) to create production grade projects from templates using seancorfield/deps-new
- Migrated all books to Material for MkDocs for a much richer experience
- Archived Doom Emacs book
- Archived Practicalli Neovim Config written in Fennel (switched to AstroNvim)
- Adopted Neovim as the predominant editor for all workflows (Magit still used for advanced rebasing)

> Practicalli Templates include the Practicalli REPL Reloaded tools (Hotload, Portal, Namespace reload), tools.build scripts, Make and Babashka (TODO) automation, Dockerfile & compose.yaml configurations (healthcheck, conditional container startup, etc.).

[Original Practicalli plans for 2023](https://practical.li/blog/posts/practicalli-plans-2023/)

![Practicalli Clojure themes comparison - light and dark](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/practicalli-clojure-theme-comparison.png "Practicalli Clojure dark and light themes")

## Thank you

The funding from Cognitect/Nubank and a few generous people via GitHub Sponsors covers some of the regular maintaintenance and mintor updates to the work. Most of the effort is (and mostly has been) on my own time. 

Without feedback this does mean I work on what is most useful for myself and any commercial experiences I have chance to document (without giving away sensitive ideas).  

Thank you to everyone who has provided financial and emotional support.



## Summary

I am excited about adding more content to Practicalli this year and continue to help those new to Clojure as well as existing developers make the most from the language, tooling and workflows.


Without Clojurists Together funding I'll still be working on Practicalli, although the work will take far longer in order to make time for some commercial work.

Feedback and ideas are welcome via the #practicalli channel of the Clojurians Slack Community or via issues on the [Practicalli Todo board](https://github.com/orgs/practicalli/projects/2) (and issues on the associated repositories)

Many thanks to everyone who has supported the work in the past and those that continue to sponsor this ever growing project.

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practical_li)
