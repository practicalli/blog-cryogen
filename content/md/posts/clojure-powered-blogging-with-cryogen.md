{:title "Clojure powered blogging with Cryogen"
 :layout :post
 :date "2019-10-20"
 :topic "cryogen"
 :tags  ["cryogen" "blogging" "static-sites"]}


A website for blogging doesn't need to be a complex content management system, a simple and lightweight static website generator can create engaging websites that are easy to manage with Git.

Cryogen is a static site generator written in Clojure, allowing content to be written in either markdown or asciidoc.  Posts and pages are configured with Clojure hash-maps to manage the meta-data and layout information for each, including .

Cryogen seems very quick to generate a site and a local server can be run to automatically generate an updated website when changes to posts and pages are saved.

All that is required is a Java virtual Machine (eg. [AdoptOpenJDK](https://adoptopenjdk.net/)) and the [Leiningen build tool](https://leiningen.org/).

[practicalli/blog-content](https://github.com/practicalli/blog-content/blob/master/content/config.edn) contains all the content and configuration used to create the Practicalli blog website.

> **Limitation/bug** so far I have not been able to generate tables in markdown posts.  This may be an issue with [cryogen-markdown library](https://github.com/cryogen-project/cryogen-markdown), no results from searching at present

## Create a new site

Use the `cryogen` template for Leiningen to create a new project

Here we create a project called `practicalli-blog` using the template

```
lein new cryogen practicalli-blog
```

Change into the project directory and use Leiningen to run the project

```
lein ring server
```

A server will now start and generate the sample posts that are part of the Leiningen template.  Your default web browser will automatically open a new page at `http://localhost:3000/blog`

> Changing any files in the project will trigger a new compilation of the website.  You will need to manually refresh the browser page if you kept it open.

## Configure the site

The configuration defines the site title (banner heading), author (copyright message), description (not sure where this is used).

`content/config.edn` is the configuration file for the generated site

```
 :site-title           "Practicalli"
 :author               "Practicalli"
 :description          "Discovering the fun in Functional Programming with Clojure"
 :site-url             "http://practical.li/"
```


### Enable live evaluation with Klipse

Make your sample code executable and interactive to the user by enabling Klipse in Cryogen. Klipse provides live evaluation for a number of programming language.

Enable Klipse by defining a specific CSS selector and use that name when defining a code block, e.g. ```klipse-clj```

```
 :klipse               {:settings {:selector         ".klipse-clj"
                                   :selector-reagent ".klipse-reagent"}}
```

> Example [config.edn file](https://github.com/practicalli/blog-content/blob/master/content/config.edn) from the practicalli/blog-content GitHub repository


## Version control

A `.gitignore` file is created when using the cryogen Leiningen template to create a project.

This contains the `/public/` pattern to exclude the generated website, as well as the common patterns for a Leiningen project.

A separate git repository is used to deploy the website (to GitHub pages).

```
pom.xml
pom.xml.asc
*jar
/lib/
/classes/
/target/
/checkouts/
.lein-deps-sum
.lein-repl-history
.lein-plugins/
.lein-failures
/public/
```


## Writing posts

Posts can be written in either markdown or asciidoc.  Markdown is the default and all posts should be placed inthe `content/md/` directory.

The filename can be prefixed with the date of the post, however, I find it more flexible to specify the date in the post metadata header as if you change the date then the URL of the post will remain the same.  This is really handy if you need to update the post and need to reflect that in the date, or if you had planned to publish the post a few weeks in the future and then realise its ready sooner.

### Post header - metadata

The start of each post is a Clojure hash-map, `{}` containing metadata for the specfic blog

`:title` and `:layout` are mandatory keys, the rest are optional.  You can also define your own custom keys which can be used in the selma templates, for example `:topic`

* `:title`   The `h1` title used for the blog post
* `:layout`  A keyword corresponding to an HTML file under themes/{theme}/html.
* `:date`    The published date of the blog  (future blogs can be hidden)
* `:author`  The name of the post author as a string, displayed at the top of the post in the default theme.
* `:tags`    Tags associated with the blog, as a vector of strings e.g. ["clojure" "cryogen"]
* `:klipse`  Enable live evaluation of code in the post (see live evaluation with Klipse)
* `:toc`     Include a table of contents at the top of the page, with links to all the headings in the post
* `:draft?`  `true` will skip this post from the static site generation
* `:topic`   A custom key I use to manage a topic image displayed on each post (theme development will be covered in a future post)


## Deploying the site to GitHub pages

GitHub pages is a free static site hosting service and we can deploy the cryogen website by a git push.

Create a repository in either a user account or GitHub organisation (eg. using the GitHub website).

An unsophisticated script is used to deploy the generated website.  The script creates a Git repository in the `public` directory, all files are committed with a generic message, a remote repository added and the content pushed.

```
cd public/blog && rm -rf .git && git init && git add . && git commit -m "initial commit" && git branch -m master gh-pages && git remote add practicalli git@github.com:practicalli/blog.git && git push -f practicalli gh-pages
```

Edit the `deploy-to-gh-pages` script and update the URL of the GitHub repository created to host the website.

If the website is not displayed, check the GitHub repository settings and ensure the `gh-pages` is set.

[GitHub repository settings - GitHub pages gh-branch selected](/images/github-settings-github-pages-gh-pages-branch.png)

> Practicalli recommends using two repositories, one for the cryogen project and another for the generated website.
>
> If you are creating a website for a software project or library, then it may be useful to generate the cryogen website the `docs` directory and set that as the GitHub pages source.

### Prevent GitHub pages Jekyll compilation

A Jekyll process runs every time a change is pushed to a GitHub pages branch.  As Cryogen generates the finished website Jekyll processing is not required and it can be switch it off.

Add an empty file called `.nojekyll` to the `content` directory.

Edit the `config.edn` configuration file and add the `.nojekyll` file to the resources.  This ensures the `.nojekyll` file is copied over to the generated website in the `public` directory.

```
 :resources            ["images" ".nojekyll"]
```
