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

    .PARAMETER TokenType
    Token type for Azure DevOps (FullAccess, FineGrained, ReadOnly)

    .EXAMPLE
    Connect-AzDevOps -Organization $Organization -PAT $PAT

    .EXAMPLE
    Connect-AzDevOps -Organization $Organization -ClientId $ClientId -ClientSecret $ClientSecret -TenantId $TenantId -AuthType ServicePrincipal

    .EXAMPLE
    Connect-AzDevOps -Organization $Organization -AuthType ManagedIdentity

    .EXAMPLE
    Connect-AzDevOps -Organization $Organization -PAT $PAT -AuthType PAT

#>
Function Connect-AzDevOps {
    [CmdletBinding()]
    [OutputType([AzureDevOpsConnection])]
    param (
        [Parameter(Mandatory=$true)]
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
        [ValidateSet('PAT', 'ServicePrincipal', 'ManagedIdentity')]
        [string]
        $AuthType = 'PAT',
        [Parameter()]
        [ValidateSet('FullAccess', 'FineGrained', 'ReadOnly')]
        [string]
        $TokenType = 'FullAccess'
    )
    switch ($AuthType) {
        'PAT' {
            $connection = [AzureDevOpsConnection]::new($Organization, $PAT, $TokenType)
        }
        'ServicePrincipal' {
            $connection = [AzureDevOpsConnection]::new($Organization, $ClientId, $ClientSecret, $TenantId, $TokenType)
        }
        'ManagedIdentity' {
            $connection = [AzureDevOpsConnection]::new($Organization, $TokenType)
        }
    }
    $script:connection = $connection
}

# End of Function Connect-AzDevOps

<#
    .SYNOPSIS
    Disconnect from Azure DevOps

    .DESCRIPTION
    Disconnect from Azure DevOps and remove the connection object

    .EXAMPLE
    Disconnect-AzDevOps
#>
Function Disconnect-AzDevOps {
    [CmdletBinding()]
    param ()
    Clear-Variable connection -Scope Script -ErrorAction SilentlyContinue
    $script:connection = ""
    $script:connection = $null
}
# End of Function Disconnect-AzDevOps

<#
    .SYNOPSIS
    Get all Azure DevOps projects for an organization

    .DESCRIPTION
    Get all Azure DevOps projects for an organization using Azure DevOps Rest API

    .EXAMPLE
    Get-AzDevOpsProject
#>
function Get-AzDevOpsProject {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Project = ""
    )
    if ($null -eq $script:connection) {
        throw "Not connected to Azure DevOps. Run Connect-AzDevOps first"
    }
    $header = $script:connection.GetHeader()
    $Organization = $script:connection.Organization
    Write-Verbose "Getting projects for organization $Organization"
    if([string]::IsNullOrEmpty($Project) -eq $false) {
        $uri = "https://dev.azure.com/$Organization/_apis/projects/$($Project)?api-version=7.2-preview.4"
    } else {
        $uri = "https://dev.azure.com/$Organization/_apis/projects?api-version=7.2-preview.4"
    }
    Write-Verbose "URI: $uri"
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $header
        # If the response is not an object but a string, the authentication failed
        if ($response -is [string]) {
            throw "Authentication failed or organization not found"
        }
    }
    catch {
        throw "Failed to get projects from Azure DevOps"
    }
    if($response.value) {
        return $response.value
    } else {
        return $response
    }
}
# End of Function Get-AzDevOpsProject
