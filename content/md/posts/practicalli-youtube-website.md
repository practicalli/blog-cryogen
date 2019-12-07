{:title "Practicalli YouTube Website"
 :layout :post
 :date "2019-12-07"
 :topic "clojure"
 :tags  ["clojure" "webapps" "apis" "ring" "compojure" "clj-http" "json"]}

YouTube is great service for sharing your video content across the world.  However, the user experience is highly focused on discovering lots of different content in an adhoc manner.  The user experience is not so great when you wish to curate a series of videos.

YouTube has a very detailed API which can be used to create a website to provide your own user experience, so lets start building a website with Clojure.

All code is available on the [practicalli/youtube-website](https://github.com/practicalli/youtube-website/) repository.

<!-- more -->

<!-- GitHub issue -->
<!-- https://github.com/practicalli/blog-content/issues/36 -->

## Creating a website project

Create a Clojure project using Clojure CLI tools and clj-new

```shell
clojure -A:new app practicalli/youtube-website
```

## Add project dependencies

Edit the `deps.edn` file and add the latest dependencies for the ring, compojure and Clojure data.json libraries

```clojure
 :deps {org.clojure/clojure   {:mvn/version "1.10.1"}
        ring                  {:mvn/version "1.8.0"}
        compojure             {:mvn/version "1.6.1"}
        clj-http              {:mvn/version "3.10.0"}
        org.clojure/data.json {:mvn/version "0.2.7"}}
```

These libraries provide functions for handling http requests (ring, compojure) and working with JSON data (data.json).


## Add the namespaces for ring and compojure

Edit the `src/practicalli/youtube_website.clj` file and add the library namespaces, so we can call functions from those namespaces in our own code.


```clojure
(:require [ring.adapter.jetty :as adapter]
          [ring.util.response :refer [response]]
          [compojure.core     :refer [defroutes GET POST]]
          [compojure.route    :refer [not-found]]
          [clj-http.client    :as http-client]
          [clojure.data.json  :as json])
```

## Add basic routing using compojure

Compojure library provides a simple way to route requests based on HTTP method (GET, POST) and web address.  For now, simple messages are returned using the `response` function from ring.

```clojure
(defroutes webapp
  (GET "/"               [] (response "home-page"))

  (GET "/playlist/:name" [] (response "playlist"))

  (not-found
    "<h1>Page not found, I am very sorry.</h1>"))
```

## Update server start stop

Adding functions to start and stop the Jetty web server without stopping the REPL itself speeds up development.

The `defonce` expression defines a name for the server which runs as soon as defonce is evaluated.

In the REPL, evaluate `(.stop server)` to stop the Jetty embedded server.

Evaluate `(.start server)` to start the Jetty embedded server again.

```clojure
(defn jetty-shutdown-timed
  "Shutdown server after specific time,
  allows time for threads to complete.
  Stops taking new requests immediately by
  closing the HTTP listener and freeing the port."
  [server]
  (.setStopTimeout server 1000)
  (.setStopAtShutdown server true))


;; Define a single instance of the embedded Jetty server
(defonce server
  (adapter/run-jetty
    #'webapp
    {:port         8000
     :join?        false
     :configurator jetty-shutdown-timed}))
```

> The stop/start approach used here is a very simplified version of other lifecycle management libraries, eg. [Component](https://github.com/stuartsierra/component), [Mount](https://github.com/tolitius/mount) and [Integrant](https://github.com/weavejester/integrant).
> As we have only one component, the Jetty server, there is no need to use a lifecycle management library.

## Cache YouTube API results

Using the `def` function a name is bound to the results of the YouTube API calls.  Using a `def` means that the API will only be called once and the results cached in our REPL.

This means we only have to call our API once per REPL session, so we don't use up our data rate limits or have to wait if the API calls are slow or down.  This is only a temporary approach, but its handy for development.

First lets get the playlists for the practicalli channel.  The channel has a unique **chanelID** and we want to see the **snippet** and **contentDetails** part of the result.

Requests to the YouTube API from our Clojure app need to authenticate, which is done so via an access token provides in the Google API dashboard, under my account.  An environment variable called `YOUTUBE_API_KEY` was created in my operating system and is used from the Clojure application via `System/getenv` function call.

```clojure
(def youtube-url-channel-practicalli
  (str "https://www.googleapis.com/youtube/v3/playlists?part=snippet,contentDetails&channelId=UCLsiVY-kWVH1EqgEtZiREJw&key=" (System/getenv "YOUTUBE_API_KEY")))
```

This gives us a list of all the playlists created by the Practicalli channel, along with lots of other data

To find the specific pieces of data that are useful, create a helper function to extract just the **items** section of the response

```clojure
(def practicalli-channel-playlists-full-details
  (get (json/read-str
         (:body
          (http-client/get youtube-url-channel-practicalli)))
       "items"))
```

The **items** section has several playlists, so we need to iterate over the results to extract the specific id and title of each playlist

```clojure
(defn playlist-names
  "Extract YouTube id and title for each Playlist found in the channel"
  [all-playlists]
  (into {}
        (for [playlist all-playlists
              :let     [id (get playlist "id")
                        title (get-in playlist ["snippet" "title"])]]
          {id title})))
```

In the REPL, call this function with the results from the API call, narrowed down to just the **items**.

```clojure
#_(playlist-names practicalli-channel-playlists-full-details)
;; => {"PLpr9V-R8ZxiB3u90ga_SdxYsF2k2JTag1" "Clojure CLI and tools.deps", "PLpr9V-R8ZxiCHMl2_dn1Fovcd34Oz45su" "Practicalli Spacemacs", "PLpr9V-R8ZxiDjyU7cQYWOEFBDR1t7t0wv" "Clojure Study Group"}
```


We can take a similar approach to get the videos in a particular playlist.

First define a new URL to be used to call the YouTube API.  This will get all the information about that playlist.

```clojure
(def youtube-url-channel-practicalli-playlist-study-group
  (str "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,id&playlistId=PLpr9V-R8ZxiDjyU7cQYWOEFBDR1t7t0wv&key=" (System/getenv "YOUTUBE_API_KEY")))
```

Then call the YouTube API with the new URL for the study group playlist

```clojure
(def practicalli-playlist-study-group
  (get
    (json/read-str
      (:body
       (http-client/get youtube-url-channel-practicalli-playlist-study-group)))
    "items"))
```

Then extract the relevant data we want using a helper function.

```clojure
(defn playlist-items
  "Get the important values for each video in the playlist

  `snippet`:`resourceId`:`videoId` - used for the URL address of the video
  `snippet`:`title` - title of the video
  `snippet`:`thumbnails` : `default` : `url` - full URL of thumbnail image"

  [playlist-details]

  (into {}
        (for [item playlist-details
              :let [id (get-in item ["snippet" "resourceId" "videoId"])
                    title (get-in item ["snippet" "title"])
                    thumbnail (get-in item ["snippet" "thumbnails" "default" "url"])]]
          {id [title thumbnail]})))
```



## Add handler functions

TODO: Return specific information about the playlists and apis

```clojure
(defn home-page
  "Default view of the Practicalli videos "
  [request]
  (response "Hello World"))
```

Return information about a specific playlist, initially this is hard coded to just use the study group playlist.

```clojure
(defn playlist
  "Display a playlist as defined by the parameter list"
  [request]
  ;; hard coded to study-group playlist for now
  (response
    (str (playlist-items practicalli-playlist-study-group))))
```


In the REPL, test the handler by calling it with an empty hash-map, simulating an empty request.

```clojure
#_(playlist {})
```


## Update our routes

Add a route for `/study-group` to call the `playlist` handler and show the results as a string

```clojure
(defroutes webapp
  (GET "/"               [] (response "home-page"))

  (GET "/study-group"    [] playlist)
  (GET "/playlist/:name" [] (response "playlist"))

  (not-found
    "<h1>Page not found, I am very sorry.</h1>"))
```

## Improve the experience

Use Bulma, Bootstrap or Foundation CSS libraries to present the information in a much nicer way.

For example, a ClojureScript / figwheel main project I created previously uses Bootstrap cards.  These cards could show the video thumbnail and video title and include a link to play the video using the videoId value.

* [Practicalli - mock YouTube website](https://practicalli.github.io/clojure-study-group/)
* [GitHub repository - mock YouTube website](https://github.com/practicalli/clojure-study-group-website)

The same can be done for a server side web application.

The challenge of using ClojureScript may come from too many API calls if the results are not cached.  Som e investigation as to the best approach will be done in the next few weeks.

Thank you.
