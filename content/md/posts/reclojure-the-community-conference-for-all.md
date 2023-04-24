{:title "re:Clojure - the Clojure community conference for all"
 :layout :post
 :date "2019-12-03"
 :topic "clojure"
 :tags  ["re-clojure" "events"]}

[re:Clojure](https://reclojure.org/) was a rapidly assembled conference created by several of the London Clojurian community members, after the closing of SkillsMatter who for 8 years ran an a Clojure conference in London. Luckily many of the speakers were available to talk at the this new conference and several members of the community made it all happen, with the help of lots of wonderful sponsors

All the talks were recorded and videos will be published soon, so [subscribe to the re:Cojure YouTube channel](https://www.youtube.com/channel/UCbZW8yCqEncYciie8_1yy7w) and be notified when they are available.

Here are some of my highlights from the re:Clojure conference.

<!-- GitHub issues -->
<!-- https://github.com/practicalli/blog-content/issues/23 -->

<!-- more -->

![reClojure audience](/images/reclojure-tweet-audience.png)

## A few of my favourite talks (they were all great)

I loved all the talks at re:Clojure and we are all so grateful for all the people who volunteered to share their experiences with us.  Here are just a few of my favourites.

[Clément Salaün](https://twitter.com/superzamp?lang=en) came over from France to live code 3D objects using Clojure and [OpenSCAD](https://www.openscad.org/).  [OpenSCAD](https://www.openscad.org/) is a free software tool for creating solid 3D CAD objects, for Linux/UNIX, MS Windows and Mac OS X.

It was amazing to see real time updates to the 3D model as Clojure code was evaluated.  Clement also brought some of the pieces already brought to life with a 3D printer and shared them with the audience.  I have long been interested in 3D modelling and animation with [Blender](https://www.blender.org/), so its great to see something similar with Clojure.

![reClojure 3d printing with clojure](/images/reclojure-tweet-3d-printing.png)

[Peter Westmacott](https://github.com/peterwestmacott) gave an engaging lesson in mathematics including imaginary numbers and strange attractors, all leading up to building fractal images with Clojure and the Mandelbrot set.  Again there was live coding to drive the fractal graphics.

![reClojure - Peter Westmacott - Mandelbrot generator in Clojure](/images/reclojure-tweet-mandelbrot.png)

[Dana Borinski](https://twitter.com/_danabor) is a developer with [AppsFlyer](https://twitter.com/AppsFlyerDev) who really love Clojure.  They process 90 Billion events per day using Clojure, so they really do love Clojure.  Dana created [mate-clj](https://github.com/AppsFlyer/mate-clj) to help developers debug their code.  The [mate-clj library](https://github.com/AppsFlyer/mate-clj) prints every execution step to the Clojure REPL, providing lots of lovely information to see exactly what happens when you evaluate code.  This is a great aid to help you to debug your code and understand what its doing under the covers.

![reClojure - Dana Borski - loves REPL](/images/reclojure-tweet-dana-loves-repl.png)


[Malcolm Sparks](https://juxt.pro/people/mal.html), a co-founder of [JUXT](http://juxt.pro/) the well regarded Clojure consultancy company, gave an insightful keynote to round out the day.  Malcolm discussed the point that a computer has 3 jobs, capture data, process data and output data.  Most languages do one of these well.

Systems have evolved to be very centred around data and transmitting data between applications.  Object serialisation probably one of the biggest mistakes made, certainly Sun regretted making that available in Java and hastily introduced XML to try cover up that mistake.  XML and SOAP introduced a repository for looking up schema information and versioning of schema too.

![reClojure - Malcolm Sparks - Code meet data](/images/reclojure-tweet-malcolm-sparks.png)

A clean data format improve the way our systems work, and by transmit their schema along with the data then.  JSON is a data format that has more potential than you may originally have considered.  JSON is not only ubiquitous and easily accessible from all major programming languages, when coupled with JSON schema you also set your data free from the constraints of a particular language.

![reClojure - JUXT - Jinx JSON schema processing](/images/reclojure-tweet-juxt-jinx.png)


## Huge thanks to the sponsors

![reClojure - Sponsors](/images/reclojure-sponsors.png)


## Feedback from the Conference

See the [#reclojure tag on twitter](https://twitter.com/search?q=%23reclojure) for more feedback from the conference.


## The future of re:Clojure

The organisers plan was to have re:Clojure as the start of many more community conferences in the future, both in London and around the UK.  Over the next few months there will be more details shared about running a conference so anyone in the community can drive it.

Thank you.
