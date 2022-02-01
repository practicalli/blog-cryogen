{:title "Java 17 JDK for Clojure development"
:layout :post
:date "2022-01-31"
:topic "java"
:tags  ["java" "jvm"]}


Java JDK 17 is the latest Long Term Support version and ideally should be the default JVM for developing and deploying new Clojure projects (and existing projects after testing). There should be little risk upgrading, especially from Java 11 onward.  The 17.0.2 version has just been release, so has been tested by many development teams already.

Although the language features are of less interest, the security and performance improvements over the last 3 years (since Java 11) or 6 years (since Java 8) are valuable to Clojure development.

[Oracle JDK 17 is free again](https://www.infoq.com/news/2021/10/oracle-jdk-free-again/) for use in production and to redistribute, under the No-Fee Terms and Conditions License.  However, Practicalli recommends using OpenJDK anyway.


<!-- more -->

## Long Term Support LTS

The valuable part of a supported Java version is to receive timely security patches that should have no impact on running systems in production.

An LTS version is released every 3 years so minimises the churn that comes with intermediate versions, which are only supported for 6 months.

LTS versions receive security updates for a year after the next LTS version is release, leaving ample time to test and migrate to a new major version.

A 2 year LTS release cadence has been proposed by Mark Reinhold, Chief architect of the Java Platform Group, to encourage faster adoption especially by enterprise's who only sign-off on long-term support products.

> [Wikipedia: Long-term support](https://en.wikipedia.org/wiki/Long-term_support)


## Where to get Java 17

Practicalli recommends using OpenJDK for Java, the community managed distribution of Java.  Practicalli is currently migrating to the latest Long Term Support version, OpenJDK 17.0.2.

Most Linux distributions have packages for OpenJDK, with the Long Term Support and intermediate versions available (usually Java 8 through to 18).

To install on Ubuntu / Debian Linux:

```shell
sudo apt install openjdk-17-jdk openjdk-17-source
```

Installing the source package is optional, although it can be useful to [add the Java Sources to a Clojure project classpath](https://github.com/practicalli/clojure-deps-edn#java-sources), to help editors navigate to the definition of Java classes used when using Java interop.

The [Adoptium website](https://adoptium.net/) is a community initiative that provides OpenJDK binaries for different versions of Java and multiple operating systems. Adoptium JDK downloads include a `lib/src.zip` file that contains the Java source code.

[![Adoptium prebuilt OpenJDK binaries for free](https://raw.githubusercontent.com/practicalli/graphic-design/live/java/screenshots/java-adoptium-website-temurin-17.png)](https://adoptium.net/)


### Amazon Corretto

Install [Amazon Corretto JDK](https://aws.amazon.com/corretto/) to have a consistent development and deployment environment when using Amazon Web Services (AWS).

[Amazon Corretto](https://aws.amazon.com/corretto/) is a no-cost, multi-platform, production-ready distribution of the Open Java Development Kit (OpenJDK). Corretto comes with long-term support and includes performance enhancements and security fixes.

* [Downloads for Amazon Corretto 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html)


## Java 17 for Continuous Integration

Java 17 is available via the [setup-java GitHub action](https://github.com/actions/setup-java).  Practicalli uses the Eclipse Temurin (OpenJDK distribution).  Several [other OpenJDK distributions are available](https://github.com/actions/setup-java#supported-distributions).

## Circle CI

Recommended image for Clojure projects is `cimg/clojure:1.10`

The image contains OpenJDK 17 and the latest version of Clojure CLI, Leiningen and Babashka

Example `.circleci/config.yml` configuration file with latest image

```yaml
jobs:    # basic units of work in a run
  build: # runs not using Workflows must have a `build` job as entry point
    working_directory: ~/build # directory where steps will run
    docker:                      # run the steps with Docker
      - image: cimg/clojure:1.10 # image is primary container where `steps` are run
```


## GitHub actions

```yaml
steps:
  - uses: actions/checkout@v2
  - uses: actions/setup-java@v2
    with:
      distribution: 'temurin'
      java-version: '17'
```

setup-java can be used with [setup-clojure GitHub action](https://github.com/DeLaGuardo/setup-clojure), which supports Clojure CLI, Leiningen and Boot.

```yaml
steps:
  - name: Checkout
    uses: actions/checkout@v2

  - name: Prepare java
    uses: actions/setup-java@v2
    with:
      distribution: 'temurin' # See 'Supported distributions' for available options
      java-version: '17'

  - name: Install clojure tools
    uses: DeLaGuardo/setup-clojure@3.7
```

### Docker images

There are [a wide range of Clojure Docker images](https://hub.docker.com/_/clojure/) available, for various versions of Java, Clojure CLI (tools-deps), Leiningen (lein) and Boot (boot).

[clojure:openjdk-17-tools-deps-bullseye](https://github.com/Quantisan/docker-clojure/blob/730187eb7b737d288e3fd8b4cec0e85578c089d6/target/openjdk-17-slim-bullseye/tools-deps/Dockerfile) is a lightweight Linux docker image ([Debian 11 stable - bullseye](https://www.debian.org/releases/)) with [Java 17.0.2 (OpenJDK)](https://hub.docker.com/_/openjdk) and Clojure CLI installed.

An example `Dockerfile` for a Clojure project

```yaml
FROM clojure:openjdk-17-tools-deps-bullseye
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY deps.edn /usr/src/app/
RUN clojure -X:test/run
COPY . /usr/src/app
RUN clojure -X:package/uberjar
CMD ["java", "-jar", "service.jar"]
```

`deps.edn` should contain aliases to run tests, `test/run`, and to create an Uberjar, `:package/uberjar`

> The [layers used in the clojure:openjdk-17-tools-deps-bullseye image](https://hub.docker.com/layers/clojure/library/clojure/openjdk-17-tools-deps-bullseye/images/sha256-2ce9392f858cad109022f904177d592dad51548eba0c063e5ea5faa9de99f5f8?context=explore)


## Any risk to running Clojure on Java 17

No, (at least I havent found any reported issues by the community).  If you are already running OpenJDK, then it should be a smooth upgrade, especially if migrating from Java 11 or newer.

If migrating from Oracle Java, or Java version 8 or earlier, then there is a small risk of issues. From Java 9 a more modular approach to building Java was adopted as well and removing some code into their own libraries (e.g. JavaFX).

There is also a very small risk for Clojure libraries which haven't been updated since September 2017 (when Java 11 was released).

Naturally a good amount of testing in a non-production environment should be carried out before upgrading production systems, just to make sure.


## Java 17 highlights

There are a [few significant changes in Java 17](https://docs.oracle.com/en/java/javase/17/migrate/significant-changes-jdk-release.html), more-so when considering all the changes since Java 11.

* Oracle Java is under a free licence again (although most developers now use OpenJDK)
* [Security updates](https://docs.oracle.com/en/java/javase/17/migrate/security-updates.html)
* Performance tweaks to Hotspot JVM
* Focus on Graal for AOT
* Native JDK for Arm 64 Hardware on [MacOS](https://openjdk.java.net/jeps/391) and [Windows](https://openjdk.java.net/jeps/388)

> [JDK 17 release notes](https://www.oracle.com/java/technologies/javase/17-relnote-issues.html) also covers the new features in this release.


### Open License again

Oracle Java 17 is under the No-Fee Terms and Conditions (NFTC) license, allowing free production and commercial use.

The majority of developer shifted to OpenJDK Java distributions when Oracle put restrictions on Java back in October 2019(?) .  Practicalli recommends OpenJDK, which can also be obtained

> A recent Snyk survey showed the Oracle JDK version was only used by 23% of developers in a production environment.


### Focus on Graal for AOT

The HotSpot Just-in-time compiler still exists although Oracle recommends AOT compilation via [GraalVM](https://www.graalvm.org/).

For Clojure, there are few cases where AOT is relevant.  Clojure Libraries should be published without AOT.  Clojure applications and services might be able to reduce start up time a little, but any significant performance needs should be addressed by GraalVM.

Command Line tools can benefit from GraalVM native compilation, e.g. [Babashka](https://babashka.org/)


## Why has Java endured?

Java as a platform endures as it delivers a high-performance platform, optimised over decades to meet the needs of millions of developers world-wide.  Over the last decade [a myriad of additional languages have been added to the platform](https://en.wikipedia.org/wiki/List_of_JVM_languages "Wikipedia: List of JVM Languages") (Clojure, Scala, Jython)

Java as a language is still the workhorse of many enterprise development teams, with decades of experience with the langugage.  New language features are added at a considered cadence, via the Java Community Process (JCP), which ensures the Java community moves forward together.

The Clojure language design includes a focus on backwards compatibility and has this in common with Java and the JVM.

> "Backward compatibility. Applications written in Java 10, 15, 20 years ago are still running, and still run the backbone of organisations that make money," [Trisha Gee, Java Champion and Developer Advocate](https://trishagee.com/)


## Summary

Java JDK was released on September 15, 2021 and 17.0.2 is released this month, so there has been enough time to iron out issues from a new major version.

Changes in the Java Development Kit rarely affect Clojure code, even if there has been significant Java Interop.  The only challenge for Clojure was the major refactor of the JDK internals in Java 9, helping move to a more modular and stream-lined JDK.

Clojure applications should be tested thoroughly when adopting a new version of the Java JDK.  Following an LTS release cadence limits that testing to a 3 year cycle, with plenty of overlap between LTS versions (usually 2 years more of security updates).

Using the Long Term Support (LTS) versions of Java is sufficient for any Clojure application or service, so long as security patches are regularly applied.

There is little advantage to following the non-LTS release cycle of every 6 months, although this is not much of a risk so long as dev>test>staging>production environments are all using the same version.
