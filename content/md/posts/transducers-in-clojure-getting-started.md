{:title "Clojure Transducers - Getting Started"
:layout :post
:date "2016-06-15"
:topic "clojure"
:tags  ["clojure-core" "clojure" "transducers" "reduce"]}


Transducers are built upon the design principle in Clojure of composing functions together, allowing you to elegantly abstract functional composition and create a workflow that will transform data without being tied to a specific context.  So what does that actually mean and what does the code look like?  Is there a transducer function or is it just extensions to existing functions.  These are the questions we will explore and answer.

> A good understanding of functions such as map & reduce and composing functions with the threading macros is recommended before writing code with Transducers.

This is my interpretation of the really great introduction to Transducers from [Clojurescript Unraveled](https://funcool.github.io/clojurescript-unraveled/), expanded with additional code and my own comments.

<!-- more -->

## Defining a data structure

Defining a data structure that will represent our fruit, including whether that fruit is rotten or clean.  We have two collections of grapes, one green, one black.  Each cluster has 2 grapes on it (not a very big cluster in this example)

```clojure
(def grape-clusters
  [{:grapes [{:rotten? false :clean? false}
             {:rotten? true  :clean? false}]
    :colour :green}
   {:grapes [{:rotten? true  :clean? false}
             {:rotten? false :clean? false}]}
   :colour :black])
```

Each grape cluster has the following structure

```clojure
{:grapes [{:rotten? false :clean? false}
          {:rotten? true  :clean? false}]
 :colour :green}
```


## Splitting into grape clusters

We want to split the grape clusters into individual grapes, discarding the rotten grapes.  The remaining grapes will be checked to see if they are clean.  We should be left with one green and one black grape.

First lets define a function that returns a collection of grapes, given a specific grape cluster.

```clojure
(defn split-cluster
"Takes a grape cluster and returns the vector of all the grapes in that cluster"
  [cluster]
  (:grapes cluster))
```

The body of this function returns the value pointed to by the `:grapes` keyword, which will be a collection of grapes.  We do not ask for the value of :colours as in this case the colour of the grape is irrelevant.

## Testing our code in the REPL

The grape-clusters data structure is a vector of two grape clusters.  To see what a grape cluster is, get the first element of that data structure

```clojure
(first grape-clusters)
;; => {:grapes [{:rotten? false, :clean? false} {:rotten? true, :clean? false}], :colour :green}
```

For each cluster in grape-clusters, return just the :grapes data, ignoring the colour information

```clojure
(split-cluster {:grapes [{:rotten? false :clean? false}
                         {:rotten? true  :clean? false}]
                :colour :green})
;; =>[{:rotten? false, :clean? false} {:rotten? true, :clean? false}]
```


## A filter for rotten grapes

We don't want to include any rotten grapes after we have processed all our clusters, so here we define a simple filter to only return grapes where `:rotten?` is false.

This filter will be used on each individual grape extracted from the cluster.

```clojure
(defn not-rotten
  "Given a grape, only return it if it is not rotten.  A grape is defined as {:rotten? true|false :clean? true|false}"
  [grape]
  (not (:rotten? grape)))
```

## Cleaning all the grapes

Any grapes we have left should be cleaned.  Rather than model the cleaning process, we have simply written a function that updates all the grapes with a value of `true` for the key `:clean?`

```clojure
(defn clean-grape
  "Given a grape, updating the grapes :clean? value to true regardless of its current value.  A grape is defined as {:rotten? true|false :clean? true|false}"
  [grape]
  (assoc grape :clean? true))
```

Lets give our clean grape function a quick test in the REPL.

```clojure
(clean-grape {:rotten? false :clean? false})
;; => {:rotten? false, :clean? true}
```

# Functional composition using the thread last macro

Each line passes its evaluate value to the next line as its last argument.  Here is the algorithm we want to create with our code:

* evaluate the name grape-clusters and return the data structure it points to.
* use mapcat to map the split-clusters function over each element in grape-clusters, returning 4 grapes concatenated into one collection
* filter the 4 grapes, dropping the grapes where :rotten? equals true, returning 2 grapes
* update each grape to have a :clean? value of true


```clojure
(->> grape-clusters
     (mapcat split-cluster)
     (filter not-rotten)
     (map clean-grape))

;; => ({:rotten? false, :clean? true} {:rotten? false, :clean? true})
```

# Using partial to compose functions together

  Composing functions are read in the lisp way, so we pass the grape-clusters collection to the last composed function first

```clojure
(def process-clusters
  "Takes clusters of grapes and returns only the nice ones, that have been cleaned.  Using comp, read the function from the bottom up to understand the argument."
  (comp
   (partial map clean-grape)
   (partial filter not-rotten)
   (partial mapcat split-cluster)))
```

Now lets call this composite function again...

```clojure
(process-clusters grape-clusters)
;; => ({:rotten? false, :clean? true} {:rotten? false, :clean? true})
```

The `process-clusters` definition above uses the lisp way of evaluation - inside-out.

Here is a simple example of evaluating a maths expression from inside-out.  Each line is the same expression, but with the innermost expression replaced by its value.

```clojure
(+ 2 3 (+ 4 5 (/ 24 6)))   ;; (/ 24 6)   => 4
(+ 2 3 (+ 4 5 4))          ;; (+ 4 5 4)  => 13
(+ 2 3 13)                 ;; (+ 2 3 13) => 18
18
```

# Transducers in Clojure

There are several functions that work on sequences (collections) which will return what is referred to as a transducer if they are not passed a sequence as an argument.  For example, if you only pass map a function and not a collector, it returns a transducer that can be used with a collection that is passed to it later.

Using the transduce feature of each of the functions in process-clusters, we can actually remove the partial function from our code and redefine a simpler version of process-clusters

```clojure
(def process-clusters
  (comp
   (mapcat split-cluster)
   (filter not-rotten)
   (map clean-grape)))
```

A few things changed since our previous definition process-clusters. First of all, we are using the transducer-returning versions of mapcat, filter and map instead of partially applying them for working on sequences.

Also you may have noticed that the order in which they are composed is reversed, they appear in the order they are executed. Note that all map, filter and mapcat return a transducer. filter transforms the reducing function returned by map, applying the filtering before proceeding; mapcat transforms the reducing function returned by filter, applying the mapping and concatenation before proceeding.

One of the powerful properties of transducers is that they are combined using regular function composition. What’s even more elegant is that the composition of various transducers is itself a transducer! This means that our process-cluster is a transducer too, so we have defined a composable and context-independent algorithmic transformation.

Many of the core ClojureScript functions accept a transducer, let’s look at some examples with our newly defined version of `process-cluster`:

```clojure
(into [] process-clusters grape-clusters)
;; => [{:rotten? false, :clean? true} {:rotten? false, :clean? true}]


(sequence process-clusters grape-clusters)
;; => ({:rotten? false, :clean? true} {:rotten? false, :clean? true})


(reduce (process-clusters conj) [] grape-clusters)
;; => [{:rotten? false, :clean? true} {:rotten? false, :clean? true}]
```

Since using reduce with the reducing function returned from a transducer is so common, there is a function for reducing with a transformation called transduce. We can now rewrite the previous call to reduce using transduce:

```clojure
(transduce process-clusters conj [] grape-clusters)
;; => [{:rotten? false, :clean? true} {:rotten? false, :clean? true}]
```

# Summary

This was just a brief taste of Transducers in Clojure and I hope to create more examples of their use over time.  I don't see Transducers being used too much for my own code initially, but its a useful way to abstract functional composition and make your code more reusable within your project.

If you need more time for this concept to sink in, its quite alright to stay with threading macros and the partial function, or even just applying map.  I find Clojure more rewarding when you first get more comfortable with the core concepts and build on them when you are ready.

> Article originally published on [jr0cket.co.uk](https://jr0cket.co.uk/) and has been migrated to [practical.li/blog](https://practical.li/blog/)

Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
