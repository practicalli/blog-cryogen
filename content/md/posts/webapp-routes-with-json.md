{:title "Clojure Webapp routing and APIs with JSON"
 :layout :post
 :date "2019-11-23"
 :topic "clojure-cli"
 :tags  ["webapps" "apis" "json" "clojure-cli" "tools-deps"]}

Defining routes for a Clojure webapps is easy with the Compojure library and we can also serve JSON to create a simple API.  All this is built on the [Clojure webserver we built in the previous article](clojure-web-server-cli-tools-deps-edn.html).

Compojure has a `defroutes` macro that provides a simple way to define routes and there are other convienience functions that make routing very straight forward.

We can also add transit and other libraries to help manage JSON.

> All the code for this project is at [practicalli/simple-api repository](https://github.com/practicalli/simple-api) on GitHub.

<!-- more -->

## Understanding compojure

Compojure is a library to define a collection of routes and associate each route with a handler.

* A route is made from an http method and a specific web address or resource address, such as `hello.html` or `results.json`
* http method switching - running different code based on the HTTP method (`GET`, `POST`, `PUT`, `DELETE`)
* A handler is simply a function that takes a request map as an argument by default.

Compojure also has convienience functions that make ring responses easier to generate, eg. `response`, `not-found`.

![Routing with Ring and Compojure](/images/clojure-ring-adaptor-middleware-route-handler-overview.png)

[Practicalli Clojure Webapps](https://practicalli.github.io/clojure-webapps/compojure/) contains more exmples of compojure.

## Adding compojure to deps.edn

Take the simple-api-server project from last time

To find latest version we can look up [compojure on clojars.org](https://clojars.org/compojure).

```clojure
{:paths ["resources" "src"]

 :deps
 {org.clojure/clojure {:mvn/version "1.10.1"}
  http-kit            {:mvn/version "2.4.0-alpha4"}
  compojure           {:mvn/version "1.6.1"}}

 :aliases
 {,,,}}
```

## Namespace require

To use functions from the Compojure library we include them in the namespace declaration.

The `:require` directive allows us to specify namespaces who's functions are then available.

* `compojure.core` provides the defroutes macro, so we can define routes easily.  It also provides the GET and POST macros to match the different types of requests.

* `compojure.route` provides the `not-found` function that returns a standard 404 error.  This function would be replaced by a website template with hiccup or selma before going live with the webapp.

Edit `src/practicalli.simple-api-server.clj` and add the two namespaces.

```clojure
(ns practicalli.simple-api-server
  (:gen-class)
  (:require [org.httpkit.server :as server]
            [compojure.core :refer [defroutes GET POST]]
            [compojure.route :refer [not-found]]))
```


## Tweaking the -main function

Update the `run-server` function call to use the `webapp` created with `defroutes`

```clojure

(defn -main
  "Start a httpkit server with a specific port
  #' enables hot-reload of the handler function and anything that code calls"
  [& {:keys [ip port]
      :or   {ip   "0.0.0.0"
             port 8000}}]
  (println "INFO: Starting httpkit server - listening on: " (str "http://" ip ":" port))
  (reset! server (server/run-server #'webapp {:port port})))
```


## Starting and stopping the server

Specify a specific port when starting the server

```clojure
(-main :port 8888)
;; => "Port: 8888, timeout 100"
```
Or simply start the server on the default port using `(-main)`

Stopping the server is easy, just call the `stop-server` functions without arguments.

```clojure
(stop-server)
```

> It is necessary to stop and start the server when adding dependencies or chaining the main function definition.
>
> Changes made to the webapp function or anything that function calls can be evaluated to update the REPL, so it is not necessary to stop and starting the web server.


## Adding Routes with Compojure

`defroutes` function is a macro to provide a simple way to define all the routes.  There is only one `defroutes` function per web application and all requests recieved by the server go through this function.

> A series of nested `if` functions or the `cond` function could be used to define routes, although this is not very efficient code.

Each route in defroutes consists of:

* an http method
* URL/URI address
* request map (which can be destructured)
* a handler (or just some content for the body)

Here is a GET request for the main website page.  This would be the same as a browser requesting the website page.

A simple piece of html code is used as the response.  This html code is associated with the `:body` of re response hash-map.

```clojure
(defroutes webapp
  (GET "/" [] "<h1>Hello World</h1>"))
```

The resulting response hash-map would look as follows

```clojure
{:headers {}
 :status 200
 :body "<h1>Hello World</h1>"}
```

### Convenience handlers

The `response` function provides a successful response (status 200) that includes the message passed as an argument.

In deps.edn add the `ring.util.response` namespace, to give access to the `response` funciton.

```clojure
 [ring.util.response :refer [response]]
```

We can use the `response` function as part of the `defroutes`.

```clojure
(defroutes app
  (GET "/" [] (response "Hello clojure world"))

  ,,,)
```

Or we can include the `response` call in a separate handler.  A separate handler is more appropriate when there is a notable amount of content included in the message.  For example, if you are using a template for the return message.

The message forms the value of the :body keyword in the response map, so its quite flexible as to what can be bound to that `:body` key.

```clojure
(defn hello-world
  "A simple hello world handler,
  using ring.util.response"
  [request]
  (response "hello clojure world, from ring response."))
```

In the REPL we can call this function to see what its returning


```clojure
(hello-world {})
;; => {:status 200, :headers {}, :body "Hello Clojure World, from ring response."}
```

If no route matches the incoming request, then the browser will display its own error page.

Using the `not-found` function from `compojure.route` a custom error message can be returned instead.

```clojure
(defroutes webapp
  (route/not-found "<h1>I am very sorry, but the page you asked for does not exist.</h1>")
  )
```

Using handlers rather than just returning text


```clojure

(defroutes webapp
  (GET "/"               [] hello-html)
  (GET "/hello-response" [] hello-world)

  (not-found "<h1>Page not found, I am very sorry.</h1>"))
```


```clojure
(defn hello-world
  "A simple hello world handler,
  using ring.util.response"
  [_]
  (response "Hello Clojure World, from ring response."))

```

Calling the `hello-world` function with an empty request hash-map, `{}` we can see the response hash-map this handler function returns


```clojure
(hello-world {})
;; => {:status 200, :headers {}, :body "Hello Clojure World, from ring response."}
```



### Viewing the full Request information

Compojure has a request dump function that gives a much nicer output than our initial request-info function. The dump funtion also seperates the default response keys with any additional keys provided by the URL.

```clojure
(:require
          [ring.handler.dump :refer [handle-dump]])
```

Add a route that calls the `handle-dump` functions

```clojure
(GET "/request-info" [] handle-dump)
```

## Generating JSON from Clojure

[`clojure/data.json`](https://github.com/clojure/data.json) is a library for translating between Clojure data structures and the JavaScript Object Notation `JSON`

Clojure hash-maps and vectors can be used to create a detailed data structure that can be converted into JSON.

Add the data.json library as a dependency in the `deps.edn` file.

```clojure
 org.clojure/data.json {:mvn/version "0.2.7"}
```

Then require clojure.data.json namespace in the `ns` declaration.

```clojure
(ns example
  (:require [clojure.data.json :as json]))
```

To convert to/from JSON strings, use `json/write-str` and `json/read-str` functions.

```clojure
(json/write-str {:a 1 :b 2})
;;=> "{\"a\":1,\"b\":2}"

(json/read-str "{\"a\":1,\"b\":2}")
;;=> {"a" 1, "b" 2}
```

Converting Clojure data into JSON is lossy as you loose some of the type information.

Other approaches include

* [ring-json](https://github.com/ring-clojure/ring-json) for handling JSON requests and responses
* [ring-json-response](https://github.com/weavejester/ring-json-response) for returning JSON responses from a ring handler



## Creating a JSON API

Returning JSON from APIs is a common approach as JSON is a very lightweight data format that is supported by many languages.  So JSON is usually very simple when it comes to data integration.


Add a scores routes that returns JSON, specifying the appropriate content type.

```clojure
(defn scores
  "Returns the current scoreboard as JSON"
  [_]
  (println "Calling the scoreboard handler...")
  {:headers {"Content-type" "application/json"}
   :status  (:OK http-status-codes)
   :body    (json/write-str {:players
                             [{:name "johnny-be-doomed" :high-score 1000001}
                              {:name "jenny-jetpack" :high-score 23452345}]})})
```

This will return JSON in our browser

![Clojure Webapps - JSON from an API](/images/clojure-webapp-api-json-results-scoreboard.png)


## Defining a data model

Assuming we use the data in several handler functions, we should define that data separately and refer to it by name.

```clojure
(def scoreboard
  {:players
   [{:name "johnny-be-doomed" :high-score 1000001}
    {:name "jenny-jetpack" :high-score 23452345}
    {:name "fred" :high-score 23452345}]})
```
## Specific player score with URL parameters


To get the score for just a single player, use [variable path elements](https://practicalli.github.io/clojure-webapps/compojure/variable-path-elements.html) as part of the request address.

To get a specific players name, add the `:name` element.

```clojure
(defroutes webapp

  (GET "/hello/:name" [] player-score)

  )
```

## Define a player-score handler function

Define a `player-score` handler function that only returns the score for a particular player.

To get the name of the player from the request hash-map, we can use `get-in` to walk the request hash-map.  The player name will be in `{:route-params {:name "player-name"}}`

```clojure
(get-in request [:route-params :name])
```


To get the score for a particular player, we filter the scoreboard data structure by the name of the player.  For example, if we wanted the score for the player `"fred"`:

```clojure
(filter (fn [player-entry]
          (= "fred" (:name player-entry)))
        (get scoreboard :players))
```

We can use these expressions to build our `player-score` handler.

```clojure
(defn player-score
  "Returns the current scoreboard as JSON"
  [request]
  (println "Calling the player handler...")
  (let [player (get-in request [:route-params :name])]
    {:headers {"Content-type" "application/json"}
     :status  (:OK http-status-codes)
     :body    (json/write-str
                (filter (fn [player-entry]
                          (= player (:name player-entry)))
                        (get scoreboard :players)))}))
```

Now we can call our scoreboard api with a specific player name, for example http://localhost:8000/player/:jenny-jetpack and just their scores are returned.

If there are going to be multiple scores, then we could sort them first using `sort-by :high-score dec` on the results of `filter` to give a list of score entries with the highest score first.

Or we could leave it to the client to process the scores in what ever way they wish.


## Summary

Taking the simple web server and adding Compojure allows us to quickly build a web application or API.

Generating JSON from Clojure data structures is very easy.  Converting JSON into Clojure data structures is just as easy and provides a more efficient way of working with any data recieved in JSON format.

There are several libraries for transforming between JSON and Clojure, including [Cheshire](https://github.com/dakrone/cheshire), [jsonista](https://github.com/metosin/jsonista) and Transit.

* [JSON Serialization for APIs in Clojure](https://purelyfunctional.tv/mini-guide/json-serialization-api-clojure/)


Adding specifications is a clean way to ensure a robust API service, checking the type of information being sent and received is of the correct form. `clojure.alpha.spec` and `pulmatic/schema` are two libraries that will provide this kind of checking.

[Sean Corfield has a usermanager project](https://github.com/seancorfield/usermanager-example) that is a nice example of a project using deps.edn, ring, compojure, selma for web page templates and Component for life-cycle management (starting and stoping services).
