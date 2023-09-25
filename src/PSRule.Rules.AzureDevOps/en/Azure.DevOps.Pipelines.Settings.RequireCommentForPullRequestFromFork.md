---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork.md
---

# Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork

## SYNOPSIS

Project settings should require a comment for pull requests from a fork.

## DESCRIPTION

Before building a fork, a member of the project should review the changes and approve the pull request. This can help prevent malicious code from being introduced into the project.

## RECOMMENDATION

Consider requiring a comment for pull requests from a fork in the project settings.

## LINKS

- [Azure DevOps Security best practices - Repos and branches](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#repositories-and-branches)
