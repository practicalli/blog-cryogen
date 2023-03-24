{:title "Practicalli content plans for Spring 2022"
:layout :post
:date "2022-02-18"
:topic "practicalli"
:tags  ["practicalli"]}

Much more content is coming in the Spring of 2022, thanks to [Clojurists Together funding](https://www.clojuriststogether.org/news/q1-2022-funding-announcement/).  To ensure the most useful content is provides, Practicalli would value feedback on the planned topics.

The [submitted plan to Clojurists Together](https://www.clojuriststogether.org/news/q1-2022-funding-announcement/) is to extend existing guides and code examples, as well as adding new content to the existing Practicalli books.  Additional video content will be added across the Practicall Books, updating existing video content where it has become dated.

> Due to continued Covid symptoms, [work is being done over 2022 and 2023](https://github.com/practicalli/clojurists-together-journal/blob/summer-2022/2022-2023-updates.md) as health conditions allow

Videos will be created off-line rather than live broadcasts, to increase the quality of the videos.  Practicalli may do some live broadcasts again, however, these will be very experimental and unscripted (possibly subject to Covid brain fog too).

Practicalli is also looking for opportunities to help improve documentation and code examples back to open source projects and has recently contributed to CIDER and Kaocha projects.

<!-- more -->

## Feedback

Discussions are available in the #practicalli channel for both [Clojurians Zulip](https://clojurians.zulipchat.com/#narrow/stream/practicalli) and [Clojurians Slack](https://clojurians.slack.com/messages/practicalli) communities.  DM's are also welcome if you wish to have a one-to-one discussion.

The [Practicalli TODO kanban board](https://github.com/orgs/practicalli/projects/2/ "GitHub Project Kanban board") manages the work across all Practicalli content

![Practicalli GitHub Organisation Kanban board for managing tasks across all content](https://raw.githubusercontent.com/practicalli/graphic-design/live/github/practicalli-organisation-github-kanban-board.png)

Each book GitHub repository lists additional ideas as issues for the community to vote on in their respective repositories on the [Practicalli GitHub Organisation](https://github.com/practicalli/)


## Practicalli Clojure

A book for those starting their journey into Clojure, taking the [REPL driven development approach](https://practical.li/clojure/repl-driven-development.html).  The book covers install and configuration of Clojure CLI, Clojure aware editors and data inspectors.  Using those tools to learn Clojure through a series of challenges and small projects.  Complementing REPL Driven Development with Test Driven Development

![Practicalli Clojure book banner](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/clojure-repl-workflow-concept.png)

The plan is to migrate to the [tools.build approach](https://clojure.org/guides/tools_build) and adopt more tools using the `-T` execution option, both as installed tools and via user level aliases.

* [production grade templates for deps-new](https://github.com/practicalli/clojure/issues/404), including dev tools, component services and deployment options - e.g. [practicalli/clojure-app-template](https://github.com/practicalli/clojure-app-template)
* migrate to deps-new for project templates over clj-new (although keep examples in place for using classic templates)
* adopting tools.build `build.clj` configuration
* add tools.build examples and retro-fitting tools.build to existing project guides across all books (deprecating depstar)


## Practicalli Clojure Web Services

Covering how to build Server-side web services and APIs from the ground up, aiming for a simple design and clean code.  Using tools such as Integrant REPL to support a REPL Driven Development approach.

![Practicalli Clojure Web Services book banner](https://raw.githubusercontent.com/practicalli/graphic-design/live/book-covers/practicalli-clojure-web-service-book-banner-dark.png#only-dark)

The plan is to update existing guides to show how to build production grade Clojure services.  Additional guides will focus on building APIs with Reitit, Integrant and mulog.

One of the commercial projects by Practically in 2021 was a GraphQL API with a web hook to manage authorisation to the data using Reitit and Auth0.com, so many lessons learned from this project will be added.

* [Integrant REPL](https://practical.li/clojure-web-services/repl-driven-development/integrant-repl/) and Integrant with Aero
* Structured logging with mulog and configuring common log publishers
* Building REST API's with Reitit and clojure.spec
* Authentication & Authorization (with Auth0 service) - especially for API's
* Deployment for web services with GitHub Action examples and adding Docker configuration including local build from source

[Continuous Integration with CircleCI content](https://practical.li/clojure/continuous-integration/circle-ci/) has already been updated to use the latest Clojure image

If there is time then practicalli will also take a look at [JUXT/site](https://github.com/juxt/site) and associated projects, with an view to move Practicalli content onto Site if appropriate.


## Essential Clojure

One of the most challenging aspects for those new to Clojure is understanding what libraries are available and which are the most appropriate to use.  This is often seen in the call for a Clojure framework.  However, the existing Clojure community is generally aware that large frameworks cause more challenges for developers than they solve.

To address this need, create a curated guide to the most common tools and libraries to support developers navigate the myriad of options in the Clojureverse.  This would be a reference for experienced and new developers to lean on, when they are looking for options to implement their design choices

* Unit testing & Test runners: clojure.test, humane output, Lambda Island Koacha, Cognitect Labs
* Repl Terminal UI - Rebel & Socket REPL, Remote REPL approaches
* REST API Reitit and Clojure.spec
* App server - jetty, httpkit, manifold / aleph
* System components lifecycle - Integrant, Mount, Component
* Logging - mulog
* Relational db - next.jdbc and postgresql & migration libraries
* Non-relational stores - XTDB
* Clojure editor - gitpods for evaluating (Calva, Spacemacs/Doom, Cursive, Conjure, Clover)

Open Source projects are preferred over commercial products, although there may be some honourable mentions to commercial products if they provide significant value and have a freely available development option.

Practicalli plans to reach out to others in the community also working on this issue, such as the [Freshcode team](https://freshcodeit.com/portfolio#!/tab/338930672-5) and their [Clojure Garden project](https://github.com/clojure-garden/clojure-garden).


## Summary

Clojurist Together sponsored work officially starts in April, although there will be much preparation and enhancement to the existing content  during February and March.  A [journal of development](https://github.com/practicalli/clojurists-together-journal) will be kept to help the community follow the changes, as was done with previously sponsored work.  The journal will also be published on the [Practicalli website](https://practical.li/).

All Practicalli books have been automated using GitHub actions, enhancing the speed of deployment and simplifying pull requests.  The GitHub actions also include MegaLinter to minimise spelling errors, broken links and other small issues.

The Clojure CLI [user level aliases repository](https://github.com/practicalli/clojure-deps-edn) continues to be regularly maintained, with monthly updates to the library versions used.  There will also be some changes as part of the move to tools.build approach and deps-new for creating new projects from templates, although these should be fairly seamless.

Practicalli has also been migrating to use LambdaIsland/Kaocha test runner as it has proven to save time locally and in continuous integration workflows.  Logging will be migrating to [mulog](https://github.com/BrunoBonacci/mulog) as structured event logs make much more sense and are far more effective for diagnosing issues.

Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practical_li)
