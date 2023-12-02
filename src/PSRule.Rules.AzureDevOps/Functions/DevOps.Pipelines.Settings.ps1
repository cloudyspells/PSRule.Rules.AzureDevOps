<#
    .SYNOPSIS
    Get the projects's pipelines settings from Azure DevOps

    .DESCRIPTION
    Get the projects's pipelines settings from Azure DevOps

    .PARAMETER TokenType
    Token Type for Azure DevOps, can be FullAccess, FineGrained or ReadOnly

    .PARAMETER ProjectId
    Project ID for Azure DevOps

    .EXAMPLE
    Get-AzDevOpsPipelinesSettings -ProjectId $ProjectId
#>
Function Get-AzDevOpsPipelinesSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory)]
        [string]
        $Project
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $Organization = $script:connection.Organization
    $header = $script:connection.GetHeader()
    $uri = "https://dev.azure.com/$Organization/$Project/_apis/build/generalsettings?api-version=7.1-preview.1"
    Write-Verbose "URI: $uri"
    try {
        $pipelinesSettings = Invoke-RestMethod -Uri $uri -Method Get -Headers $header -ContentType 'application/json'
        # if the response is not an object but a string, the authentication failed or the pipeline was not found
        if ($pipelinesSettings -is [string]) {
            throw "Authentication failed or pipeline not found"
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $pipelinesSettings
}
Export-ModuleMember -Function Get-AzDevOpsPipelinesSettings
# End of Function Get-AzDevOpsPipelinesSettings

<#
    .SYNOPSIS
    Export the projects's pipelines settings from Azure DevOps to a JSON file

    .DESCRIPTION
    Export the projects's pipelines settings from Azure DevOps to a JSON file with .ado.pls.json extension

    .PARAMETER TokenType
    Token Type for Azure DevOps, can be FullAccess, FineGrained or ReadOnly

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsPipelinesSettings -Project $Project -OutputPath $OutputPath
#>
function Export-AzDevOpsPipelinesSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess',
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $OutputPath
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    Write-Verbose "Getting pipelines settings from Azure DevOps"
    $pipelinesSettings = Get-AzDevOpsPipelinesSettings -Project $Project
    $pipelinesSettings | Add-Member -MemberType NoteProperty -Name ObjectType -Value 'Azure.DevOps.Pipelines.Settings'
    $pipelinesSettings | Add-Member -MemberType NoteProperty -Name Name -Value $Project
    $pipelinesSettings | ConvertTo-Json -Depth 10 | Out-File (Join-Path -Path $OutputPath -ChildPath "$Project.ado.pls.json")
}
Export-ModuleMember -Function Export-AzDevOpsPipelinesSettings
# End of Function Export-AzDevOpsPipelinesSettings
