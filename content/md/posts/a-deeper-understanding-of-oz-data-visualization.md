{:title "A deeper understanding of data visualization Clojure and Oz"
 :date "2022-04-04"
 :layout :post
 :draft? true
 :topic "data-science"
 :tags  ["clojure" "data-science" "oz"]}

Oz is an excellent Clojure library for data visualisation, using the [Vega Lite Grammar for defining interactive graphics](https://vega.github.io/editor/#/custom/vega-lite)

Oz (via Vega Lite) define a language for graphical representation of data without polluting the data itself with knowledge of how it should be rendered.

Data science data sets or any other data is typically wrangled into a useful shape.  In Clojure this is a vector of hash-maps that share the same keys.

To get a better understanding of Oz, a range of visualisations will be created from different types of data, transforming that data with common Clojure tools where necessary.

[practicalli/oz-visualization](https://github.com/practicalli/oz-visualisations) GitHub repository contains the code from this article.

Previously Oz was used to build a dashboard of information about the Covid19 virus from [available UK data](https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases).

<!-- more -->

<!-- TODO: define a dataset to show off basic features of Oz -->
<!-- TODO: use data set from UK government to create Covid19 dashboard
     - then generalise the dashboard for different countries
     - may required additional data wrangling -->

## Creating a Clojure project
Create a new Clojure project using Clojure CLI tools, clj-new and the  [Practicalli Clojure deps.edn](http://practicalli.github.io/clojure/getting-started/install-clojure.html) user level configuration

```shell
clojure -X:project/new :template lib :name practicalli/oz-visualization
```

> `:project/new` alias included in [Practicalli Clojure deps.edn](http://practicalli.github.io/clojure/getting-started/install-clojure.html) user level configuration for Clojure CLI tools

Add Oz as a dependency in `deps.edn` file within the new project

```clojure
:deps
{org.clojure/clojure {:mvn/version "1.10.3"}
 metasoarous/oz {:mvn/version "1.6.0-alpha34"}}
```

Require Oz in the practicalli.oz-visualization namespace

```clojure
(ns practicalli.oz-visualization
  (:require [oz.core :as oz]))
```

Finally add an explicitly call to the Oz server.  This will listen via websockets for views to display.

```clojure
(oz/start-server!)
```

![Clojure - Oz visualization - waiting for first spec to load](/images/clojure-oz-start-server-website-placeholder.png)

The message suggests that a plot function (e.g. `oz/view!`) will start the server if not explicitly called.


## Generating weather data

There are numerous weather data sources published openly, however some investigation may be required to understand the structure of a particular data source.

Clojure can very easily generate some mock data and in this way you can control the data you are working with.

Integers are easy with rand-int

## Define a function to generate weather

```clojure
(defn random-temperature
  "Generated a random temperature given a miniumum and maximum"
  [minimum maximum]
  (+ (rand-int (- maximum minimum))
     minimum))
```

To get a specific range just need a little tweaking



Put all this together in a date range generator

```clojure
(defn date-range
  [date-range-length]
   (take date-range-length
        (map simple-date-format (iterate #(.plusDays % 1) (java.time.LocalDate/now)))))
```


```clojure
;; data generators
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn mock-temperature-reading
  "Random temperature reading given a minimum and maximum value"
  [minimum maximum]
  (+ (rand-int (- maximum minimum))
     minimum))

(defn mock-precipitation-reading
  "Random precipitation level to one decimal place given a maximum level.
  Generate a random number, multiplying by 10 before rounding to an integer
  to keep the value for the decimal place.  Divide by 10 to create the decimal number"
  [maximum]
  (/ (Math/round (* (rand maximum) 10)) 10.0))



```



## Mining for data
Good data can be hard to find and often needs cleaning.  Luckily the UK Government has [shared the data](https://www.gov.uk/government/publications/covid-19-track-coronavirus-cases) used for the Covid-19 tracker.

There are several Excel spreadsheets containing different views of the data

* Daily indicators - used for the headline figures each day
* Daily confirmed cases - data from 29th February to previous day (count each day, cumulative cases, daily deaths, cumulative deaths).



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
* [Vega-Lite documentation](https://vega.github.io/vega-lite/docs/)
* [Vega slack community self-signup](https://communityinviter.com/apps/vega-js/join)
* [National Centers for Environmental Information](https://www.ncdc.noaa.gov/cdo-web/datasets)
