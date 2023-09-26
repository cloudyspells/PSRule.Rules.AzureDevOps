---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments.md
---

# Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments

## SYNOPSIS

Project settings should enforce sanitization of shell task arguments to prevent command injection.

## DESCRIPTION

Shell tasks can be used to run arbitrary commands on the agent. If the arguments are not sanitized, it is possible for a malicious actor to inject additional commands into the arguments. This can lead to the execution of malicious code on the agent.

## RECOMMENDATION

Consider enforcing sanitization of shell task arguments in the project settings.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks)
