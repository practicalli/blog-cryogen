{:title "Visualising UK Covid19 data with Clojure and Oz"
 :date "2020-03-13"
 :layout :post
 :topic "data-science"
 :tags  ["clojure" "data-science" "oz"]}

Discover how to use Oz, a Clojure library for visualising data, to build a dashboard of information about the Covid19 virus from [available UK data](https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases).

[practicalli/covid19-dashboard](https://github.com/practicalli/covid19-dashboard) contains the code from this article.

Data science is about gathering meaningful data and presenting that data in meaningful ways, enabling business or communities to have tools to better understand a stituation.  Data sets are often flawed and visualisation open to interpretation, so no clear picture is offered about the current Covid19 pandemic.

Covid19 virus is a very serious pandemic affecting the world at present, please stay safe and where possible at home and away from others to help stop the spread of this highly infectious virus.

<!-- more -->

## Examples of visualisations
The UK government provides a [Covid-19 tracker](https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases) of reported cases and is a useful example of a data science dashboard.

![GOV.UK COVID-19 tracker dashboard](/images/data-science-covid19-public-health-england-dashboard.png)

Other excellent dashboard examples include:
* [againstcovid19: Singapore](https://www.againstcovid19.com/singapore/)
* [againstcovid19: Indonesia](https://www.againstcovid19.com/indonesia/dashboard)
* [againstcovid19: Taiwan](https://www.againstcovid19.com/taiwanin/dashboard)
* [againstcovid19: Philippines](https://www.againstcovid19.com/philippines/dashboard)

## Mining for data
Good data can be hard to find and often needs cleaning.  Luckily the UK Government has [shared the data](https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases) used for the Covid-19 tracker.

There are several Excel spreadsheets containing different views of the data

* Daily indicators - used for the headline figures each day
* Daily confirmed cases - data from 29th February to previous day (count each day, cumulative cases, daily deaths, cumulative deaths).


## Creating a Clojure project
Dave L created a very useful sample application you could extend (required Leiningen build tool), or create a new Clojure project

clojure -A:new app practicalli/covid19-dashboard

> [Install Clojure CLI tools and clj-new](http://practicalli.github.io/clojure/getting-started/install-clojure.html)

Add Oz as a dependency in `deps.edn`

```clojure
 :deps
 {org.clojure/clojure {:mvn/version "1.10.1"}

  metasoarous/oz {:mvn/version "1.6.0-alpha6"}}
```
Require Oz in the practicalli.covid19-dashboard namespace

```clojure
(ns practicalli.covid19-dashboard
  (:gen-class)
  (:require [oz.core :as oz]))
```

Finally add an explicitly call to the Oz server.  This will listen via websockets for views to display.

```clojure
(oz/start-server!)
```

![Clojure - Oz visualization - waiting for first spec to load](/images/clojure-oz-start-server-website-placeholder.png)

The message suggests that a plot function (e.g. `oz/view!`) will start the server if not explicitly called.

## Create a view with Mock data

```clojure
(defn play-data [& names]
  (for [n names
        i (range 20)]
    {:time i :item n :quantity (+ (Math/pow (* i (count n)) 0.8) (rand-int (count n)))}))
```


## Extracting the data
The data is in Microsoft Excel files, even though its just simple table data.  I opened the files in LibreOffice and saved them as plain text csv files.


## Transforming the data for visualisation
The data needs to be transformed into a structure that can be used to visualise the data.

This adds

`:data` wraps the original sequence of data in a hash-map with a key named `:values`.

`:mark` is the type of visualisation to use, e.g. bar chart, line graph, etc.

`:encoding` defines how the data will be presented, matching the `:field` with the data keyword and the


## Creating Oz views
Oz is based on the grammar of interactive graphics as defined for [Vega-lite specifications](https://vega.github.io/vega-lite/docs/).

![Oz - Grammar of interactive graphics](/images/oz-grammar-of-graphics-data-types.png)

Which can generate a range of graphs and plots

![Oz - Grammar of interactive graphics](/images/oz-grammar-of-graphics-graph-types.png)

Watch [Vega Lite: A Grammar of Interactive Graphics](https://www.youtube.com/watch?v=9uaHRWj04D4) for more examples (more examples will be covered in later articles here).

### Line graph
Show the cumulative cases for each location as a separate line on the graph

```clojure
(def line-plot
  "Transform data for visualization"
  {:mark     "line"
   :data     {:values (mock-data-set "England" "Scotland" "Wales" "Northern Ireland")}
   :encoding {:x     {:field "day" :type "quantitative"}
              :y     {:field "cases" :type "quantitative"}
              :color {:field "location" :type "nominal"}}})

(oz/view! line-plot)
```

The encoding field names match the keywords in the data values


### Histogram - bar chart
A bar chart showing a cases comparison between locations on the same day.

```clojure
(def stacked-bar
  {:mark     "bar"
   :data     {:values (mock-data-set "England" "Scotland" "Wales" "Norther Ireland")}
   :encoding {:x     {:field "day"
                      :type  "ordinal"}
              :y     {:aggregate "location"
                      :field     "cases"
                      :type      "quantitative"}
              :color {:field "location"
                      :type  "nominal"}}})

(oz/view! stacked-bar)
```

## Creating a dashboard
Once all the views are created and recieving the relevant data, its a simple matter to create a dashboard using the hiccup style syntax that is common in Clojure.

Hiccup syntax is the clojure approach to representing HTML content and structure,  along with CSS styles.  Instead of open and closing tags, a Clojure vector respresents the scope of a tag and a keyword represents the type of tag.
```clojure
[:div
  [:h1 "Title of the Dashboard"]]
```

Lets add the views we created already created.

```clojure
(def dashboard
  [:div
   [:h1 "COVID19 Tracker - Mock data"]
   [:p "Mock data to experiment with types of views"]
   [:div {:style {:display "flex" :flex-direction "row"}}
    [:vega-lite line-plot]
    [:vega-lite stacked-bar]]])

(oz/view! dashboard)
```


## Resources
* [Vega-Lite online editor with examples](https://vega.github.io/editor/#/custom/vega-lite) - a quick way to try out visualisations and see example code
* [Vega-Lite documenttion](https://vega.github.io/vega-lite/docs/)
* [Vega slack community self-signup](https://communityinviter.com/apps/vega-js/join)
