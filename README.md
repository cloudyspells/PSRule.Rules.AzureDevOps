# PSRule.Rules.AzureDevOps

[![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/PSRule.Rules.AzureDevOps?logo=powershell&link=https%3A%2F%2Fwww.powershellgallery.com%2Fpackages%2FPSRule.Rules.AzureDevOps)](https://www.powershellgallery.com/packages/PSRule.Rules.AzureDevOps)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSRule.Rules.AzureDevOps?logo=powershell&link=https%3A%2F%2Fwww.powershellgallery.com%2Fpackages%2FPSRule.Rules.AzureDevOps)](https://www.powershellgallery.com/packages/PSRule.Rules.AzureDevOps)
[![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/cloudyspells/PSRule.Rules.AzureDevOps/module-ci.yml?label=Pester%20Unit%20Tests)](https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/actions/workflows/module-ci.yml)
[![codecov](https://codecov.io/gh/cloudyspells/PSRule.Rules.AzureDevOps/graph/badge.svg?token=SULG2MXS9U)](https://codecov.io/gh/cloudyspells/PSRule.Rules.AzureDevOps)

## PSRule Module for Azure DevOps

This powershell module is built to be used with
[Bernie White's](https://github.com/BernieWhite) excellent
[PSRule](https://github.com/microsoft/PSRule) module to check
an Azure DevOps project for best practices for a
secure development environment. The module takes best practices from the official
[Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops) documentation. It can
function as a periodic security scan and check for your Azure DevOps project.

This module is very much in early stage of development and
should not be considered stable. Any input on the direction
of the module and included rules is very much appreciated.
Please consider opening an
[issue](https://github.com/cloudyspells/PSRule.Rules.AzureDevOps/issues)
with your ideas.

![Screenshot of version 0.0.11 Sarif output in Azure DevOps](assets/media/sarif-0.0.11.png)

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
your Azure DevOps project and run the rules on the exported data.
The `-PAT` value needs to be an Azure DevOps Personal Access Token
with sufficient permissions to read the project data.

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

![Screenshot of version 0.0.9 run](assets/media/run-0.0.9.png)

### Organization level export

Since version 0.0.8 of this module, you can also export the
data at the organization level, looping through all projects
in the organization the PAT has access to.

```powershell
Export-AzDevOpsOrganizationRuleData `
    -Organization "MyOrg" `
    -PAT $MyPAT `
    -OutputPath "C:\Temp\MyOrg"
```

### Disable checks for Azure DevOps Features that require additional licenses

Since version 0.0.12 of this module, you can disable rules that
check for Azure DevOps features that require additional licenses.
This is done through applying the `Baseline.NoExtraLicense`
baseline to the `Assert-PSRule` command through the `-Baseline`
option.

```powershell
Assert-PSRule `
    -InputPath "C:\Temp\MyProject\" `
    -Module PSRule.Rules.AzureDevOps `
    -Baseline Baseline.NoExtraLicense
```

## Rules

Documentation for the implemented rules can be found in the
[en](src/PSRule.Rules.AzureDevOps/en/) folder in the module folder.

This [annotated version of the official security best practices](docs/security-best-practices.md)
provides a reference for how the rules in this module are related to the
best practices recommended by Microsoft. It is the main guiding document
in building the ruleset for this module.

- [Azure.DevOps.Pipelines.Core.UseYamlDefinition](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.UseYamlDefinition.md)
- [Azure.DevOps.Pipelines.Core.InheritedPermissions](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.InheritedPermissions.md)
- [Azure.DevOps.Pipelines.Core.NoPlainTextSecrets](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.NoPlainTextSecrets.md)
- [Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest.md)
- [Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName.md)
- [Azure.DevOps.Pipelines.Environments.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.Description.md)
- [Azure.DevOps.Pipelines.Environments.ProductionBranchLimit](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionBranchLimit.md)
- [Azure.DevOps.Pipelines.Environments.ProductionCheckProtection](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md)
- [Azure.DevOps.Pipelines.Environments.ProductionHumanApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md)
- [Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md)
- [Azure.DevOps.Pipelines.Releases.Definition.SelfApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.SelfApproval.md)
- [Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions.md)
- [Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets.md)
- [Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime.md)
- [Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope.md)
- [Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines.md)
- [Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines.md)
- [Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork.md)
- [Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork.md)
- [Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments.md)
- [Azure.DevOps.Repos.BranchPolicyAllowSelfApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyAllowSelfApproval.md)
- [Azure.DevOps.Repos.BranchPolicyCommentResolution](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyCommentResolution.md)
- [Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems.md)
- [Azure.DevOps.Repos.BranchPolicyIsEnabled](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyIsEnabled.md)
- [Azure.DevOps.Repos.BranchPolicyMergeStrategy](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMergeStrategy.md)
- [Azure.DevOps.Repos.BranchPolicyMinimumReviewers](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMinimumReviewers.md)
- [Azure.DevOps.Repos.BranchPolicyRequireBuild](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyRequireBuild.md)
- [Azure.DevOps.Repos.BranchPolicyResetVotes](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyResetVotes.md)
- [Azure.DevOps.Repos.HasBranchPolicy](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.HasBranchPolicy.md)
- [Azure.DevOps.Repos.License](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.License.md)
- [Azure.DevOps.Repos.Readme](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.Readme.md)
- [Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled.md)
- [Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes.md)
- [Azure.DevOps.Repos.InheritedPermissions](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.InheritedPermissions.md)
- [Azure.DevOps.ServiceConnections.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Description.md)
- [Azure.DevOps.ServiceConnections.ProductionBranchLimit](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md)
- [Azure.DevOps.ServiceConnections.ProductionCheckProtection](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionCheckProtection.md)
- [Azure.DevOps.ServiceConnections.ProductionHumanApproval](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionHumanApproval.md)
- [Azure.DevOps.ServiceConnections.Scope](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Scope.md)
- [Azure.DevOps.ServiceConnections.WorkloadIdentityFederation](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md)
- [Azure.DevOps.Tasks.VariableGroup.Description](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.Description.md)
- [Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md)
- [Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets](src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets.md)

## Contributing

This project welcomes contributions and suggestions. Please read
[CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute.

## License

This project is [licensed under the MIT License](LICENSE).

## Acknowledgements

- [Bernie White](https://github.com/BernieWhite) for creating
  [PSRule](https://microsoft.github.io/PSRule/V2).

## Maintainer

- [Roderick Bant](https://github.com/webtonize)

## References

- [PSRule](https://microsoft.github.io/PSRule/V2)
- [Auditing an Azure DevOps project configuration with PSRule](https://medium.com/@webtonize/auditing-an-azure-devops-project-configuration-with-psrule-73cf17753827)
- [Audit Azure DevOps configuration with Sarif scan reports from the pipeline](https://medium.com/@webtonize/audit-azure-devops-configuration-with-sarif-scan-reports-from-the-pipeline-4ced6fc47988)
- [Azure DevOps Security best practices](https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops)
