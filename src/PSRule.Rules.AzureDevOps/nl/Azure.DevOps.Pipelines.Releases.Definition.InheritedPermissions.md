---
category: Microsoft Azure DevOps Repos
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/nl/Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions.md
---

# Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions

## SYNOPSIS

Release Pipeline permissies mogen niet worden overgenomen van het project.

## DESCRIPTION

Release Pipeline permissies mogen niet worden overgenomen van het project. Geërfde
permissies kunnen leiden tot onverwachte toegang tot resources.

## RECOMMENDATION

Overweeg om geërfde permissies uit de release pipeline te verwijderen en expliciete
permissies in te stellen.

## LINKS

- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#scoped-permissions)
