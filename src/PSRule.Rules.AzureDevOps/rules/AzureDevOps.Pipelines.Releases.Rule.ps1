# Synopsis: Release pipeline production environments should be protected by approval.
Rule 'Azure.DevOps.Pipelines.Releases.Definition.ProductionApproval' `
    -Ref 'ADO-RD-001' `
    -Type 'Azure.DevOps.Pipelines.Releases.Definition' `
    -If { $null -ne ($TargetObject.environments | ?{ $_.name -imatch "prd|prod|live|master|main"}) } `
    -Tag @{ release = 'GA'} `
    -Level Error {
        # Description: Release pipeline production environments should be protected by approval.
        # Reason: The release pipeline contains a production environment that is not protected by approval.
        # Recommendation: Consider adding approval to the production environment.
        # Links: https://docs.microsoft.com/en-us/azure/devops/pipelines/release/approvals/?view=azure-devops
        $prodEnvironments = $TargetObject.environments | ?{ $_.name -imatch "prd|prod|live|master|main"}
        $prodEnvironments | ForEach-Object {
            $Assert.HasField($_, "preDeployApprovals", $true)
            $Assert.HasField($_.preDeployApprovals, "approvals", $true)
            $Assert.Greater($_.preDeployApprovals, "approvals.length", 0, $true)
        }
}