# Function to create Azure DevOps Rest API header from PAT
# Usage: $header = Get-AzDevOpsHeader -PAT $PAT
# --------------------------------------------------

<#
    .SYNOPSIS
    Function to create Azure DevOps Rest API header from PAT

    .DESCRIPTION
    Function to create Azure DevOps Rest API header from PAT

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .EXAMPLE
    $header = Get-AzDevOpsHeader -PAT $PAT
#>
function Get-AzDevOpsHeader {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter()]
        [string]
        $PAT
    )
    $header = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    }
    return $header
}
Export-ModuleMember -Function Get-AzDevOpsHeader
# End of Function Get-AzDevOpsHeader

<#
    .SYNOPSIS
    Get all Azure DevOps projects for an organization

    .DESCRIPTION
    Get all Azure DevOps projects for an organization using Azure DevOps Rest API

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .EXAMPLE
    Get-AzDevOpsProjects -TokenType FullAccess
#>
function Get-AzDevOpsProjects {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter()]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess'
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    Write-Verbose "Getting projects for organization $Organization"
    $uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=6.0"
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or organization not found"
        }
    }
    catch {
        Write-Error "Failed to get projects from Azure DevOps"
        throw $_.Exception.Message
    }
    $projects = $response.value
    return @($projects)
}
Export-ModuleMember -Function Get-AzDevOpsProjects
# End of Function Get-AzDevOpsProjects

<#
    .SYNOPSIS
    Connect to Azure DevOps for a session using a Service Principal, Managed Identity or Personal Access Token (PAT)

    .DESCRIPTION
    Connect to Azure DevOps for a session using a Service Principal, Managed Identity or Personal Access Token (PAT)

    .PARAMETER Organization
    Organization name for Azure DevOps

    .PARAMETER PAT
    Personal Access Token (PAT) for Azure DevOps

    .PARAMETER ClientId
    Client ID for Service Principal

    .PARAMETER ClientSecret
    Client Secret for Service Principal

    .PARAMETER TenantId
    Tenant ID for Service Principal

    .PARAMETER AuthType
    Authentication type for Azure DevOps (PAT, ServicePrincipal, ManagedIdentity)

    .EXAMPLE
    $connection = Connect-AzDevOps -Organization $Organization -PAT $PAT

    .EXAMPLE
    $connection = Connect-AzDevOps -Organization $Organization -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId -AuthType ServicePrincipal

    .EXAMPLE
    $connection = Connect-AzDevOps -Organization $Organization -AuthType ManagedIdentity

    .EXAMPLE
    $connection = Connect-AzDevOps -Organization $Organization -PAT $PAT -AuthType PAT

#>
Function Connect-AzDevOps {
    [CmdletBinding()]
    [OutputType([AzureDevOpsConnection])]
    param (
        [Parameter(Mandatory)]
        [string]
        $Organization,
        [Parameter(ParameterSetName = 'PAT')]
        [string]
        $PAT,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory=$true)]
        [string]
        $ClientId,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory=$true)]
        [string]
        $ClientSecret,
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory=$true)]
        [string]
        $TenantId,
        [Parameter(ParameterSetName = 'ManagedIdentity')]
        [switch]
        $ManagedIdentity,
        [Parameter(ParameterSetName = 'PAT')]
        [Parameter(ParameterSetName = 'ServicePrincipal', Mandatory=$true)]
        [Parameter(ParameterSetName = 'ManagedIdentity', Mandatory=$true)]
        [ValidateSet('PAT', 'ServicePrincipal', 'ManagedIdentity')]
        [string]
        $AuthType = 'PAT'
    )
    switch ($AuthType) {
        'PAT' {
            $connection = [AzureDevOpsConnection]::new($Organization, $PAT)
        }
        'ServicePrincipal' {
            $connection = [AzureDevOpsConnection]::new($Organization, $ClientId, $ClientSecret, $TenantId)
        }
        'ManagedIdentity' {
            $connection = [AzureDevOpsConnection]::new($Organization)
        }
    }
    $script:connection = $connection
}
Export-ModuleMember -Function Connect-AzDevOps
# End of Function Connect-AzDevOps
