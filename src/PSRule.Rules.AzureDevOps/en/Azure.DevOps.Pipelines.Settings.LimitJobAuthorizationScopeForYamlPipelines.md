---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines.md
---

# Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines

## SYNOPSIS

Project settings should limit job authorization scope for YAML pipelines.

## DESCRIPTION

YAML pipelines can be used to deploy to multiple environments. Each environment
can be configured to use a different set of resources. Limiting the job authorization
scope to the current project will prevent the job from being able to access resources
in other projects. This can help prevent accidental access to resources in other projects.

## RECOMMENDATION

Consider limiting the job authorization scope for YAML pipelines to the current project in the project settings.

## LINKS

- [Azure DevOps Security best practices - Tasks](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
