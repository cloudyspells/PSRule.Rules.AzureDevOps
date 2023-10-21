---
category: Repository
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md
---

# Azure.DevOps.ServiceConnections.ProductionBranchLimit

## SYNOPSIS

A production service connection should be limited in the branches it can be used
in.

## DESCRIPTION

A production service connection should be limited in the branches it can be used
in. This ensures that the service connection is not used in a non-production
branch. This rule checks that the service connection is limited to a production
branch.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider limiting the service connection to a production branch.

## LINKS

- [Azure DevOps Service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops)
