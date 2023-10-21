---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionBranchLimit.md
---

# Azure.DevOps.Pipelines.Environments.ProductionBranchLimit

## SYNOPSIS

A production environment should be limited to the branches it can be used in.

## DESCRIPTION

A production environment should be limited to the branches it can be used in. This ensures
the environment is not used in a non-production branch. This rule checks if the
environment is limited to a production branch.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Consider limiting the environment to a production branch.

## LINKS

- [Azure DevOps Pipelines Environments](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments)
