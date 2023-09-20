---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en-US/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md
---

# Azure.DevOps.Pipelines.Environments.ProductionCheckProtection

## SYNOPSIS

An environment scoped to production should be protected with one or more
checks to prevent accidental changes to production resources.

## DESCRIPTION

An environment scoped to production should be protected with one or more
checks to prevent accidental changes to production resources. Checks can
be used to require a user to approve a deployment or require a successful
build before a deployment can be made.

## RECOMMENDATION

Consider adding one or more checks to the environment.

## LINKS

- [Define approvals and checks](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)
- [Create an environment](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops&tabs=yaml#create-an-environment)
