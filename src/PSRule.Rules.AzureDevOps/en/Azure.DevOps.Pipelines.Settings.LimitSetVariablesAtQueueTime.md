---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime.md
---

# Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime

## SYNOPSIS

Project settings should limit setting variables at queue time.

## DESCRIPTION

Setting variables at queue time can be used to override variables defined in the
pipeline. This can be useful for testing or debugging. However, this can also be
used to override variables that are used to control the behavior of the pipeline
and may result in unexpected behavior.

Mininum TokenType: `ReadOnly`

## RECOMMENDATION

Consider disabling the ability to set variables at queue time in the project settings.

## LINKS

- [Azure DevOps Security best practices - Policies](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies)
