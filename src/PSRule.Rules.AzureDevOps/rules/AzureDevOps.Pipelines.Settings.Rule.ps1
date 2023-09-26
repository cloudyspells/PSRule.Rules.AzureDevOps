# Azure DevOps Project Pipelines settings rules

# Synopsis: Setting variables at queue time should be limited
Rule 'Azure.DevOps.Pipelines.Settings.LimitSetVariablesAtQueueTime' `
    -Ref 'ADO-PLS-001' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should limit setting variables at queue time.
        Reason 'The projects settings do not limit setting variables at queue time.'
        Recommend 'Enable `Limit variables that can be set at queue time` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "enforceSettableVar.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enforceSettableVar.enabled", $true)
}

# Synopsis: Job authorization scope should be limited to current project for non-release pipelines
Rule 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScope' `
    -Ref 'ADO-PLS-002' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should limit job authorization scope to current project for non-release pipelines.
        Reason 'The projects settings do not limit job authorization scope to current project for non-release pipelines.'
        Recommend 'Enable `Limit job authorization scope to current project for non-release pipelines` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks
        $Assert.HasField($TargetObject, "enforceJobAuthScope.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enforceJobAuthScope.enabled", $true)
}

# Synopsis: Limit job authorization scope to current project for release pipelines
Rule 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForReleasePipelines' `
    -Ref 'ADO-PLS-003' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should limit job authorization scope to current project for release pipelines.
        Reason 'The projects settings do not limit job authorization scope to current project for release pipelines.'
        Recommend 'Enable `Limit job authorization scope to current project for release pipelines` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks
        $Assert.HasField($TargetObject, "enforceJobAuthScopeForReleases.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enforceJobAuthScopeForReleases.enabled", $true)
}

# Synopsis: Limit job authorization scope to defined repositories in YAML pipelines
Rule 'Azure.DevOps.Pipelines.Settings.LimitJobAuthorizationScopeForYamlPipelines' `
    -Ref 'ADO-PLS-004' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should limit job authorization scope to defined repositories in YAML pipelines.
        Reason 'The projects settings do not limit job authorization scope to defined repositories in YAML pipelines.'
        Recommend 'Enable `Limit job authorization scope to defined repositories in YAML pipelines` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks
        $Assert.HasField($TargetObject, "enforceReferencedRepoScopedToken.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enforceReferencedRepoScopedToken.enabled", $true)
}

# Synopsis: A comment should be required before building a pull request from a fork
Rule 'Azure.DevOps.Pipelines.Settings.RequireCommentForPullRequestFromFork' `
    -Ref 'ADO-PLS-005' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should require a comment before building a pull request from a fork.
        Reason 'The projects settings do not require a comment before building a pull request from a fork.'
        Recommend 'Enable `Require a comment before building a pull request from a fork` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "isCommentRequiredForPullRequest.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "isCommentRequiredForPullRequest.enabled", $true)
}

# Synopsis: Forks should not have access to secrets
Rule 'Azure.DevOps.Pipelines.Settings.RestrictSecretsForPullRequestFromFork' `
    -Ref 'ADO-PLS-006' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should restrict secrets for pull requests from forks.
        Reason 'The projects settings do not restrict secrets for pull requests from forks.'
        Recommend 'Enable `Restrict secrets for pull requests from forks` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "enforceNoAccessToSecretsFromForks.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enforceNoAccessToSecretsFromForks.enabled", $true)
}

# Synopsis: Shell tasks arguments should be sanitized
Rule 'Azure.DevOps.Pipelines.Settings.SanitizeShellTaskArguments' `
    -Ref 'ADO-PLS-007' `
    -Type 'Azure.DevOps.Pipelines.Settings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The projects settings should sanitize shell task arguments.
        Reason 'The projects settings do not sanitize shell task arguments.'
        Recommend 'Enable `Sanitize shell task arguments` in Project settings.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#tasks
        $Assert.HasField($TargetObject, "enableShellTasksArgsSanitizing.enabled", $true)
        $Assert.HasFieldValue($TargetObject, "enableShellTasksArgsSanitizing.enabled", $true)
}
