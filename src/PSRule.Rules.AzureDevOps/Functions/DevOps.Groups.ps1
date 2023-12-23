<#
    .SYNOPSIS
    Get a list of groups from Azure DevOps

    .DESCRIPTION
    Get a list of groups from Azure DevOps for the specified organization and project using the Azure DevOps Rest API

    .PARAMETER Project
    The name of the project to get groups for

    .EXAMPLE
    Get-AzDevOpsGroups -Project 'MyProject'

    .NOTES
    This function requires a connection to Azure DevOps. See Connect-AzDevOps for more information.
#>
Function Get-AzDevOpsGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project
    )
    if(!$script:connection) {
        throw [System.ArgumentException]::new('Not connected to Azure DevOps. Run Connect-AzDevOps first.')
    }
    # Get project id
    try {
        $projectResult = Get-AzDevOpsProject -Project $Project
    }
    catch {
        throw "Failed to get project details from Azure DevOps"
    }
    if(!$projectResult) {
        throw [System.ArgumentException]::new("Project '$Project' not found.")
    }
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    # Set the scope descriptor REST API endpoint
    $uri = "https://vssps.dev.azure.com/$($Organization)/_apis/graph/descriptors/$($projectResult.id)?api-version=7.2-preview.1"
    $scopeDescriptor = (Invoke-RestMethod -Uri $uri -Method Get -Headers $header).value
    $uri = "https://vssps.dev.azure.com/$($Organization)/_apis/graph/groups?scopeDescriptor=$scopeDescriptor&api-version=7.2-preview.1"
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    return $response.value
}
Export-ModuleMember -Function Get-AzDevOpsGroups
# End of Function Get-AzDevOpsGroups

<#
    .SYNOPSIS
    Get details for a group from Azure DevOps

    .DESCRIPTION
    Get details for a group from Azure DevOps for the specified group object using the Azure DevOps Rest API

    .PARAMETER Group
    The group object to get details for

    .EXAMPLE
    $group = (Get-AzDevOpsGroups -Project 'MyProject')[0]
    Get-AzDevOpsGroupDetails -Group $group

    .NOTES
    This function requires a connection to Azure DevOps. See Connect-AzDevOps for more information.
#>
Function Get-AzDevOpsGroupDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [object]
        $Group
    )
    if(!$script:connection) {
        throw [System.ArgumentException]::new('Not connected to Azure DevOps. Run Connect-AzDevOps first.')
    }
    $header = $script:connection.GetHeader()
    $result = $Group

    # Get detail for which group this group is a member of
    $memberShipUri = $Group._links.memberships.href
    try {
        $membershipResult = (Invoke-RestMethod -Uri $memberShipUri -Method Get -Headers $header).value
    }
    catch {
        throw "Failed to get group memberOf details from Azure DevOps"
    }
    # Get the self information for each membership
    $memberships = @()
    foreach($item in $membershipResult) {
        $itemUri = $item._links.container.href
        $itemResult = (Invoke-RestMethod -Uri $itemUri -Method Get -Headers $header)
        $memberships += $itemResult
    }
    $result | Add-Member -MemberType NoteProperty -Name MemberOf -Value $memberships -Force

    # Get all members of this group
    $memberUri = "$($Group._links.memberships.href)?direction=down&api-version=7.2-preview.1"
    try {
        $memberResult = (Invoke-RestMethod -Uri $memberUri -Method Get -Headers $header).value
    }
    catch {
        throw "Failed to get group members details from Azure DevOps"
    }
    # Get the self information for each member
    $members = @()
    foreach($item in $memberResult) {
        $itemUri = $item._links.member.href
        $itemResult = (Invoke-RestMethod -Uri $itemUri -Method Get -Headers $header)
        $members += $itemResult
    }
    $result | Add-Member -MemberType NoteProperty -Name Members -Value $members -Force
    return $result
}
Export-ModuleMember -Function Get-AzDevOpsGroupDetails

<#
    .SYNOPSIS
    Export all groups from Azure DevOps for a project to a JSON file

    .DESCRIPTION
    Export all groups from Azure DevOps for a project to a JSON file

    .PARAMETER Project
    The name of the project to get groups for

    .PARAMETER OutputPath
    The folder path to the JSON file to export to

    .EXAMPLE
    Export-AzDevOpsGroups -Project 'MyProject' -OutputPath 'C:\Temp\'

    .NOTES
    This function requires a connection to Azure DevOps. See Connect-AzDevOps for more information.
#>
Function Export-AzDevOpsGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project,
        [Parameter(Mandatory=$true)]
        [string]
        $OutputPath
    )
    if(!$script:connection) {
        throw [System.ArgumentException]::new('Not connected to Azure DevOps. Run Connect-AzDevOps first.')
    }
    try {
        $groups = Get-AzDevOpsGroups -Project $Project
    }
    catch {
        Write-Error "Failed to get groups from Azure DevOps"
    }
    $groupDetails = @()
    foreach($group in $groups) {
        $thisGroup = Get-AzDevOpsGroupDetails -Group $group
        # Add an ObjectType property to the group object
        $thisGroup | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.Group' -Force
        # Add the group name to the group object as an ObjectName property with a convention of Organization.Project.GroupName
        $thisGroup | Add-Member -MemberType NoteProperty -Name ObjectName -Value "$($script:connection.Organization).$($Project).$($group.displayName)" -Force

        $groupDetails += $thisGroup
    }
    $groupDetails | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\groups.ado.json"
}
Export-ModuleMember -Function Export-AzDevOpsGroups
# End of Function Export-AzDevOpsGroups
