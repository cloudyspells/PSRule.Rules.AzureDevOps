---
category: Microsoft Azure DevOps Pipelines
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork.md
---

# Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork

## SYNOPSIS

Project settings should restrict access to secrets for pull requests from a fork.

## DESCRIPTION

Secrets can be used to store sensitive information such as passwords and access tokens. Secrets can be used in pipelines to access resources such as Azure Key Vault. Secrets can be configured to be available to all pipelines or only to specific pipelines. Secrets can also be configured to be available to pull requests from forks. This can be useful for open source projects that accept contributions from the community. However, this can also be a security risk. A malicious user could create a pull request from a fork and access the secrets in the pipeline. This could allow the malicious user to access sensitive information such as passwords and access tokens.

## RECOMMENDATION

Consider restricting access to secrets for pull requests from a fork in the project settings.

## LINKS

- [Azure DevOps Security best practices - Forks](https://learn.microsoft.com/en-us/azure/devops/pipelines/security/repos?view=azure-devops#dont-provide-secrets-to-fork-builds)
