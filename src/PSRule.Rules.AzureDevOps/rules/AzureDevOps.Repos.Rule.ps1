# PSRule rule definitions for Azure DevOps Repos

# Synopsis: The default branch should have a branch policy
Rule 'Azure.DevOps.Repos.HasBranchPolicy' `
    -Ref 'ADO-RP-001' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The default branch should have a branch policy
        Reason 'The default branch does not have a branch policy.'
        Recommend 'Protect your main branch with a branch policy.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-azure-repos
        $Assert.HasField($TargetObject, "MainBranchPolicy", $true)
        $Assert.NotNull($TargetObject, "MainBranchPolicy")
}

# Synopsis: The default branch should have its branch policy enabled
Rule 'Azure.DevOps.Repos.BranchPolicyIsEnabled' `
    -Ref 'ADO-RP-001a' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The default branch should have its branch policy enabled
        Reason 'The default branch does not have its branch policy enabled.'
        Recommend 'Protect your main branch with a branch policy.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#secure-azure-repos
        $Assert.HasField(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "isEnabled", $true)
        $Assert.HasFieldValue(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "isEnabled", $true)
}


# Synopsis: The branch policy should require a minimum number of reviewers
Rule 'Azure.DevOps.Repos.BranchPolicyMinimumReviewers' `
    -Ref 'ADO-RP-002' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should require a minimum number of reviewers
        Reason 'The branch policy does not require any reviewers.'
        Recommend 'Require a minimum number of reviewers to approve pull requests.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#repositories-and-branches
        $Assert.HasField(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.minimumApproverCount", $true)
        $Assert.GreaterOrEqual(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.minimumApproverCount", $Configuration.GetValueOrDefault('branchMinimumApproverCount', 1))
}

# Synopsis: The branch policy should not allow creators to approve their own changes
Rule 'Azure.DevOps.Repos.BranchPolicyAllowSelfApproval' `
    -Ref 'ADO-RP-003' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should not allow creators to approve their own changes
        Reason 'The branch policy allows creators to approve their own changes.'
        Recommend 'Require a minimum number of reviewers to approve pull requests.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.creatorVoteCounts", $true)
        $Assert.HasFieldValue(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.creatorVoteCounts", $false)
}

# Synopsis: The branch policy should reset code reviewer votes when new changes are pushed
Rule 'Azure.DevOps.Repos.BranchPolicyResetVotes' `
    -Ref 'ADO-RP-004' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The branch policy should reset code reviewer votes when new changes are pushed
        Reason 'The branch policy does not reset code reviewer votes when new changes are pushed.'
        Recommend 'Reset code reviewer votes when new changes are pushed.'
        # Links: https://learn.microsoft.com/en-us/azure/devops/organizations/security/security-best-practices?view=azure-devops#policies
        $Assert.HasField(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.resetOnSourcePush", $true)
        $Assert.HasFieldValue(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd'}), "settings.resetOnSourcePush", $true)
}

# Synopsis: The repository should contain a README file
Rule 'Azure.DevOps.Repos.Readme' `
    -Ref 'ADO-RP-005' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The repository should contain a README file
        Reason 'The repository does not contain a README or README.md file.'
        Recommend 'Add a README or README.md file to the repository to explain its purpose.'
        $Assert.HasField($TargetObject, "ReadmeExists", $true)
        $Assert.HasFieldValue($TargetObject, "ReadmeExists", $true)
}

# Synopsis: The repository should contain a LICENSE file
Rule 'Azure.DevOps.Repos.License' `
    -Ref 'ADO-RP-006' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description: The repository should contain a LICENSE file
        Reason 'The repository does not contain a LICENSE file.'
        Recommend 'Add a LICENSE file to the repository to explain its purpose.'
        $Assert.HasField($TargetObject, "LicenseExists", $true)
        $Assert.HasFieldValue($TargetObject, "LicenseExists", $true)
}

# Synopsis: The branch policy enforce linked work items
Rule 'Azure.DevOps.Repos.BranchPolicyEnforceLinkedWorkItems' `
    -Ref 'ADO-RP-007' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'The branch policy enforce linked work items.'
        Reason 'The branch policy does not enforce linked work items.'
        Recommend 'Enforce linked work items.'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#enforce-linked-work-items'
        $Assert.NotNull($TargetObject, "MainBranchPolicy")
        $Assert.HasField($TargetObject, "MainBranchPolicy[?@type.id == '40e92b44-2fe1-4dd6-b3d8-74a9c21d0c6e'].type", $true)
}

# Synopsis: The branch policy should enforce comment resolution
Rule 'Azure.DevOps.Repos.BranchPolicyCommentResolution' `
    -Ref 'ADO-RP-008' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'The branch policy should enforce comment resolution'
        Reason 'The branch policy does not enforce comment resolution'
        Recommend 'Enforce comment resolution'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#enforce-comment-resolution'
        $Assert.HasFieldValue(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'c6a1889d-b943-4856-b76f-9e46bb6b0df2'}), "type.displayName", "Comment requirements")
}

# Synopsis: The branch policy should require a merge strategy
Rule 'Azure.DevOps.Repos.BranchPolicyMergeStrategy' `
    -Ref 'ADO-RP-009' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'The branch policy should require a merge strategy'
        Reason 'The branch policy does not require a merge strategy'
        Recommend 'Consider requiring a merge strategy'
        # Links 'https://docs.microsoft.com/en-us/azure/devops/repos/git/branch-policies?view=azure-devops#require-a-merge-strategy'
        $Assert.HasFieldValue(($TargetObject.MainBranchPolicy | Where-Object { $_.type.id -eq 'fa4e907d-c16b-4a4c-9dfa-4916e5d171ab'}), "type.displayName", "Require a merge strategy")
}

# Synopsis: GitHub Advanced Security should be enabled
Rule 'Azure.DevOps.Repos.GitHubAdvancedSecurityEnabled' `
    -Ref 'ADO-RP-010' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'GitHub Advanced Security should be enabled'
        Reason 'GitHub Advanced Security is not enabled'
        Recommend 'Enable GitHub Advanced Security'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/repos/security/configure-github-advanced-security-features?'
        $Assert.HasField($TargetObject, "Ghas.advSecEnabled", $true)
        $Assert.HasFieldValue($TargetObject, "Ghas.advSecEnabled", $Configuration.GetBoolOrDefault('ghasEnabled', $True))
}

# Synopsis: GitHub Advanced Security should block pushes
Rule 'Azure.DevOps.Repos.GitHubAdvancedSecurityBlockPushes' `
    -Ref 'ADO-RP-011' `
    -Type 'Azure.DevOps.Repo' `
    -Tag @{ release = 'GA'} `
    -Level Warning {
        # Description 'GitHub Advanced Security should block pushes'
        Reason 'GitHub Advanced Security does not block pushes'
        Recommend 'Consider blocking pushes'
        # Links 'https://learn.microsoft.com/en-us/azure/devops/repos/security/configure-github-advanced-security-features?'
        $Assert.HasField($TargetObject, "Ghas.blockPushes", $true)
        $Assert.HasFieldValue($TargetObject, "Ghas.blockPushes", $Configuration.GetBoolOrDefault('ghasBlockPushesEnabled', $True))
}
