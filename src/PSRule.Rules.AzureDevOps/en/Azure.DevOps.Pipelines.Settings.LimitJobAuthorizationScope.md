---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope.md
---

# Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope

## SYNOPSIS

Project settings should limit job authorization scope.

## DESCRIPTION

Limiting the job authorization scope to the current project will prevent the job from
being able to access resources in other projects. This can help prevent accidental
access to resources in other projects.

## RECOMMENDATION

Consider limiting the job authorization scope to the current project in the project settings.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
