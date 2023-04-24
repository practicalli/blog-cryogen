{:title "Overview of Language Server Protocol LSP for Clojure development"
 :layout :post
 :date "2021-03-20"
 :topic "clojure-lsp"
 :tags  ["lsp" "clojure"]}

Microsoft Language Server Protocol, LSP, is exactly what the name says it is.  Its a (JSON RPC) protocol.  Its no more and no less than that.  LSP is however a big strategy peace for Mircrosoft to encourage developers to adopt VS Code, which naturally provides support for the LSP protocol.  The implementation of tooling that uses LSP is left to companies and communities that develop editor and related tools.

Standards can be an opportunity to focus development work and provide a rich set of tools that are far easier to integrate.  There are many examples of where a protocol has provided a huge amount of diversity, such as TCP/IP, DNS, HTTP and HTML protocols that drove the creation of the web we know today. Standard protocols in themselves did not make the web, but allowed developers to build on top of them and create the rich and diverse experience on the web that we see today.

LSP is no different.  By itself LSP provides no benefit.  However, when adopted as a standard by tooling developers it has the potential to help grow an even richer experience for the whole developer community.

That is the promise of LSP, but is it delivering?  Is LSP improving the Clojure development experience?  Is LSP right for you (right now)?

<!-- more -->

## LSP language features

LSP protocol should enable a standard set of features for editing, however, this is completely dependent on the LSP server and editor client implementations.  Each LSP server is typically programming language specific, as much analysis of the language is required to provide these features.  The information presented by editors using LSP servers is typically language specific too.

An LSP language server typically provides the static analysis of a project to provide an editor the data to create the following features

* Auto-completion - symbols, functions, namespaces, etc.
* Code actions - extracting common code into functions, alter privacy, etc.
* Live linting - surfacing errors as they occur
* Namespace management - add namespaces / package names
* Navigation - jump to function / method definitions
* Refactor code - renaming symbols across projects
* Semantic tokens - highlight symbol throughout the code and provide detailed syntax colouring
* Show references - where functions are called from, call hierarchy


> Navigating call references can be valuable when trying to learn (and fix / refactor) an unfamiliar code base.  References provide an indication of how used function definitions are and provide a way to navigate to the parts of the code where a function is called.

LSP tooling for Clojure is collectively provided by the language server implementation and the editor user interface design.  There is a challenge in surfacing this static analysis data in a manor that is meaningful and doesn't interrupt the developer workflow.


![Clojure LSP](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/clojure-language-server.png)


## LSP support for Clojure

[clojure-lsp](https://github.com/clojure-lsp/clojure-lsp) is currently the only implementation of a language server for Clojure.  The clojure-lsp project takes a static analysis approach similar to that of IntelliJ and the Cursive extension.  Unlike cursive, the clojure-lsp project is open source and now also makes use of clj-kondo for static analysis of code.  As clojure-lsp is the only implementation for Clojure it does focus all the community effort in one project.  However, this project is still actively being developed and there is much development of tooling around this project, especially integrating these features with existing tools such as CIDER.

The [Calva](https://calva.io/) project (VS Code extension) recently took the decision to implement its features extensively on Clojure-lsp.  This makes a lot of sense as the Microsoft VS Code tool has extensive support for the language server protocol.  The decision to leverage LSP should significantly reduce the amount of work required to bring Calva to feature parity with Cursive and CIDER.  The adoption of clojure-lsp by Calva has also increased the amount of work going into the cloure-lsp project in the last few months.

Emacs [lsp-mode](https://emacs-lsp.github.io/lsp-mode/) project provides an Emacs client for clojure-lsp, using lsp-ui, treemacs, helm, ivy, iedit and ido packages to surface LSP features.  Integration with CIDER can be tricky as CIDER already provides the majority of features LSP implements.  So [a minimal approach to LSP usage](https://practicalli.github.io/spacemacs/install-spacemacs/clojure-lsp/configure-lsp-and-cider.html) especially in the UI and code formatting is highly recommended to start with.

Neovim adds [native LSP support](https://neovim.io/doc/user/lsp.html) in version 5 when released (available in nightly builds) which can be used with Conjure and Command of Control vim plugins.

Each of these editors already provide a wide range of features via LSP, although there is still implementation, testing, UI design and documentation to be produced.  It can be some effort to get a good experience with LSP, so ensure you know what features you want to add, disabling any features you do not need.

> IntelliJ provides much of the framework for Cursive static analysis and UI, so it seems unlikely that Cursive will change over to LSP any time soon.


## LSP and the REPL

LSP features should be seen as complementary to the highly interactive and dynamic nature of the Clojure REPL driven development.

A REPL runs Clojure code during development and typically in production (unless its AOT compiled or native compiled with Graal).  The REPL provides an instant feedback cycle that is so intrinsic to learning Clojure and designing with Clojure effectively.  Without the REPL a developer looses the most important aspect of the Clojure workflow.

The benefit from LSP tooling will vary greatly based on the development tools used and a developers experience with using static analysis driven tooling.  Most Clojure developers find clj-kondo an invaluable tool that provides live linting as they write code, ensuring syntax issues are avoided and idioms are more closely followed.  clj-kondo has a very simple user interface and a focus on syntax checking.  LSP tooling covers a far wider scope and therefore needs investment to build the many features and providing them in a way that is meaningful.

Developers who have worked with statically typed languages will benefit the most from LSP tooling, providing them with features they are familiar with.

> Archaeology of unfamiliar or complex code bases can benefit from the data provided by static analysis of code, such as call references.


## Extending the reach of Clojure

Becoming accustom to REPL driven development takes an investment in time, mainly because its different to the way other languages are developed.  By providing common editor features, lsp can provide developers with common features to speed up their learning curve a little.  Having some recognisable features can help to break down the resistance naturally felt when learning a lisp style language such as Clojure.

Ultimately, time should still be spent learning REPL driven development to become more effective at developing with Clojure.  However, LSP features should encourage more developers to give Clojure a try.


## Summary

For experienced Clojure developers who are skilled with REPL driven development and have invested time in sophisticated tooling (CIDER, Reveal, Portal), then there is very little extra benefit to LSP in the short term.  If you are productive with your current development environment, its unlikely that LSP tooling will provide a significant enhancement to your development experience.

Given the rich set of features LSP can offer, the biggest challenge is often making sense of them and understanding how they could be used.  As more documentation and guides are created, the value of these features should become more apparent to a wider audience.

Having an extensive set of tools for a wide range of editors that support interactive and static driven development seamlessly will improve the experience of all developers using and curious about learning Clojure.  This should lead to even more tooling for Clojure development by using the common services that clojure-lsp and LSP aware editors provide.

If you already know you are missing IDE like features in your Clojure development workflow, or just curious to learn, then dive right into using clojure-lsp and configuring your editor to make the most out these LSP features.

It will be interesting to see how far tooling around LSP can evolve.  There are a lot of features that work very well today and there are still more to come.

> [Practicalli Spacemacs provides a minimal configuration for clojure-lsp, cljfmt, lsp-mode and lsp-ui packages](https://practicalli.github.io/spacemacs/install-spacemacs/clojure-lsp/configure-lsp-and-cider.html), to work in an optimal way for those already familiar with Cider.

Thank you
[@practical_li](https://twitter.com/practical_li)
