---
category: Microsoft Azure DevOps Repos
severity: Important
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled.md
---

# Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled

## SYNOPSIS

Enable GitHub Advanced Security for the repository for a suite of security features.

## DESCRIPTION

GitHub Advanced Security provides a suite of security features for Azure DevOps
repositories. This rule checks if GitHub Advanced Security is enabled for the
repository.

GitHub Advanced Security adds the following features:

- Code scanning
- Secret scanning push protection
- Secret scanning repo scanning
- Dependency scanning

## RECOMMENDATION

Consider enabling GitHub Advanced Security for the repository.

## LINKS

- [Configure GitHub Advanced Security](https://learn.microsoft.com/en-us/azure/devops/repos/security/configure-github-advanced-security-features?view=azure-devops&tabs=yaml)
