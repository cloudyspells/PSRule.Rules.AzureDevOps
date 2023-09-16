# PSRule rule definitions for Azure DevOps Repos

# Synopsis: The default branch should have a branch policy
Rule 'Azure.DevOps.Repos.HasBranchPolicy' `
    -Ref 'ADO-RP-001' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The default branch should have a branch policy
        # Reason: The default branch does not have a branch policy
        # Recommendation: Protect your main branch with a branch policy
        $Assert.HasField($TargetObject, "MainBranchPolicy", $true)
        $Assert.NotNull($TargetObject, "MainBranchPolicy")
}

# Synopsis: The branch policy should require a minimum number of reviewers
Rule 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' `
    -Ref 'ADO-RP-002' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should require a minimum number of reviewers
        # Reason: The branch policy does not require any reviewers
        # Recommendation: Require a minimum number of reviewers to approve pull requests
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "MainBranchPolicy.settings.minimumApproverCount", $true)
        $Assert.Greater($TargetObject, "MainBranchPolicy.settings.minimumApproverCount", 0)
}

# Synopsis: The branch policy should not allow creators to approve their own changes
Rule 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' `
    -Ref 'ADO-RP-003' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should not allow creators to approve their own changes
        # Reason: The branch policy allows creators to approve their own changes
        # Recommendation: Require a minimum number of reviewers to approve pull requests
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "MainBranchPolicy.settings.creatorVoteCounts", $true)
        $Assert.HasDefaultValue($TargetObject, "MainBranchPolicy.settings.creatorVoteCounts", $false)
}

# Synopsis: The branch policy should reset code reviewer votes when new changes are pushed
Rule 'Azure.DevOps.Repos.BranchPolicyResetVotes' `
    -Ref 'ADO-RP-004' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should reset code reviewer votes when new changes are pushed
        # Reason: The branch policy does not reset code reviewer votes when new changes are pushed
        # Recommendation: Reset code reviewer votes when new changes are pushed
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField($TargetObject, "MainBranchPolicy.settings.resetOnSourcePush", $true)
        $Assert.HasDefaultValue($TargetObject, "MainBranchPolicy.settings.resetOnSourcePush", $true)
}
