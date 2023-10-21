---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Core.InheritedPermissions.md
---

# Azure.DevOps.Pipelines.Core.InheritedPermissions

## SYNOPSIS

Pipeline permissies mogen niet worden geërfd van het project.

## DESCRIPTION

Pipeline permissies mogen niet worden geërfd van het project. Geërfde
permissies kunnen leiden tot onverwachte toegang tot resources.

Mininum TokenType: `FineGrained`

## RECOMMENDATION

Overweeg om geërfde permissies uit de pipeline te verwijderen en expliciet
permissies in te stellen.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/nl-nl/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
