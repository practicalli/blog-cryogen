{:title "Web Scraping with Clojure - an overview"
 :date "2022-04-19"
 :draft? true
 :layout :post
 :topic "clojure"
 :tags  ["clojure" "web-scraper"]}

The initial challenge for data scientists and data engineers is to obtain a meaningful data sets to work with. Unfortunately not every source of data is organised into a clean API or a simple to work with structured data format.

Scraping web pages is a way to extract unstructured data and there are many libraries that can be used from Clojure.

## Basic scraping

Using slurp and then lots of string manipulation and regex.


a concise and idiomatic way to query a HTML document. Testing and any kind of scraping come to mind as use cases.

The main thing I need is quickly selecting elements based on CSS and/or Xpath.

Conceptual code...

```clojure
(require '[imaginary-html-lib :as foo])

(def doc (foo/parse "<div class='hello'>Hello, <em>world<em></div>"))

(foo/select-css doc ".hello em") ;;=> #HTML[<em>world</em>]

(foo/text *1) ;;=> "world"
```

## Reaver
[Reaver](https://github.com/mischov/reaver) is a Clojure library wrapping Jsoup and designed for extracting data out of HTML and into EDN/Clojure.

Here is how one might scrape the headlines and links from Hacker News into a Clojure map

```clojure
(require '[reaver :refer [parse extract-from text attr]])

; Reaver doesn't tell you how fetch your HTML. Use `slurp` or
; aleph or clj-http or what-have-you.
(def hacker-news (slurp "https://news.ycombinator.com/"))

; Extract the headlines and urls from the HTML into a seq of maps.
(extract-from (parse hacker-news) ".itemlist .athing"
              [:headline :url]
              ".title > a" text
              ".title > a" (attr :href))

```

## Enlive
Enlive defines web page templates in HTML. Clojure code locates selectors in these templates, the HTML and CSS tags, to generate specific web page content. Specific parts of the HTML templates are updated by looking up selectors and substitute specific content.

Using selectors also makes Enlive a very capable webscraper, picking out specific content from web pages and converting it into Clojure data.

```clojure
(require '[net.cgrand.enlive-html :as enlive])

(let [doc (enlive/html-snippet "<div class='hello'>Hello, <em>world<em></div>")
      em  (enlive/select doc [:.hello :em])]
  (enlive/texts em))
```


## [Hickory](https://github.com/davidsantiago/hickory)

When the HTML you are scraping gets more complicated or you just have to do lots more, then you may benefit from using Hickory instead of Enlive.

* clearer and easier to compose than enlive for more complex selector expressions
* supports clojure/clojurescript
* supports selectors and zippers
* offers conversion to hiccup format for output
* increased performance for larger tasks

Example

```clojure
;; boot repl
(set-env! :dependencies '[[hickory "0.7.1"]])

(require '[hickory.select :as s]
         '[hickory.core :as hc])

(def my-doc
  (-> "<div class='hello'>Hello, <em>world</em></div>"
      hc/parse
      hc/as-hickory))

(s/select
  (s/child (s/class "hello")
           (s/tag :em))
  my-doc)

;; [{:type :element, :attrs nil, :tag :em, :content ["world"]}]
```
Note that I modified your HTML string slightly, I think the two opening <em> tags were probably unintented?


hickory looks a little more complicated for your simple example, but I find it . Some other things I like about it:


Hickory builds on top of JSoup ?

Reference
* [Hickory on Clojars](https://clojars.org/hickory)


## JSoup - Java Interop

JSoup is commented on as being very fast

Java Interop from Clojure means JSoup is fairly easy to use.  One approach is to create a Selectable protocol.

```clojure
(ns foo
  (:import [org.jsoup Jsoup]
           [org.jsoup.nodes Element Node]
           [org.jsoup.select Elements]))

(defprotocol Selectable
  "Protocol for selecting data from DOM-like data structures"
  (attr [_ k] "Return the value of the provided HTML attribute")
  (text [_] "Return the text for this element and all child elements")
  (own-text [_] "Return the text for just this element"))

(extend-type Elements
  Selectable
  (attr [this k]
    (.attr this (name k)))

  (text [this]
    (.text this))

  (own-text [this]
    (.text this)))

(extend-type Element
  Selectable
  (attr [this k]
    (.attr this (name k)))

  (text [this]
    (.text this))

  (own-text [this]
    (.ownText this)))
```


<!-- ## Using core.async and transducers -->

<!-- ? -->


## Scraping pages that require a javascript runtime to render

[Sparkledriver](https://github.com/jackrusher/sparkledriver)



## Sites to scrape

Public information sites
Open data sites that do not provide an api (usually web pages of data in semi-tabular form)

Any sites with useful information that do not have an API for their data.


## Things to consider

* Be considerate and dont scrape sites that explicitly request you do not.
* Contact the owners of the page and ask if you can access the data
 * Honor norobots files - is this still a thing
Avoid constantly hitting the same web pages
*  Minimise the hits you make to a website.  Using a `def` expression to bind the results of a call to a website will cache those results for the life of the REPL.
* Download the web pages locally if they do not change very often - use a web tool to check how often they change
* Cache the data in def expression
