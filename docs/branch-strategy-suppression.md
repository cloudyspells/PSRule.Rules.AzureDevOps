Branch strategy based suppression
=================================

Using PSRule suppression groups for branch strategies.
------------------------------------------------------

Since version 0.4.0 PSRule.Rules.AzureDevOps exports all branches
for a repository and inspects them with the full set of rules. Under
normal circumstances, you don't want to run all rules against all
branches. You will typically want users to work in feature branches that
do not have the same requirements as the main, release or your custom
branches.

PSRule offers a feature called suppression groups that allows you to
suppress rules for _targets_, in our case branches. This allows you to
define a set of suppression groups that can be applied to branches
based on a branch name pattern.

For example, you can define a suppression group called `feature` that
suppresses all rules for branches that start with `refs/heads/feature/`.
Place the file in the root from where you run PSRule with an extension
of `.Rule.yaml`.

``` yaml
---
# Synopsis: Feature branch does not need protection
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: 'feature'
spec:
  expiresOn: null
  rule:
    - 'Azure.DevOps.Repo.Branch.HasBranchPolicy'
  if:
    name: '.'
    contains: 'refs/heads/feature/'
```

The synopsis is optional and can be used to describe
the suppression group. It will be displayed when running
PSRule as the suppression group is applied. Read more on suppression
groups in the [PSRule documentation](https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_SuppressionGroups/).