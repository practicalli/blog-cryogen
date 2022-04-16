{:title "Embracing the Clojure REPL in Production"
:layout :post
:date "2022-02-28"
:topic "practicalli"
:tags  ["practicalli"]}


The Clojure REPL runs all the Clojure code, both in production and during development.  Its always present and the only difference is the REPL typically runs headless in production and interactive during development.

<!-- more -->

# Embracing the REPL in production

An interactive REPL in production can receive updates to behaviour and data without bringing the system down.  Security around the connection to the REPL in production is of course prudent.

## Using Socket Server


## Using drawbridge


## ???
