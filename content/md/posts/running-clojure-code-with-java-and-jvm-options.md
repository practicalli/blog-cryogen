{:title "Java JVM Options for running Clojure"
:layout :post
:date "2023-08-15"
:topic "java"
:tags  ["clojure" "java" "jvm" "jdk_java_options"]}

Clojure may benefit from setting options to alter the default behaviour of the Java Virtual Machine (JVM), especially when running in a constrained environment or if performance issues have been detected.

`JDK_JAVA_OPTIONS` is the official Environment Variable for setting options with the `java` command (Java version 9 onward) and often used by deployment systems to inject JVM options into container environments.

`:jvm-opts` key within Clojure CLI aliases define JVM options to support local development along with JVM  options on the command line.

<!-- more --->


## Java Virtual Machine Optimisation

The Java Virtual Machine which is a highly optimised environment that rarely needs adjusting, unless there are noticeable performance or resource issue use.

Minimum and maximum heap sizes, i.e. `-XX:MinRAMPercentage` and `-XX:MaxRAMPercentage` are typically the only optimisations required.

`java -XshowSettings -version` displays VM settings (vm), Property settings (property), Locale settings (locale), Operating System Metrics (system) and the version of the JVM used.  Add the category name to show only a specific group of settings, e.g. `java -XshowSettings:system -version`.

`JDK_JAVA_OPTIONS` can be used to tailor the operation of the Java Virtual Machine, although the benefits and constraints of options should be well understood before using them (especially in production).

> `JAVA_OPTS` has historically been used, although considered deprecated unless contrained to Java version 8 

