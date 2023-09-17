---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en-US/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md
---

# An environment scoped to production should be protected with a human approval

## SYNOPSIS

An environment scoped to production should be protected by a human review
and approval. This will help ensure no accidental changes are made to the
production resources.

## DESCRIPTION

Protecting a service connection with a human check will help prevent accidental
changes to production resources. For example, a service connection scoped to
production should be protected with a check that requires a minimum number of
reviewers or a specific CI pipeline must pass.

## RECOMMENDATION

Consider protecting a service connection scoped to production with a human
approval check.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)
- [Create an environment](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops&tabs=yaml#create-an-environment)
