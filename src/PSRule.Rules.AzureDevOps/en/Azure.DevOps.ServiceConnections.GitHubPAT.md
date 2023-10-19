---
category: Microsoft Azure DevOps Service Connections
severity: Severe
online version: https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/blob/main/src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.GitHubPAT.md
---

# Azure.DevOps.ServiceConnections.GitHubPAT

## SYNOPSIS

A service connection should not use a GitHub Personal Access Token (PAT).

## DESCRIPTION

A service connection is a secure stored object that contains information about how to
connect to a service. Service connections are used during the build or release pipeline
to connect to external and remote resources. The GitHub PAT service connection type is
linked to a personal account and cannot be traced back to the specific connection from
Azure DevOps. This means any user with access to the service connection can impersonate
the user who created the service connection.

## RECOMMENDATION

Consider using an oauth-based service connection.

## LINKS

- [Azure DevOps security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-github-integrations)
- [Create a service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/connect-to-azure?view=azure-devops)
