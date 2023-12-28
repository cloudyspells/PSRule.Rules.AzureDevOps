<#
    .SYNOPSIS
    Get retention settings for a project.

    .DESCRIPTION
    Get retention settings for a project from Azure DevOps REST API.

    .PARAMETER Project
    The project to get retention settings for.

    .EXAMPLE
    Get-AzDevOpsRetentionSettings -Project 'MyProject'

    .NOTES
    This function requires a connection to Azure DevOps. See Connect-AzDevOps for more information.
#>
Function Get-AzDevOpsRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project
    )
    if($null -eq $script:connection) {
        throw 'Not connected to Azure DevOps. Run Connect-AzDevOps first.'
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()

    # Azure DevOps REST API endpoint for project retention settings
    $settingsUri = "https://dev.azure.com/$($Organization)/$($Project)/_apis/build/retention?api-version=7.1-preview.1"
    $policyUri = "https://dev.azure.com/$($Organization)/$($Project)/_apis/build/settings?api-version=7.1-preview.1"
    try {
        $settingsResponse = Invoke-RestMethod -Uri $settingsUri -Method Get -Headers $header
        $policyResponse = Invoke-RestMethod -Uri $policyUri -Method Get -Headers $header
        If($settingsResponse -is [string] -or $policyResponse -is [string]) {
            throw "Failed to get retention settings for project '$($Project)' from Azure DevOps"
        }
    }
    catch {
        throw "Failed to get retention settings for project '$($Project)' from Azure DevOps"
    }
    return @{
        RetentionSettings = $settingsResponse
        RetentionPolicy = $policyResponse
        ObjectType = 'Azure.DevOps.RetentionSettings'
        ObjectName = "$Organization.$Project.RetentionSettings"
    }
}
Export-ModuleMember -Function Get-AzDevOpsRetentionSettings

<#
    .SYNOPSIS
    Export retention settings for a project to a JSON file.

    .DESCRIPTION
    Export retention settings for a project to a JSON file from Azure DevOps REST API.

    .PARAMETER Project
    The project to get retention settings for.

    .PARAMETER OutputPath
    The path to export the retention settings to.

    .PARAMETER PassThru
    If set, the function will return the retention settings as objects instead of writing them to a file.

    .EXAMPLE
    Get-AzDevOpsRetentionSettings -Project 'MyProject' -OutputPath 'C:\Temp\'

    .NOTES
    This function requires a connection to Azure DevOps. See Connect-AzDevOps for more information.
#>
Function Export-AzDevOpsRetentionSettings {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Project,

        [Parameter(ParameterSetName = 'JsonFile')]
        [string]
        $OutputPath,

        [Parameter(ParameterSetName = 'PassThru')]
        [switch]
        $PassThru
    )
    $settings = Get-AzDevOpsRetentionSettings -Project $Project
    if($PassThru) {
        Write-Output $settings
    } else {
        $settings | ConvertTo-Json -Depth 100 | Out-File -FilePath "$OutputPath\$($Project).ret.ado.json"
    }
}
Export-ModuleMember -Function Export-AzDevOpsRetentionSettings
