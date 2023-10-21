---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionHumanApproval.md
---

# Azure.DevOps.ServiceConnections.ProductionHumanApproval

## SYNOPSIS

A service connection scoped to production should be protected by a human review
and approval. This will help ensure no accidental changes are made to the
production resources.

## DESCRIPTION

Protecting a service connection with a human check will help prevent accidental
changes to production resources. For example, a service connection scoped to
production should be protected with a check that requires a minimum number of
reviewers or a specific CI pipeline must pass.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider protecting a service connection scoped to production with a human
approval step.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

