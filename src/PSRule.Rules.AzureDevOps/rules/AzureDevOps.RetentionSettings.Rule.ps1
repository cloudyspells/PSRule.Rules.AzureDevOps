# PSRule rule definitions for Azure DevOps Retention Settings

# Synopsis: Retention settings should allow for artifacts to be retained for a minimum of 7 days
Rule 'Azure.DevOps.RetentionSettings.ArtifactMinimumRetentionDays' `
    -Ref 'ADO-RET-001' `
    -Type 'Azure.DevOps.RetentionSettings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "Retention settings allow for artifacts to be retained for a minimum of 7 days"
        Reason "Retention settings allow for artifacts to be retained for at least 7 days"
        Recommend "Consider increasing the minimum retention days to 7 days"
        # Links "https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/retention?view=azure-devops#minimum-retention-days"
        AllOf {
            $Assert.HasField($TargetObject, "RetentionSettings.purgeArtifacts.value", $true)
            $Assert.GreaterOrEqual($TargetObject, "RetentionSettings.purgeArtifacts.value", $Configuration.GetValueOrDefault('ArtifactMinimumRetentionDays', 7))
        }
}

# Synopsis: Retention settings should allow pull request runs to be retained at least 7 days
Rule 'Azure.DevOps.RetentionSettings.PullRequestRunsMinimumRetentionDays' `
    -Ref 'ADO-RET-002' `
    -Type 'Azure.DevOps.RetentionSettings' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description "Retention settings should allow pull request runs to be retained at least 7 days"
        Reason "Retention settings should allow pull request runs to be retained at least 7 days"
        Recommend "Consider increasing the minimum retention days to 7 days"
        # Links "https://docs.microsoft.com/en-us/azure/devops/pipelines/policies/retention?view=azure-devops#minimum-retention-days"
        AllOf {
            $Assert.HasField($TargetObject, "RetentionSettings.purgePullRequestRuns.value", $true)
            $Assert.GreaterOrEqual($TargetObject, "RetentionSettings.purgePullRequestRuns.value", $Configuration.GetValueOrDefault('PullRequestRunsMinimumRetentionDays', 7))
        }
}