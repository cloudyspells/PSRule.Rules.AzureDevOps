---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Repos.InheritedPermissions.md
---

# Azure.DevOps.Repos.InheritedPermissions

## SYNOPSIS

Repository permissies mogen niet worden geërfd van het project.

## DESCRIPTION

Repository permissies mogen niet worden geërfd van het project. Geërfde
permissies kunnen leiden tot onverwachte toegang tot repositories en branches.

## RECOMMENDATION

Overweeg om geërfde permissies uit de repository te verwijderen en expliciet
permissies in te stellen.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