> [Reference Java 17 JVM Flags](https://practical.li/clojure/reference/jvm/java-17-flags/)


## Clojure CLI Command Line arguments

Clojure CLI `-J` flag passes configuration options to the JVM. When including multiple flags, each must be prefixed with `-J`.

```shell
clojure -J-XshowSettings:system -J-XX:MaxRAMPercentage=85
```

The `-J` flag is a convienient way to try out JVM flags before adding them as an alias or making them part of the build & deployment workflow.

```shell
clojure -J-XX:+UnlockDiagnosticVMOptions -J‑XX:NativeMemoryTracking=summary -J‑XX:+PrintNMTStatistics
```

## Clojure CLI aliases

`:jvm-opts` key in an alias adds JVM options to Clojure CLI deps.edn configuration.  The `:jvm-opts` key has a value that is a collection of JVM option strings.

Alias to set a relative heap size of 85% of the total memory.

```clojure
:jvm/heap-max-85 {:jvm-opts ["-XX:MaxRAMPercentage=85" "-XshowSettings:system"]}
```

Report a full breakdown of the HotSpot JVM’s memory usage upon exit using the following option combination:

```clojure
:jvm/report {:jvm-opts ["-XX:+UnlockDiagnosticVMOptions"
                        "‑XX:NativeMemoryTracking=summary"
                        "‑XX:+PrintNMTStatistics"]}
```

Add JVM options to a Clojure CLI alias that provides a development tool, e.g. clj-memory-meter as defined in [Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/)

```clojure
  :performance/memory-meter
  {:extra-deps {com.clojure-goes-fast/clj-memory-meter {:mvn/version "0.3.0"}}
   :jvm-opts   ["-Djdk.attach.allowAttachSelf"]}
```

Add a Java module

```clojure
:jvm/xml-bind {:jvm-opts ["–add-modules java.xml.bind"]}
```

Setup GC with short STW pauses which can be relevant for very high web server workloads

```clojure
:jvm/g1gc
{:jvm-opts ["-XX:+UseG1GC"
            "-XX:MaxGCPauseMillis=200"
            "-XX:ParallelGCThreads=20"
            "-XX:ConcGCThreads=5"
            "-XX:InitiatingHeapOccupancyPercent=70"]}
```

* Source: [Tuning Garbage Collection with Oracle JDK](https://docs.oracle.com/cd/E40972_01/doc.70/e40973/cnf_jvmgc.htm#autoId2)


Ignoring unrecognised options

```clojure
:jvm-opts ["-XX:+IgnoreUnrecognizedVMOptions"]
```

The aliases can be used with the Clojure CLI execution options: `-A` (for built-in REPL invocation), `-X` (for clojure.exec function execution), or `-M` (for clojure.main execution).

> `-J` JVM options specified on the command line are concatenated after the alias options


## JVM options in Containers

Practicalli set `JDK_JAVA_OPTIONS` variable in Docker with JVM options to show system settings on startup, force container mode and set memory heap maximum to 85% of host memory size.

```dockerfile
ENV JDK_JAVA_OPTIONS "-XshowSettings:system -XX:+UseContainerSupport -XX:MaxRAMPercentage=85"
```

Relative heap memory settings (`-XX:MaxRAMPercentage`) should be used for containers rather than the fixed value options (`-Xmx`) as the provisioning service for the container may control and change the resources available to a container on deployment (especially a Kubernettes system).

Options that are most relevant to running Clojure & Java Virtual Machine in a container include:

* `-XshowSettings:system` display (container) system resources on JVM startup
* `-XX:InitialRAMPercentage` Percentage of real memory used for initial heap size
* `-XX:MaxRAMPercentage` Maximum percentage of real memory used for maximum heap size
* `-XX:MinRAMPercentage` Minimum percentage of real memory used for maximum heap size on systems with small physical memory
* `-XX:ActiveProcessorCount` specifies the number of CPU cores the JVM should use regardless of container detection heuristics
* `-XX:±UseContainerSupport` force JVM to run in container mode, disabling container detection (only useful if JVM not detecting container environment)
* `-XX:+UseZGC` low latency Z Garbage collector (read the [Z Garbage collector documentation](https://docs.oracle.com/en/java/javase/17/gctuning/z-garbage-collector.html) and understand the trade-offs before use) - the default Hotspot garbage collector is the most effective choice for most services

> Only optimise if performance test data shows issues
> 
> Without performance testing of a specific Clojure service and analysis of the results, let the JVM use its own heuristics to determine the most optimum strategies it should use



<!-- TODO: review following content -->


## The java command

Clojure is typically run in production using the `java` command, as the only requirement for deployment is the Java Run-time Environment (JRE) and a Clojure uberjar (a package of the Clojure project and Clojure standard libraries).

The standard Clojure libraries need to be on the Java class path to run Clojure code using the `java` command.

The `org.clojure/clojure` library provides `clojure.main` which defines functions to run Clojure code and start a REPL session. `org.clojure/core.specs.alpha` and `org.clojure/spec.alpha` are supporting libraries from Clojure version 9 onwards and define specifications for the `clojure.core` functions

The `org.clojure/clojure`, `org.clojure/core.specs.alpha` and `org.clojure/spec.alpha` libraries *could* be copied to a `lib` directory and included on the class path, although [an uberjar approach](Running Clojure via an Uberjar) is used in practice.

Run the Game Board Clojure project using the java command

```bash
java --class-path src:lib/* clojure.main -m practicalli.game-board $PORT
```

The `--class-path` option can use a wildcard `*` with a directory name, adding any `.jar` or `.zip` files found in that directory onto the Java class path.  This saves having to specify the individual `.jar` file names of the three Clojure libraries.

The first non-option argument in the `java` command is the fully qualified name of the class to be called, which should be `clojure.main` to execute the Clojure code from the Game Board project.

The `-m practicalli.game-board` arguments are passed to `clojure.main`, specifying the Clojure namespace containing the entry point to the Clojure code, e.g. `-main` function definition.

All further arguments are passed to the `-main` function in the `practicalli.game-board` namespace, e.g. `$PORT`.


## Run Clojure via Uberjar

An uberjar created from the Clojure project should contain the necessary Clojure libraries on the class path, along with the Clojure code from the project. The `-jar` option simplifies the `java` command whilst still carrying out the same work as the `--class-path` option.

```bash
java -jar game-board-0.1.0-SNAPSHOT.jar $PORT
```

> `-jar jarfile` option runs code encapsulated in a JAR file and ignores other `--class-path` settings.

The `.jar` file should contain a `/META-INF/MANIFEST.MF` file defining the Java Class that represents the Clojure namespace that contains the entry point function to the code, e.g. `Main-Class: practicalli.game_board`, the name uses snake_case rather than kebab-case as the value is read by Java rather than Clojure.

The ns form for the Clojure namespace should generate a Java class via a `(:gen-class)` directive.


### Configure a Clojure namesapce to generate a class

The main namespace should include a `(:gen-class)` directive in the `ns` definition.

A `-main` function is called from that namespace, passing in arguments from the command line. Defining `-main` with a variable arity `[& arguments]` allows any number of arguments to be passed without causing the initial call to fail.

```clojure
(ns practicalli.game-board.service
  (:gen-class))

(defn -main [& arguments]
  ;; code to start service
  )
```

Build tools such as [Clojure tools.build](https://www.clojure.org/guides/tools_build) or [tonsky/uberdeps](https://github.com/tonsky/uberdeps) should be used to generate a well-formed Uberjar that contains the Clojure libraries and standard configuration files.


### JVM Options - show settings

`-XshowSettings:system` is an option to print information about the VM & Operating System settings, properties and locales.  Details of the Java environment is printed at the end.

Show the baseline settings by calling java -version with the `-XshowSettings` option

```shell
java -XshowSettings -version
```

Settings are divided into categories so only specific parts of the settings can be printed out.

* `-XshowSettings:system` - operating system metrics (provider, CPU count, Memory & Swap limits), useful diagnostics when running in a container environment
* `-XshowSettings:vm` - show heap size and VM used
* `-XshowSettings:properties`
* `-XshowSettings:locale` locale settings (default and available locations)


`-XshowSettings:system` is especially useful diagnostic when running in a container environment as it will help diagnose if the resources available from the container have changed.


## JDK_JAVA_OPTIONS Environment variable

`JDK_JAVA_OPTIONS` environment variable can be used to set any of the options for the `java` command.  The value of the environment variable is automatically used by the `java` command,  prepend its value so the are used before any other arguments.

Using the `JDK_JAVA_OPTIONS` makes the `java` command simpler and potentially easier to find in a process listing (especially if there are multiple java processes running)

On the command line, set the `JDK_JAVA_OPTIONS`

```bash
export JDK_JAVA_OPTIONS="-XshowSettings:system"

java -version
```

Set options in a single command line by first setting the `JDK_JAVA_OPTIONS` and then running the Clojure service via an uberjar

```bash
export JDK_JAVA_OPTIONS="-XshowSettings:system" && java -jar todo-list.jar $PORT
```




## Java Options for Memory Management

The original approach to memory management was to set specific values for memory resource use by the JVM.  This approach was rarely an issue for physical servers as the memory available in the host operating system was unlikely to change.

Setting the maximum heap higher than the available memory available can lead to performance degredation of the Java Virtual Machine and may also trigger monitoring systems to restart the operating system.

In container-based cloud services and similar scalable environment, memory and cpu resources available to a container are simple to change in the deployment configuration.  Memory resources should be set using relative values, i.e. the percentage of the resources available.


### Container Memory Management

JVM options that optomise running in a container


* `-XX:MaxRAMPercentage` `-XX:MinRAMPercentage`

* `-Xmx`


Test the `-XX:MaxRAMPercentage` option by running the official OpenJDK container (alpine version).  Set the memory allocated to the container at 1 GB. Configure the JVM with `-XX:MaxRAMPercentage=50`, then approximately 512GB (i.e., 1/2 of 1GB) will be allocated to your Java heap size.
Java

```bash
docker run -m 1GB eclipse-temurin:17-alpine java -XX:MaxRAMPercentage=50 -XshowSettings:vm -version
```

The `-XshowSettings:vm` output shows the maximum heap size that will be used by the Java Virtual Machine.

```bash
VM settings:
Max. Heap Size (Estimated): 494.94M
Using VM: OpenJDK 64-Bit Server VM
```

* `-XX:MaxRAMPercentage=90` to set a relative maximum percentage of heap to use, based on the memory available from the host, e.g. `-XX:MaxRAMPercentage=80` will use a heap size of 80% of the available host memory

* `-XX:+UseContainerSupport` instruct the JVM that it is running in a container environment, disabling the checks the JVM would otherwise carry out to determine if it was running in a container.  Can save a very small amount of start up time, though mainly used to ensure the JVM knows its in a container.


```bash
java -XshowSettings:vm -XX:+PrintFlagsFinal -version | grep -Ei "maxheapsize|maxram|UseContainerSupport"
```

> `JDK_JAVA_OPTIONS` environment variable should be used for setting JVM options within a container or in the provisioning service (e.g. Kubernettes / Argo CD) that deploys containers.

> ‘-XX:MaxRAMPercentage’, ‘-XX: MinRAMPercentage’ JVM arguments are supported from Java 8 update 191 and above




### JDK_JAVA_OPTIONS in Docker Containers

Add and `ENV` directive to the `Dockerfile` before the `CMD` to run the Clojure service.

In this `Dockerfile` excerpt the `JDK_JAVA_OPTIONS` environment variable is used to print out the resources the JVM believes it has access to at startup. The JVM is instructed that it is running in a container environment and should use a maximum 90% heap size of the hosts memory resource.

```Dockerfile
# JDK_JAVA_OPTIONS environment variable for setting JVM options
ENV JDK_JAVA_OPTIONS "-XshowSettings:system -XX:+UseContainerSupport -XX:MaxRAMPercentage=80"

# Start service (override default `jshell` entrypoint command of image)
CMD ["java", "-jar", "game-board.jar"]
```



## Leiningen

<!-- TODO: assumption that jvm-opts in leinignen config is rarely used unless doing some serious Java Interop -->

* Include JVM options via config
- `:profiles {:uberjar {:jvm-opts [""]}}` for options relevant to building clojure


Edit the `project.clj` file and add the `[ring/ring "1.9.5"]` dependency to the top-level `:dependencies` key, which defines the libraries used to make the project.

```clojure
(defproject practicalli/web-server "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.11.0"]
                 [ring/ring "1.9.5"]]
  :main ^:skip-aot practicalli.web-server
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})

```

[Java Virtual Machine options can be passed using the Clojure CLI](https://clojure.org/reference/deps_and_cli#_prepare_jvm_environment), either via the `-J` command line flag or `:jvm-opts` in a `deps.edn` alias.

<!-- TODO: reference: clojure CLI JVM options - common options and there use (e.g. manage heap size, garbage collection, etc.) -->


## Calling A Clojure Uberjar

JVM options must be specified when calling an uberjar with the Java command, as the project `deps.edn` file is not used by Java.

```
java -jar project-uberjar.jar -J...
```


## Clojure related JVM options

Specify options or system properties to set up the Clojure service

`-Dclojure.compiler.disable-locals-clearing=true` - make more info available to debuggers

`-Dclojure.main.report=stderr` - print stack traces to standard error instead of saving to file, useful if process failing on startup

`-Dclojure.spec.skip-macros=false` - skip spec checks against macro forms


### Memory Management

`-XX:CompressedClassSpaceSize=3G` - prevent a specific type of OOMs

`-XX:MaxJavaStackTraceDepth=1000000` - prevents trivial Stack Overflow errors

`-Xmx24G` - set high maximum heap, preventing certain types of Out Of Memory errors (ideally high memory usage should be profiled if cause not known)

`-Xss6144k` - increase stack size x6 to prevent Stack Overflow errors

> The current default can be found with `java -XX:+PrintFlagsFinal -version 2>/dev/null | grep "intx ThreadStackSize"`

`-Xms6G` - Set minimum memory that is equal or greater than memory used by a running REPL, to improve performance

`-Xmx1G` - limit maximum heap allocation so a process can never use more memory, useful for environments with limited memory resources


```clojure
:jvm/mem-max1g {:jvm-opts ["-Xmx1G"]}
```


### Stack traces

`-XX:+TieredCompilation` - enable tiered compilation to support accurate bench-marking (increases startup time)

`-XX:-OmitStackTraceInFastThrow` - don't elide stack traces


### Startup options

`-Xverify:none` option reduces startup time of the JVM by skipping verification process

```bash
"-Xverify:none"
```

> The verification process is a valuable check, especially for code that has not been run before.  So the code should be run through the verification process before deploying to production.


### Benchmark options

Enable various optimizations, for guaranteeing accurate benchmarking (at the cost of slower startup):

`"-server"`


### Graphical UI related options

`-Djava.awt.headless=true` - disable all UI features for disabling the clipboard for personal security:

`-Dapple.awt.UIElement=true` - remove icon from the MacOSX Dock

`-Dclash.dev.expound=true` - ?



### View JVM options of a running JVM process

Use a JMX client, e.g. [VisualVM](https://visualvm.github.io/)

`jcmd pid VM.system_properties` or `jcmd pid VM.flags` using `jcmd -l` to get the pid of the JVM process

On Linux `ps -ef | grep java` which includes the options to run the JVM process, `ps -auxww` to show long arguments

* [Getting the parameters of a running JVM](https://stackoverflow.com/questions/5317152/getting-the-parameters-of-a-running-jvm)


### References

* [JVM Options cheatsheet - JRebel](https://www.jrebel.com/blog/jvm-options-cheat-sheet)
* [Java 17 Standard Edition Documentation](https://docs.oracle.com/en/java/javase/17/index.html)
* [Java 17 - java command documentation](https://docs.oracle.com/en/java/javase/17/docs/specs/man/java.html)


## Java Environment variables

* `CLASSPATH`
* `JDK_JAVA_OPTIONS`
* `JAVA_OPTS` - deprecated since Java 9, use `JDK_JAVA_OPTIONS`
* `JDK_TOOL_OPTIONS` - specifically for setting options for Java tools (not for use with the `java` command)


## Java command options relevant to Clojure


`--class-path`, `-classpath`, or `-cp` - list of directories, JAR and ZIP archives to search for class files, separated with `:`. Overrides the `CLASSPATH` environment variable. The user class path is the current directory, `.`, when not explicitly set.  Use `*` wildcard to include all `.jar` & `.zip` files in a directory.




--enable-preview
    Allows classes to depend on preview features of the release. https://docs.oracle.com/en/java/javase/12/language/index.html#JSLAN-GUID-5A82FE0E-0CA4-4F1F-B075-564874FE2823


> TODO: move to Clojure book

## java class path with Clojure libraries

The `java` command can be used tor run a Clojure service without an Uberjar of the Clojure service, so long as the  `org.clojure/clojure`, `org.clojure/core.specs.alpha` and `org.clojure/spec.alpha` libraries are included on the class path.  For example, those libraries could be copied to a `lib` directory in the route of the project.


```bash
java -cp lib/clojure-1.11.1.jar:lib/core.specs.alpha-0.2.62.jar:lib/spec.alpha-0.3.218.jar:src clojure.main -m practicalli.game-board
```

Rather than copy the Clojure libraries into the project, libraries could be used from the local Maven cache

```bash
java -cp $HOME/.cache/maven/repository/org/clojure/clojure/1.11.1/clojure-1.11.1.jar:$HOME/.cache/maven/repository/org/clojure/core.specs.alpha/0.2.62/core.specs.alpha-0.2.62.jar:$HOME/.cache/maven/repository/org/clojure/spec.alpha/0.3.218/spec.alpha-0.3.218.jar:src clojure.main -m practicalli.game-board
```

`JDK_JAVA_OPTIONS` can simplify the java command by separating the common options.

```bash
export JDK_JAVA_OPTIONS="-cp /home/practicalli/.cache/maven/repository/org/clojure/clojure/1.11.1/clojure-1.11.1.jar:/home/practicalli/.cache/maven/repository/org/clojure/core.specs.alpha/0.2.62/core.specs.alpha-0.2.62.jar:/home/practicalli/.cache/maven/repository/org/clojure/spec.alpha/0.3.218/spec.alpha-0.3.218.jar:src"
```

The `java` command now just includes the arguments

```bash
java clojure.main -m practicalli.game-board
```

The output from the `java` command shows that it picked up the options

```bash
NOTE: Picked up JDK_JAVA_OPTIONS: -cp /home/practicalli/.cache/maven/repository/org/clojure/clojure/1.11.1/clojure-1.11.1.jar:/home/practicalli/.cache/maven/repository/org/clojure/core.specs.alpha/0.2.62/core.specs.alpha-0.2.62.jar:/home/practicalli/.cache/maven/repository/org/clojure/spec.alpha/0.3.218/spec.alpha-0.3.218.jar:src
Hello, World!
```


> Obviously this is not an optimal approach and only for background


