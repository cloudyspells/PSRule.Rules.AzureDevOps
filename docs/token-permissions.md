# PSRule.Rules.AzureDevOps Token Permissions

## Details on how to configure token permissions

PSRule.Rules.AzureDevOps requires a personal access token with the appropriate
permissions to export data from Azure DevOps. When running PSRule.Rules.AzureDevOps
you can choose 3 different token types:

- **FullAccess**: Allows for full access to Azure DevOps, use with caution
- **FineGrained**: Allows for fine-grained access to Azure DevOps, this is the recommended token type
- **ReadOnly**: Allows for read-only access to Azure DevOps

### FullAccess TokenType

The `FullAccess` token type is the most permissive and allows for maximum rule
coverage. This token type is recommended for use with PSRule.Rules.AzureDevOps
but should be used with caution. Check your organization's security policies
before using this token type.

The FullAccess token type can be created in Azure DevOps by following these
steps:

1. Navigate to your Azure DevOps organization
2. Select the **User Settings** option from the top right menu
3. Select the **Personal access tokens** option from the menu
4. Click the **New Token** button
5. Enter a name for the token
6. Select the **Full access** scope
7. Click the **Create** button
8. Copy the token value and store it in a secure location
9. Use the token value in your pipeline

### FineGrained TokenType

The `FineGrained` token type is the recommended token type for use with
PSRule.Rules.AzureDevOps. This token type allows for fine-grained access to
Azure DevOps and is the most secure token type that allows for near-maximum
rule coverage while still offering a detailed overview of the required permissions.

The FineGrained token type can be created in Azure DevOps by following these
steps:

1. Navigate to your Azure DevOps organization
2. Select the **User Settings** option from the top right menu
3. Select the **Personal access tokens** option from the menu
4. Click the **New Token** button
5. Enter a name for the token
6. Select the **Custom defined** scope
7. Select `Read` for all scopes that have a `Read` option
8. Select `Read & Manage` for all scopes that have a `Read & Manage` option
9. Do not select any other scopes
10. Click the **Create** button
11. Copy the token value and store it in a secure location
12. Use the token value in your pipeline

### ReadOnly TokenType

The `ReadOnly` token type is the most restrictive and allows for read-only access
to Azure DevOps. This token type is recommended for use with PSRule.Rules.AzureDevOps
when your security policies do not allow for the use of the `FullAccess` or `FineGrained`
token types.

The ReadOnly token type can be created in Azure DevOps by following these
steps:

1. Navigate to your Azure DevOps organization
2. Select the **User Settings** option from the top right menu
3. Select the **Personal access tokens** option from the menu
4. Click the **New Token** button
5. Enter a name for the token
6. Select the **Custom defined** scope
7. Select `Read` for all scopes that have a `Read` option
8. Do not select any other scopes
9. Click the **Create** button
10. Copy the token value and store it in a secure location
11. Use the token value in your pipeline

## Token Scopes for module functions

The following table lists the token scopes that are required for each command.

| Rule Function                             | API(s)                                   | Version       | Method | Scope(s)                | PAT Category        | PAT Name        |
|-------------------------------------------|------------------------------------------|---------------|--------|-------------------------|---------------------|-----------------|
| Get-AzDevOpsProject                      | projects                                 | 6.0           | GET    | vso.profile             | User Profile        | Read            |
|                                           |                                          |               |        | vso.project             | Project and Team    | Read            |
| Get-AzDevOpsPipelines                     | pipelines                                | 6.0-preview.1 | GET    | vso.build               | Build               | Read            |
|                                           | pipelines/{pipelineid}                   | 6.0-preview.1 | GET    | vso.build               | Build               | Read            |
| Get-AzDevOpsPipelineAcls                  | accesscontrollists/{securityid}          | 6.0           | GET    | vso.security_manage     | Security            | Manage          |
| Get-AzDevOpsPipelineYaml                  | pipelines/{pipelineid}/runs              | 5.1-preview   | POST   | vso.build               | Build               | Read            |
|                                           | pipelines/{pipelineid}                   | 7.1-preview.1 | GET    | vso.build               | Build               | Read            |
|                                           | git/repositories/{repositoryid}/items    | 6.0           | GET    | vso.code                | Code                | Read            |
| Get-AzDevOpsEnvironments                  | pipelines/environments                   | 6.0-preview.1 | GET    | vso.environment_manage  | Agent Pools         | Read and Manage |
|                                           |                                          |               |        | vso.build               | Build               | Read            |
|                                           | pipelines/checks/configurations          | 7.2-preview.1 | GET    | vso.build               | Build               | Read            |
| Get-AzDevOpsReleaseDefinitions            | release/definitions                      | 7.2-preview.4 | GET    | vso.release             | Release             | Read            |
| Get-AzDevOpsReleaseDefinitionAcls         | accesscontrollists/{securityid}          | 6.0           | GET    | vso.security_manage     | Security            | Manage          |
| Get-AzDevOpsPipelinesSettings             | build/generalsettings                   | 7.1-preview.1 | GET    | vso.project          | Build                  | Read            |
| Get-AzDevOpsRepos                         | git/repositories                         | 6.0           | GET    | vso.code                | Code                | Read            |
| Get-AzDevOpsBranchPolicy                  | policy/configurations                    | 6.0           | GET    | vso.code                | Code                | Read            |
| Get-AzDevOpsRepositoryPipelinePermissions | pipelines/pipelinePermissions/repository |               | GET    | vso.build               | Build               | Read            |
| Get-AzDevOpsRepositoryAcls                | accesscontrollists/{securityid}          | 6.0           | GET    | vso.security_manage     | Security            | Manage          |
| Test-AzDevOpsFileExists                   | git/repositories/{repositoryid}/items    | 6.0           | GET    | vso.code                | Code                | Read            |
| Get-AzDevOpsRepositoryGhas                | Contribution/HierarchyQuery              | 5.0-preview.1 | POST   | tbc                     | tbc                 | FullACcess           |
| Get-AzDevOpsArmServiceConnections         | serviceendpoint/endpoints                | 6.0-preview.4 | GET    | vso.serviceendpoint     | Service Connections | Read            |
| Get-AzDevOpsArmServiceConnectionChecks    | bipelines/checks/configurations          | 7.2-preview.1 | GET    | vso.build               | Build               | Read            |
| Get-AzDevOpsVariableGroups                | distributed task/variablegroups          | 7.2-preview.2 | GET    | vso.variablegroups_read | Variable Groups     | Read            |

