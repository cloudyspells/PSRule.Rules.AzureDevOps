<#
    .SYNOPSIS
    Get all release definitions in the current project.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .EXAMPLE
    Get-AzDevOpsReleaseDefinitions -Organization 'contoso' -Project 'myproject' -PAT $MyPAT
#>
Function Get-AzDevOpsReleaseDefinitions {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT
    )
    $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions?api-version=7.2-preview.4"
    $header = Get-AzDevOpsHeader -PAT $PAT
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
    return @($response.value)
}
Export-ModuleMember -Function Get-AzDevOpsReleaseDefinitions
<#
    .SYNOPSIS
    Get all release definitions in the current project and export them to a JSON file per definition.

    .DESCRIPTION
    Get all release definitions in the current project using the Azure DevOps REST API and export them to a JSON file per definition.

    .PARAMETER Project
    The name of the Azure DevOps project.

    .PARAMETER Organization
    The name of the Azure DevOps organization.

    .PARAMETER PAT
    A personal access token (PAT) used to authenticate with Azure DevOps.

    .PARAMETER OutputPath
    The path to the directory where the JSON files will be exported.

    .EXAMPLE
    Export-AzDevOpsReleaseDefinitions -Organization 'contoso' -Project 'myproject' -PAT $MyPAT -OutputPath 'C:\temp'
#>
Function Export-AzDevOpsReleaseDefinitions {
    Param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Project,

        [Parameter(Mandatory = $true)]
        [string]$PAT,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )
    $definitions = Get-AzDevOpsReleaseDefinitions -Organization $Organization -Project $Project -PAT $PAT
    foreach ($definition in $definitions) {
        if ($null -ne $definition.id) {
            $definitionId = $definition.id
            $uri = "https://vsrm.dev.azure.com/$Organization/$Project/_apis/release/definitions/$($definitionId)?api-version=7.2-preview.4"
            $header = Get-AzDevOpsHeader -PAT $PAT
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
            $definitionName = $response.name
            $definitionPath = Join-Path -Path $OutputPath -ChildPath "$definitionName.ado.rd.json"
            # Add an ObjectType of Azure.DevOps.Pipelines.Releases.Definition to the response
            $response | Add-Member -MemberType NoteProperty -Name 'ObjectType' -Value 'Azure.DevOps.Pipelines.Releases.Definition'
            $response | ConvertTo-Json -Depth 100 | Out-File -FilePath $definitionPath
        }
    }
}
Export-ModuleMember -Function Export-AzDevOpsReleaseDefinitions