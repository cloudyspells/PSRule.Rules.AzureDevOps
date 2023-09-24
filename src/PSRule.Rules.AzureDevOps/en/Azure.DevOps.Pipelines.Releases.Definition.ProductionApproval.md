---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md
---

# Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval

## SYNOPSIS

An environment scoped to production should be protected by a human review

## DESCRIPTION

Protecting a release pipeline production stage with a human check will help prevent
accidental changes to production resources. For example, a service connection scoped
to production should be protected with a check that requires a minimum number of
reviewers or a specific CI pipeline must pass.

You can configure the minimum number of approvers for this rule by setting the
`releaseMinimumProductionApproverCount` configuration value in PSRule. The default
value is `1`.

## RECOMMENDATION

Consider protecting a release stage environment scoped to production with a human
approval check.

## LINKS

- [Release Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/?view=azure-devops)
