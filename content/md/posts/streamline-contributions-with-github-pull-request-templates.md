{:title "Streamline Contributions with GitHub Pull Request Templates"
 :date "2019-11-05"
 :layout :post
 :topic "github"
 :tags  ["github"]}

Pull requests are very valuable to project maintainers, especially if they follow guidelines for the project.  Using a pull request template allows project maintainers to define the most effective way to contribute right inside the contribution projects.

Project maintainers, especially on very active projects, rarely have time to spend on triage of pull requests.  Generally the simpler a pull request the easier it is for a maintainer to review it and accept it.

Previously we created GitHub issue templates, for which their can be many.  one pull request template as all pull requests are the same type.

We will discuss what to include in these pull request templates and use GitHub as an example of how to create them.

## What to put in a pull request template

Guidelines that are important to you as a maintainer should go in the template, especially on open source projects where you have a very diverse audience.

* coding style and formatting rules the project follows
* license used for contributions
* the pull request review process (or link to it)
* the scale of changes preferred (usually very small and specific)

Define specific content that any pull request should include to make it worth reviewing

* referring to one or more related issues
* a meaningful description of the proposed change the pull request proposes
* a single commit
* mention a specific GitHub user using the `@` character followed by the users name

Look at the examples towards the end of this article for inspiration.

> Mentioning different maintainers when you have multiple pull request templates can help deligate work automatically and reduce the amount of triage to be done on a pull request.
>
> Even with a single pull request template, you may wish to have yourself mentioned to receive a notification for each pull request.
>
> Automation of mentions (and other metadata) is done [using query parameters with issues and pull requests](https://help.github.com/en/github/managing-your-work-on-github/about-automation-for-issues-and-pull-requests-with-query-parameters).


## Single or multiple pull request templates

GitHub defines [several locations where you can add a pull request template](https://help.github.com/en/github/building-a-strong-community/creating-a-pull-request-template-for-your-repository), in the root of the project, in `/docs` or in the hidden directory `.github`.  GitHub will look in each of these locations for a template.

I recommend using `.github` as the base location for your templates as this is where the GitHub template editor saves [issue templates](improving-communication-with-github-issue-templates.md).

* `.github/pull_request_template.md` - for a single pull request template
* `.github/PULL_REQUEST_TEMPLATE/one_of_many_template.md` - for multiple templates, each with a unique name.

## Add template to local project

Create a template file in your favourite editor and save it to `.github/pull_request_template.md`.

Commit this file into your local repository, to the default branch set in GitHub.  You must use the default GitHub branch or the template will not be visible.

![GitHub templates - repository default branch](/images/github-templates-repository-default-branch.png)


## Add a template using GitHub

Unlike issue templates, there is no specific editor for pull request templates (at time of writing), so just use the generic **Create new file** editor.

Select **Create new file** button to open a file editor.

Update the file name to `.github/pull_request_template.md`.

![GitHub templates - pull request - edit new file](/images/github-templates-pull-request-edit-new-file.png)

Add the information you wish to add to the pull request template and commit the file.

![GitHub templates - pull request - edit new file](/images/github-templates-pull-request-new-file-commit.png)

entering a commit message and click the **Commit new file** button to add the template to the repository.

![GitHub templates - commit new template](/images/github-templates-create-new-file-commit.png)


## Creating a pull request with a template

Every time a new pull request is created, the default template is shown.


The issue has the article label and the text of the template, making it simple for a contributor to add information that helps the project maintainer.

![GitHub templates - new issue with article template - edit](/images/github-templates-new-issue-article-template-edit.png**

A contributor can always choose a different type of issue template before submitting the issue.


## Example Pull Request templates

**Clojure Website**

The Clojure website repository has quite a simple template, reminding you of just a few essentials

```markdown
- [ x] Have you read the [guidelines for contributing](https://clojure.org/community/contributing_site)?
- [ x] Have you signed the Clojure Contributor Agreement?
- [ x] Have you verified your asciidoc markup is correct?
```


**Practicalli**

The [pull request template used by Practicalli](https://github.com/practicalli/blog-content/blob/master/.github/pull_request_template.md) is quite detailed and encourages very specific pull requests, so I minimise time doing triage on those pull requests (as I prefer to just create content).

```markdown
Please follow these guidelines when submitting a pull request

- refer to all relevant issues, using `#` followed by the issue number (or paste full link to the issue)
- PR should contain the smallest possible change
- PR should contain a very specific change
- PR should contain only a single commit (squash your commits locally if required)
- Avoid multiple changes across multiple files (raise an issue so we can discuss)
- Avoid a long list of spelling or grammar corrections.  These take too long to review and cherry pick.


## Submitting articles
[Create an issue using the article template](https://github.com/practicalli/blog-content/issues/new?assignees=&labels=article&template=article.md&title=Suggested+article+title),
providing as much detail as possible.

## Website design
Suggestions about website design changes are most welcome, especially in terms of usability and accessibility.

Please raise an issue so we can discuss changes first, especially changes related to aesthetics.


## Review process
All pull requests are reviewed by @jr0cket and feedback provided, usually the same day but please be patient.
```


## Summary

Adding Issue templates is really easy and saves a lot of time getting the basics of communication established between contributors and project maintainers.

Templates minimise the amount of work a project maintainer has to do for each issue and also supports contributors involvement be much more efficient.
