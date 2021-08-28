{:title "Integrant for Web Services REPL driven development"
 :layout :post
 :draft? true
 :date "2021-09-16"
 :topic "repl-driven-development"
 :tags  ["integrant-repl" "integrant" "aero"]}


Integrant

Aero can be used with the Integrant configuration file to define envioronment specific values, read environment variables and manage values conditionally.


Integrent features
- data driven

Component required functions to be wrapped and use lifecycle



lifecycle management

initialising services

managing environments

our namespaces can be considered a tree, with a variety of services across the branches of the tree


## Managing Services
Without Integrant, a service can be manage by defining a shard config, however, this does not work well with a reloaded repl workflow.

Integrant can manage



## Defining the configuration
Integrant configuration is defined in the `resources/config.edn`, although it can also be defined in-line with the code.  A separate file is preferable as the configuration grows in size.

`resources/config.edn` file is a hash-map, so its very easy to work with and can be linted with clj-kondo.


## Reading the configuration


```clojure
(def config
   (ig/read-string (slurp "config.edn")))
```

> Assumption: ig/read-string function take the resources directory as the root of the path to the configuration file.











## Using profiles with aero
Aero uses a single edn file to define the configuration of the system.  This included support for using specific values for different environments, develop, test, stage, live.  Environment variables can also be used and conditional check can be used if there are optional values or environment variables not set.


```clojure
(defn config [profile]
  (aero/read-config (io/resource "config.edn") {:profile profile}))
```

Example of using an environment variable or default value if that variable is not set
