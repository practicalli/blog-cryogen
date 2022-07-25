{:title "Consuming APIs from Clojure"
 :layout :post
 :date "2019-11-30"
 :topic "clojure"
 :tags  ["clojure" "apis" "clj-http" "httpkit"]}


When getting results from API calls, its very common to recieve data in JavaScript Object Notation (JSON).

Once we have the JSON data, it is converted to a Clojure data structure to use the hundreds of functions in clojure.core that can readily transform the shape of that data.

We can process this with the clojure.data.json library and community projects including cheshire and transit.

Clojure has several ways to get any web resource, from a simple function call to `slurp`, via clj-http and httpkit clients. There are useful tools to help you test APIs, such as [Postman](https://www.getpostman.com/) and Swagger.

> Article updated on 25th July 2022

<!-- more -->

## Creating a project

Create a project to keep code and evaluation results from executing code, or run this code in a REPL session.

Using `:project/new` from [practicalli/cloure-deps-edn](https://github.com/practicalli/clojure-deps-edn)

```shell
clojure -T:project/new :template app :name practicalli/simple-api-client
```

Or clone the [practicalli/simple-api-client](https://github.com/practicalli/simple-api-client) repository.


## Getting content

The `slurp` function is a convenient way of getting content from the web, or from local files too.  `Slurp` is defined in `clojure.core` so is always available in Clojure.

For example, we can get a book from Project Guttenberg  very easily.

```clojure
(slurp "http://www.gutenberg.org/cache/epub/844/pg844.txt")
```

This returns the whole text of "The Importance of Being Earnest" book as a single string.

![Clojure slurp - getting a book from project Guttenberg](/images/clojure-webapps-client-slurp-guttenberg-result.png)


## Getting an API

A simple scoreboard API was deployed in episodes [16](https://www.youtube.com/watch?v=U6OAdQqWegQ&list=PLpr9V-R8ZxiDjyU7cQYWOEFBDR1t7t0wv&index=19&t=0s) and [17](https://www.youtube.com/watch?v=Bna3hxgO97k&list=PLpr9V-R8ZxiDjyU7cQYWOEFBDR1t7t0wv&index=20&t=0s) of the Clojure study group.

All the [API documentation is published within the website](https://game-scoreboard-api.herokuapp.com/index.html) and provides an interactive dashboard to test API calls.  This is provided by the Swagger library.


A random score is returned by calling the `game/random-score` URL.  This generates a random player-id and score and adds it to the scoreboard.

```clojure
(slurp "https://game-scoreboard-api.herokuapp.com/game/random-score")

;; => "[{\"player-id\":\"f26fd417-5ac5-4bac-bfda-88342e632ee1\",\"score\":31121164},{\"player-id\":\"0f414b43-d82e-4164-9a31-ec81fac03160\",\"score\":95542596},{\"player-id\":\"9b9eada5-8a9a-4115-aa58-2567688d4055\",\"score\":29895185}]"
```

The current scoreboard can be viewed at:

```clojure
(slurp "https://game-scoreboard-api.herokuapp.com/game/scoreboard")

;; => "[{\"player-id\":\"f26fd417-5ac5-4bac-bfda-88342e632ee1\",\"score\":31121164},{\"player-id\":\"0f414b43-d82e-4164-9a31-ec81fac03160\",\"score\":95542596},{\"player-id\":\"9b9eada5-8a9a-4115-aa58-2567688d4055\",\"score\":29895185}]"
```

> The scores are saved into an Clojure atom, so each time the application restarts the scoreboard reset to empty.  If the application is not used for 30 minutes, then Heroku will shut down the application (the application is not on an Heroku paid plan, just on free monthly credits).

Using `slurp` the data returned from the API is placed into a string, which is not a Clojure collection (although some Clojure functions will treat a string as a collection of characters).

As its a string, any special characters contained within are escaped using the `\` to ensure the string can be processed correctly.  For example, where the data returned contains a double quote, `"player-name"`, then each double quote is escaped.  This is adding a transformation to the data that isn't very useful.


## Converting to Clojure

In the simple server we used `clojure.data` library to generate JavaScript Object Notation from a Clojure data structure, specifically a Clojure hash-map.

We can use `clojure.data.json` to turn our JSON string into a Clojure data structure.

Add `clojure.data.json` as a dependency to the project.

Edit `deps.edn` and add `org.clojure/data.json {:mvn/version "0.2.7"}` to the `:deps` map.

```clojure
:deps
 {org.clojure/clojure   {:mvn/version "1.11.1"}
  org.clojure/data.json {:mvn/version "2.4.0"}}
```

Then add `clojure.data.json` to the project namespace.

Edit the `src/practicalli/simple-api-client.clj` and require the `clojure.data.json` namespace

```clojure
(ns practicalli.simple-api-client
  (:gen-class)
  (:require [clojure.data.json :as json]))
```

Now use the `read-str` function to read in the JSON data that was returned by the response as a string.

Write the following function call in `src/practicalli/simple-api-client.clj` or start a REPL using `clj` or `clojure -A:rebel` if rebel readline is installed.

```clojure
(json/read-str
  (slurp "https://game-scoreboard-api.herokuapp.com/game/scoreboard"))
;; => [{"player-id" "0724e6cc-5c04-4a61-b3b6-d10624feed0e", "score" 41726706}
;;     {"player-id" "36b521b2-078a-4581-9705-fa54fc1e89b6", "score" 70622257}
;;     {"player-id" "2e9da877-4911-4658-b964-b5684b858921", "score" 92581379}
;;     {"player-id" "2c044a04-772f-41cf-a4f5-19e8e8d76e8c", "score" 4338875}]
```
From the value returned you can see that this is a Clojure data structure.  It is a vector of 4 hash-maps.

This data is much nicer to work with.


## GET requests with clj-http or httpkit client

[clj-http](https://github.com/dakrone/clj-http) and httpkit client are libraries that send a http request and return all the values of the http response.

httpkit client uses the same API at clj-http, so the following code should work with either library.

Both these libraries provide access to the full http response information using the ring approach of putting http data into a hash-map. So we can use more than just the body of the response give by slurp.

As we used httpkit library to build a simple API server, then we will use httpkit client namespace as its part of the httpkit library that was downloaded when we built the simple API server (if you didnt build the server, the library will download when you run the repl for this project).

Edit the `deps.edn` file and add the httpkit dependency

```clojure
:deps
 {org.clojure/clojure   {:mvn/version "1.11.1"}
  org.clojure/data.json {:mvn/version "2.4.0"}
  http-kit              {:mvn/version "2.6.0"}}
```

Edit `src/practicalli/simple-api-client.clj` and add the httpkit client namespace to the project

```clojure
(ns practicalli.simple-api-client
  (:gen-class)
  (:require [clojure.data.json :as json]
            [org.httpkit.client :as client]))
```

Lets start with using httpkit client to get a web page, in this case the front page of the Practicalli blog.


Write the following function call in `src/practicalli/simple-api-client.clj` or start a REPL using `clojure -M:repl/rebel` (alias from [practicalli/cloure-deps-edn](https://github.com/practicalli/clojure-deps-edn))

```clojure
(client/get "https://practicalli.github.io/blog/")
;; => #org.httpkit.client/deadlock-guard/reify--5883[{:status :pending, :val nil} 0x55598167]
```
What has happened here?

`client/get` returns a promise, so we have to dereference it to get the value. `deref` resolves the promise and we get a hash-map as the result

```clojure
(deref (client/get "https://practicalli.github.io/blog/"))
```

`@` is the short form syntax for `deref`, its commonly used for promises, atoms, refs, etc.

```clojure
@(client/get "https://practicalli.github.io/blog/")
```

If you were scraping the web, the `:body` key would give you the html from the web page

```clojure
(get
  @(client/get "https://practicalli.github.io/blog/")
  :body)
```

As we can use a keyword as a function we can simplify the code

```clojure
(:body
 @(client/get "https://practicalli.github.io/blog/"))
```

Now try httpkit client with the Game Scoreboard API:

```clojure
@(client/get "https://game-scoreboard-api.herokuapp.com/game/scoreboard")
;; => {:opts {:method :get, :url "https://game-scoreboard-api.herokuapp.com/game/scoreboard"}, :body "[{\"player-id\":\"e8603a88-379f-44a9-8e70-7c822228e8f4\",\"score\":7044673}]", :headers {:connection "keep-alive", :content-length "70", :content-type "application/json; charset=utf-8", :date "Fri, 29 Nov 2019 19:22:56 GMT", :server "Jetty(9.2.21.v20170120)", :via "1.1 vegur"}, :status 200}
```

This gives a lot of information about the response. If we just want the JSON packet, its in the `:body`

```clojure
(:body
 @(client/get "https://game-scoreboard-api.herokuapp.com/game/scoreboard" {:accept :json}))
;; => "[{\"player-id\":\"e8603a88-379f-44a9-8e70-7c822228e8f4\",\"score\":7044673}]"
```


## Creating a simple API status checker

With http client we retrieve all the data of the response. In that data is a `:status` key that is associated with the HTTP response code, eg. 200 for response OK.

The `keys` function in `clojure.core` shows all the top level keys of a hash-map.  So we can use this on the response to see the available keys.

```clojure
(keys
  @(client/get "https://game-scoreboard-api.herokuapp.com/game/scoreboard" {:accept :json}))
```

`:status` is a top level key in the response hash-map, so we can use `:status` as a function call with the hash-map as an argument, returning just the value of `:status`

```clojure
(:status
 @(client/get "https://game-scoreboard-api.herokuapp.com/game/scoreboard" {:accept :json}))
```

Now we have the HTTP code from the `:status` key, we can use it to check if the API is working correctly.

Create a `-main` function to check the status and return a message

```clojure
(defn -main [& args]
  (println "Checking Game Scoreboard API")
  (let [response @(client/get "https://game-scoreboard-api.herokuapp.com/game/scoreboard"
                              {:accept :json})]

    (if (= 200 (:status response))
      (println "Game Scoreboard status is OK")
      (println "Warning: status: " status))))
```

The project can then be run by `clojure -M -m practicalli/simple-api-client`.

To use the project as a simple API monitor, you can run this command as a cron job or other type of batch process that runs regularly.


## Trying APIs with Postman

If you are working with an unfamiliar API or one that is not self-documented with the Swagger library.  Tools like [Postman](https://www.getpostman.com/) are a useful way to experiment with API's without having to set up any code.

![Clojure Webapps - API testing with Postman - random score results](/images/clojure-webapps-api-postman-scoreboard-random-score-results.png)


## Summary

Using `slurp` is quite a blunt tool and only returns the body of the request.  `slurp` is useful for unstructured content or data you can easily work with as a string, such as the text of a website or book.

> The enlive library has many useful functions if you are [scraping the web](http://masnun.com/2016/03/20/web-scraping-with-clojure.html) for content.  [hickory](https://github.com/davidsantiago/hickory) is a library for parsing HTML into Clojure data structures, so is also useful for processing HTML content.
>
> ClojureScript does not implement the `slurp` function.

Using clj-http and httpkit client, we can work with the whole HTTP request and have access to the meta-data of the request as well as the body.

Using clojure.data is a simple way to transform JSON into Clojure (and Clojure into JSON).  Libraries such as Cheshire and Transit offer more transformation tools and may be more useful for highly nested data transformation.

Once the data is in Clojure we can use all the functions in Clojure core (and community libraries) to manipulate and transform that data and run our queries and logic over them, making it really easy to get the results we are looking for.

## References

* [ring-swagger](https://github.com/metosin/ring-swagger)
* [compojure-api](https://github.com/metosin/compojure-api) - extending compojure to make schema based APIs
* [spec-tools](https://github.com/metosin/spec-tools) - Clojure/Script utilities on top of clojure.spec, including spec-swagger.
* [most common word from a novel](https://gist.github.com/jr0cket/f68f6317e6ff7cd82a355fa0a02af0f3) - code example of using slurp to access a Project Guttenberg book.
* [httpkit client](https://www.http-kit.org/client.html) - with example code
* [clj-http library](https://github.com/dakrone/clj-http) - an HTTP library wrapping Apache HttpComponents client.  Project page and documentation.