## Token Scopes for rules

The following table lists the token scopes that are required for each rule.

| Rule | Minimum TokenType |
|------|-------------------|
|[Azure.DevOps.Pipelines.Core.UseYamlDefinition](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.UseYamlDefinition.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Core.InheritedPermissions](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.InheritedPermissions.md)|FineGrained|
|[Azure.DevOps.Pipelines.Core.NoPlainTextSecrets](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Core.NoPlainTextSecrets.md)|ReadOnly|
|[Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.AgentPoolVersionNotLatest.md)|ReadOnly|
|[Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.PipelineYaml.StepDisplayName.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Environments.Description](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.Description.md)|FineGrained|
|[Azure.DevOps.Pipelines.Environments.ProductionBranchLimit](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionBranchLimit.md)|FineGrained|
|[Azure.DevOps.Pipelines.Environments.ProductionCheckProtection](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionCheckProtection.md)|FineGrained|
|[Azure.DevOps.Pipelines.Environments.ProductionHumanApproval](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Environments.ProductionHumanApproval.md)|FineGrained|
|[Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Releases.Definition.SelfApproval](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.SelfApproval.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.InheritedPermissions.md)|FineGrained|
|[Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Releases.Definition.NoPlainTextSecrets.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork.md)|ReadOnly|
|[Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyAllowSelfApproval](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyAllowSelfApproval.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyCommentResolution](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyCommentResolution.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyIsEnabled](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyIsEnabled.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyMergeStrategy](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMergeStrategy.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyMinimumReviewers](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyMinimumReviewers.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyRequireBuild](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyRequireBuild.md)|ReadOnly|
|[Azure.DevOps.Repos.BranchPolicyResetVotes](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.BranchPolicyResetVotes.md)|ReadOnly|
|[Azure.DevOps.Repos.HasBranchPolicy](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.HasBranchPolicy.md)|ReadOnly|
|[Azure.DevOps.Repos.License](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.License.md)|ReadOnly|
|[Azure.DevOps.Repos.Readme](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.Readme.md)|ReadOnly|
|[Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled.md)|FullAccess|
|[Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes.md)|FullAccess|
|[Azure.DevOps.Repos.InheritedPermissions](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Repos.InheritedPermissions.md)|FineGrained|
|[Azure.DevOps.ServiceConnections.ClassicAzure](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ClassicAzure.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.Description](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Description.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.GitHubPAT](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.GitHubPAT.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.ProductionBranchLimit](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionBranchLimit.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.ProductionCheckProtection](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionCheckProtection.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.ProductionHumanApproval](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.ProductionHumanApproval.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.Scope](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.Scope.md)|ReadOnly|
|[Azure.DevOps.ServiceConnections.WorkloadIdentityFederation](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.ServiceConnections.WorkloadIdentityFederation.md)|ReadOnly|
|[Azure.DevOps.Tasks.VariableGroup.Description](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.Description.md)|ReadOnly|
|[Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoKeyVaultNoSecrets.md)|ReadOnly|
|[Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets](../src/PSRule.Rules.AzureDevOps/en/Azure.DevOps.Tasks.VariableGroup.NoPlainTextSecrets.md)|ReadOnly|
