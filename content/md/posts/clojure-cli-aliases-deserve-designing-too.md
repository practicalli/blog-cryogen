{:title "Clojure CLI tools aliases deserve good design too"
 :layout :post
 :date "2020-12-11"
 :topic "clojure-cli"
 :tags  ["clojure-cli" "aliases"]}

Aliases in [Clojure CLI tools](https://practicalli.github.io/clojure/clojure-tools/using-clojure-tools.html) are an important way to configure how to work with a Clojure project effectively, so they deserve the same attention and clean design applied to source code, test code and other configuration.

[`practicalli/clojure-deps-edn`](https://github.com/practicalli/clojure-deps-edn) provides examples of over 50 aliases crafted to use over multiple projects and providing access to a wide range of Clojure CLI community tools.

One way to kill the excellent experience that Clojure CLI tools bring is to write aliases that conflate concepts and are just a catch all for loosely related configuration.  Without applying a little thought and design to aliases it just makes more work later on.

The `clojure` command line provided by Clojure CLI tools allows the chaining of aliases together, providing a very flexible way to use and re-use aliases across all your projects.

Crafting the design of your aliases with some design thinking reduces conflict between loosely related tools and libraries, minimizes duplication and simplifies the `deps.edn` configuration for all your projects.

<!-- more  -->

## Conflated design of aliases

Aliases are not buckets to throw random configuration together, they should have a very clear and specific purpose.

Aliases that are used for different purposes just add to complexity.

In this example, a very generic name is used for an alias that servers at least two different purposes.

```
  :test {:extra-paths ["test"]
         :extra-deps {lambdaisland/kaocha           {:mvn/version "1.0.690"}
                      lambdaisland/kaocha-cloverage {:mvn/version "1.0.63"}
                      lambdaisland/kaocha-junit-xml {:mvn/version "0.0.76"}
                      ring/ring-mock                {:mvn/version "0.3.2"}
                      mockery                       {:mvn/version "0.1.4"}
                      http-kit.fake/http-kit.fake   {:mvn/version "0.2.1"}}
         :main-opts  ["-m" "kaocha.runner"]}
```

In one scenario, the alias is used with the Kaocha test runner on the command line to run all tests defined on the class path, to which the `test` directory is added.  The alias loads all the libraries and runs the `-main` function in the `kaocha.runner`.  Although the alias name is vauge as to the purpose of the alias, it does successfully run the kaocha test runner.

Using the same alias to run a REPL to include the "test" directory and dependencies is a source of several issues.  As kaocha is an external process to the REPL, the kaocha dependencies are simply not used and consume more resources and slows down startup time.  As the `:test` alias has a `:main-opts` that will run the `-main` function from `kaocha.runner`, it adds complexity as the REPL process also has a `-main` function to run.  Clojure main can only run one `-main` function, so which one wins.

> There is discussion on the Cider GitHub repository to [force the Cider jack-in process to win](https://github.com/clojure-emacs/cider/issues/2941) regardless of aliases provided.  However, designing good aliases would remove this issue.

What if another test runner is going to be used on the command line?  Using this `:test` alias again causes issues as to which `-main` function will run, the `:main-opts` in the alias or `-main` function from the other test runner.  It would also load in dependencies that are not required which is very inefficient.


## Designed aliases

Aliases are just like code and other configuration, they should be designed well for the purpose the serve.

The `:env/test` alias adds the `test` directory to the class path so tests can be found.  It includes specific libraries that the unit tests require to run.

```
  :env/test
  {:extra-paths ["test"]
   :extra-deps {ring/ring-mock                {:mvn/version "0.3.2"}
                mockery                       {:mvn/version "0.1.4"}
                http-kit.fake/http-kit.fake   {:mvn/version "0.2.1"}}}
```

The `:env/test` provides a clear description to it purpose, to provide the environment configuration for testing.  The alias is usable with a range of test runners, both in process (cider-test) and external (kaocha, cognitect labs, eftest, etc.).  The `:env/test` alias can also be used with continuous integration services.

Specific aliases can be defined for a test runner, for example kaocha with cloverage and junit xml reporting.

```
  :test-runner/kaocha
  {:extra-paths ["test"]
   :extra-deps {lambdaisland/kaocha           {:mvn/version "1.0.690"}
                lambdaisland/kaocha-cloverage {:mvn/version "1.0.63"}
                lambdaisland/kaocha-junit-xml {:mvn/version "0.0.76"}}
   :main-opts  ["-m" "kaocha.runner"]}
```

A specific alias for the Cognitect labs runner

```
  :test-runner/cognitect
  {:extra-paths ["test"]
   :extra-deps  {com.cognitect/test-runner
                 {:git/url "https://github.com/cognitect-labs/test-runner.git"
                  :sha     "b6b3193fcc42659d7e46ecd1884a228993441182"}}
   :main-opts   ["-m" "cognitect.test-runner"]}
```

Both test runner aliases can be added to the user level configuration (~/.clojure/deps.edn) and used with any Clojure project

The `:env/test` alias can be used with either these aliases to run the tests within the specific environment required for the project.

```shell
clojure -M:env/test:test-runner/kaocha
```


## Summary

A little design thinking about the aliases and borrowing from community examples (practicalli & seancorfield) can make your projects more consistent to work with, easier to maintain and onboard new developers and far simpler overall.


## Looking to the future - Clojure exec

Clojure exec was introduced in September 2020 (Clojure ClI tools version 1.10.1.697) and brings the capacity to run any fully qualified function, rather than just Clojure main.

Rather than using string based adhoc arguments, Clojure exec takes a hash-map of key / value pairs, making the arguments self describing values and providing scope to do far more with functions.

Clojure exec has already been adopted by several community projects, e.g. clj-new, depstar, and others, like vlaaad/reveal, are following on with that approach too.

It is likely that most tools for Clojure CLI will evolve into using Clojure exec and embrace this more flexible and structured approach to running Clojure.

* [clj exec - Inside Clojure](https://insideclojure.org/2020/07/28/clj-exec/)
* [clj exec update - Inside Clojure](https://insideclojure.org/2020/09/04/clj-exec/)

Thank you.
[@practical_li](https://twitter.com/practical_li)
