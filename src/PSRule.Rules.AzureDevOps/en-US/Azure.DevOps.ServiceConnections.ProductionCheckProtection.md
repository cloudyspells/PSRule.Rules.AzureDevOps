---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en-US/Azure.DevOps.ServiceConnections.ProductionCheckProtection.md
---

# Azure.DevOps.ServiceConnections.ProductionCheckProtection

## SYNOPSIS

A service connection scoped to production should be protected. This will help
ensure no accidental changes are made to the production resources.

## DESCRIPTION

Protecting a service connection with one or more checks will help prevent
accidental changes to production resources. For example, a service connection
scoped to production should be protected with a check that requires a minimum
number of reviewers or a specific CI pipeline must pass.

## RECOMMENDATION

Consider protecting a service connection scoped to production with one or
more checks.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)

