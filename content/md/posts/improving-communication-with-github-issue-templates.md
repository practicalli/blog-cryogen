{:title "Improving communication with GitHub issue templates"
 :date "2019-11-02"
 :layout :post
 :topic "github"
 :tags  ["github"]}

Create templates for issues and pull requests can greatly improve feedback and contributions, especially as an open source project maintainer.

Templates can ask people to provide specific information, or request use of a tool for generating system information (e.g. Spacemacs).  Automatic assignment and labelling saves time on issue triage by the project maintainers.

Templates can be created for most shared Git repository services, i.e GitHub, GitLab, BitBucket, etc.

We will discuss what to include in these templates and use GitHub as an example of how to create them.


## Creating a template on GitHub

In your GitHub project, open the **Settings** tab and scroll down to the **features** section.

Ensure **Issues** is selected and click on the **Set up templates** button

![GitHub features - templates setup](/images/github-settings-features-templates.png)


Select an existing template to change it or select **Custom template** to create a new blank template.

![GitHub templates - select template](/images/github-templates-select-template.png)

## Changing an existing template

You can change everything about an existing template, even the name.

![GitHub templates - edit issue bug report](/images/github-templates-bug-report-edit.png)

Click the pencil icon to edit the template and change as much as you wish.

Click **Close preview** to finish editing.

The filename will be renamed to the **Template name** of the issue template once you save

Here is an example of changing the bug to an article template.

![GitHub template - article edit](/images/github-templates-article-edit.png)

## Saving the template

Click the **Propose changes** button to make the change permanent, entering a commit message and committing changes.

![GitHub templates - propose change](/images/github-templates-propose-changes.png)

Once you commit a template it can be found in the directory **.github/ISSUE_TEMPLATE/** directory.

![GitHub templates - committed templates](/images/github-templates-committed-template.png)


## Creating an issue with a template

Click the **New issue** button to choose a template for a new issue.

![GitHub templates - new issue with template](/images/github-templates-new-issue.png)

All the available templates are now listed when creating a new issue.  There is also a link to **Edit teamplates** if you have access rights on the repository.

There is also a link to create a blank issue.

![GitHub templates - new issue with article template](/images/github-templates-new-issue-article-template.png)

The issue has the article label and the text of the template, making it simple for a contributor to add information that helps the project maintainer.

![GitHub templates - new issue with article template - edit](/images/github-templates-new-issue-article-template-edit.png)

A contributor can always choose a different type of issue template before submitting the issue.

## Summary

Adding Issue templates is really easy and saves a lot of time getting the basics of communication established between contributors and project maintainers.

Templates minimise the amount of work a project maintainer has to do for each issue and also supports contributors involvement be much more efficient.
