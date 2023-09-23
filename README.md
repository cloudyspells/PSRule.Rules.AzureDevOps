# PSRule.Rules.AzureDevOps

![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/PSRule.Rules.AzureDevOps?logo=powershell&link=https%3A%2F%2Fwww.powershellgallery.com%2Fpackages%2FPSRule.Rules.AzureDevOps)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSRule.Rules.AzureDevOps?logo=powershell&link=https%3A%2F%2Fwww.powershellgallery.com%2Fpackages%2FPSRule.Rules.AzureDevOps)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/cloudyspells/PSRule.Rules.AzureDevOps/module-ci.yml?label=Pester%20Unit%20Tests)
[![codecov](https://codecov.io/gh/cloudyspells/PSRule.Rules.AzureDevOps/graph/badge.svg?token=SULG2MXS9U)](https://codecov.io/gh/cloudyspells/PSRule.Rules.AzureDevOps)

## Azure DevOps rules module for PSRule

This powershell module is built to be used with
[Bernie White's](https://github.com/BernieWhite) excellent
[PSRule](https://github.com/microsoft/PSRule) module to check
an Azure DevOps project against some best practices for a
secure development environment.

This module is very much in early stage of development and
should not be considered stable. Any input on the direction
of the module and included rules is very much appreciated.
Please consider opening an issue with your ideas.

![Screenshot of version 0.0.9 run](assets/media/run-0.0.9.png)

## Usage

To use this module, you need to have _PSRule_ installed.
You can install it from the PowerShell Gallery:

```powershell
Install-Module -Name PSRule -Scope CurrentUser
```

Once you have PSRule installed, you can install this module
from the PowerShell Gallery:

```powershell
Install-Module -Name PSRule.Rules.AzureDevOps -Scope CurrentUser
```

Once you have both modules installed, you can run an export of
your Azure DevOps project and run the rules against it. The `-PAT`
value needs to be an Azure DevOps Personal Access Token with
sufficient permissions to read the project data.

```powershell
Export-AzDevOpsRuleData `
    -Organization "MyOrg" `
    -Project "MyProject" `
    -PAT $MyPAT `
    -OutputPath "C:\Temp\MyProject"
Assert-PSRule `
    -InputPath "C:\Temp\MyProject\" `
    -Module PSRule.Rules.AzureDevOps
```

Since version 0.0.8 of this module, you can also export the
data at the organization level, looping through all projects
in the organization the PAT has access to.

```powershell
Export-AzDevOpsOrganizationRuleData `
    -Organization "MyOrg" `
    -PAT $MyPAT `
    -OutputPath "C:\Temp\MyOrg"
```

## Rules

Documentation for the implemented rules can be found in the
[en](src/PSRule.Rules.AzureDevOps/en/) folder.

- [Azure.DevOps.Pipelines.Core.UseYamlDefinition](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.UseYamlDefinition.md)
- [Azure.DevOps.Pipelines.Environments.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.Description.md)
- [Azure.DevOps.Pipelines.Environments.ProductionCheckProtection](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md)
- [Azure.DevOps.Pipelines.Environments.ProductionHumanApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md)
- [Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md)
- [Azure.DevOps.Repos.BranchPolicyAllowSelfApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyAllowSelfApproval.md)
- [Azure.DevOps.Repos.BranchPolicyCommentResolution](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyCommentResolution.md)
- [Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems.md)
- [Azure.DevOps.Repos.BranchPolicyIsEnabled](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyIsEnabled.md)
- [Azure.DevOps.Repos.BranchPolicyMergeStrategy](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMergeStrategy.md)
- [Azure.DevOps.Repos.BranchPolicyMinimumReviewers](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMinimumReviewers.md)
- [Azure.DevOps.Repos.BranchPolicyResetVotes](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyResetVotes.md)
- [Azure.DevOps.Repos.HasBranchPolicy](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.HasBranchPolicy.md)
- [Azure.DevOps.Repos.License](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.License.md)
- [Azure.DevOps.Repos.Readme](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.Readme.md)
- [Azure.DevOps.ServiceConnections.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Description.md)
- [Azure.DevOps.ServiceConnections.ProductionCheckProtection](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionCheckProtection.md)
- [Azure.DevOps.ServiceConnections.ProductionHumanApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionHumanApproval.md)
- [Azure.DevOps.ServiceConnections.Scope](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Scope.md)
- [Azure.DevOps.Tasks.VariableGroup.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.Description.md)
- [Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md)
