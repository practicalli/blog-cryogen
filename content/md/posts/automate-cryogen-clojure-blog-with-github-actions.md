{:title "Automate Cryogen Clojure blogg with GitHub Actions"
 :layout :post
 :date "2021-08-28"
 :topic "cryogen"
 :tags  ["cryogen" "blogging" "static-sites" "github-actions"]}

[Practicalli uses Cryogen static site generator for its blog website](https://practical.li/blog/posts/clojure-powered-blogging-with-cryogen/).  Cryogen is fast and simple to use thanks to the Clojure EDN file used for configuration.

Cryogen documentation shows [how to publish a Cryogen blog to GitHub pages](https://cryogenweb.org/docs/deploying-to-github-pages.html) using Git command.  The deployment can be automated using GitHub actions, so that a new version of the site is deployed when Pull Requests are merged to the specified branch (or on direct commits to that branch).

<!-- more -->

## What does the GitHub workflow do?

This is a combination of GitHub actions, each doing a specific part of the automated workflow.

The **publish** job runs on an Ubuntu docker image and the **Checkout** step performs a git checkout of the project into the docker image.

**Prepare Java** step uses the [setup-java action](https://github.com/actions/setup-java) to add Java 11 to the docker image, using the Eclipse Foundation `temurin` image ([OpenJDK / AdoptOpenJDK is now part of the Eclipse Foundation](https://blog.adoptopenjdk.net/2021/08/goodbye-adoptopenjdk-hello-adoptium/)).

**Install clojure tools** step uses the [setup-clojure action](https://github.com/DeLaGuardo/setup-clojure) to add the specified version of Clojure CLI tools (Leiningen and Boot build tools are also supported)

**Build blog site** step calls the Cryogen function using Clojure CLI tools to build the static site

**Publish to GitHub pages** step uses the [github-pages-deploy-action](https://github.com/JamesIves/github-pages-deploy-action) to deploy a specific directory, the directory built by Cryogen, to another branch of the original repository or a different repository. If the branch does not exist, the action will create it.


## Deploying to other repositories

When deploying the Cryogen site to the same GitHub repository as the source files, the [github-pages-deploy-action](https://github.com/JamesIves/github-pages-deploy-action) does not require an explicit token to be added. The action uses the default repository scoped GitHub token.

If deploying the site to another repository from that of its source files, create a GitHub secret with a value of a Personal Access Token (PAT). The personal access token should have the least permissions necessary, usually only `repo`.

A GitHub secret can be added at user or organisation level and configured for specific repositories.


## Add GitHub Action

Create a file called `.github/workflows/cryogen-publish.yml` and add a workflow configuration.

```json
name: Publish Blog
on:
  push:
    branches:
    - live

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare java
        uses: actions/setup-java@v2
        with:
          distribution: 'temurin'
          java-version: '11'

      - name: Install clojure tools
        uses: DeLaGuardo/setup-clojure@3.5
        with:
          cli: 1.10.3.943

      - name: Build Blog site
        run: clojure -M:build

      - name: Publish to GitHub Pages
        uses: JamesIves/github-pages-deploy-action@4.1.4
        with:
          commit-message: ${{ github.event.head_commit.message }}
          branch: gh-pages                                      # branch to deploy to
          single-commit: yes                                    # no commit history
          folder: public/blog                                   # directory to deploy from
```


## GitHub Action configuration with token

If deploying to a different repository than the source, then add a token to the configuration

```json
      - name: Publish to GitHub Pages
        uses: JamesIves/github-pages-deploy-action@4.1.4
        with:
          commit-message: ${{ github.event.head_commit.message }}
          token: ${{ secrets.PRACTICALLI_BLOG_PUBLISH_TOKEN }}  # GitHub secret
          repository-name: practicalli/deployed-blog            # repository to deploy to
          branch: gh-pages                                      # branch to deploy to
          single-commit: yes                                    # no commit history
          folder: public/blog                                   # directory to deploy from
```

## Summary

Once the `.github/workflows/cryogent-publish.yml` file is committed to the default branch of the repository, any commits to that branch or merged pull requests to that branch will trigger the workflow and publish a new version of the Cryogen static website.
