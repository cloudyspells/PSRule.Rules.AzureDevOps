# Connection class for Azure DevOps Rest API
#
# Path: src/PSRule.Rules.AzureDevOps/Functions/Connection.ps1
# This class contains methods to connect to Azure DevOps Rest API
# using a service principal, managed identity or personal access token (PAT).
# it provides an authentication header which is refreshed automatically when it expires.
# --------------------------------------------------
#

class AzureDevOpsConnection {
    [string]$Organization
    [string]$PAT
    [string]$ClientId
    [string]$ClientSecret
    [string]$TenantId
    [string]$TokenEndpoint
    [string]$Token
    [System.DateTime]$TokenExpires
    [string]$AuthType
    

    # Constructor for Service Principal
    AzureDevOpsConnection(
        [string]$Organization,
        [string]$ClientId,
        [string]$ClientSecret,
        [string]$TenantId
    )
    {
        $this.Organization = $Organization
        $this.ClientId = $ClientId
        $this.ClientSecret = $ClientSecret
        $this.TenantId = $TenantId
        $this.TokenEndpoint = "https://login.microsoftonline.com/$($this.TenantId)/oauth2/v2.0/token"
        $this.Token = $null
        $this.TokenExpires = [System.DateTime]::MinValue

        # Get a token for the Azure DevOps REST API
        $this.GetServicePrincipalToken()
    }

    # Constructor for Managed Identity
    AzureDevOpsConnection(
        [string]$Organization
    )
    {
        $this.Organization = $Organization
        # Get the Managed Identity token endpoint for the Azure DevOps REST API
        if(-not $env:IDENTITY_ENDPOINT) {
            $env:IDENTITY_ENDPOINT = "http://169.254.169.254/metadata/identity/oauth2/token"
        }
        if($env:ADO_MSI_CLIENT_ID) {
            $this.TokenEndpoint = "$($env:IDENTITY_ENDPOINT)?api-version=2019-08-01&resource=499b84ac-1321-427f-aa17-267ca6975798&client_id=$($env:ADO_MSI_CLIENT_ID)"
        } else {
            $this.TokenEndpoint = "$($env:IDENTITY_ENDPOINT)?api-version=2019-08-01&resource=499b84ac-1321-427f-aa17-267ca6975798"
        }
        $this.Token = $null
        $this.TokenExpires = [System.DateTime]::MinValue

        # Get a token for the Azure DevOps REST API
        $this.GetManagedIdentityToken()
    }

    # Constructor for Personal Access Token (PAT)
    AzureDevOpsConnection(
        [string]$Organization,
        [string]$PAT
    )
    {
        $this.Organization = $Organization
        $this.PAT = $PAT
        $this.Token = $null
        $this.TokenExpires = [System.DateTime]::MaxValue

        # Get a token for the Azure DevOps REST API
        $this.GetPATToken()
    }

    # Get a token for the Azure DevOps REST API using a service principal
    [void]GetServicePrincipalToken()
    {
        $body = @{
            grant_type    = "client_credentials"
            client_id     = $this.ClientId
            client_secret = $this.ClientSecret
            scope         = '499b84ac-1321-427f-aa17-267ca6975798/.default'
        }
        # URL encode the client secret and id
        $secret = [System.Web.HttpUtility]::UrlEncode($this.ClientSecret)
        $id = [System.Web.HttpUtility]::UrlEncode($this.ClientId)
        #$body = "client_id=$($id)&client_secret=$($secret)&scope=499b84ac-1321-427f-aa17-267ca6975798/.default&grant_type=client_credentials"
        $header = @{
            'Content-Type' = 'application/x-www-form-urlencoded'
        }
        # POST as form url encoded body using the token endpoint 
        $response = Invoke-RestMethod -Uri $this.TokenEndpoint -Method Post -Body $body -ContentType 'application/x-www-form-urlencoded' -Headers $header
        $this.Token = "Bearer $($response.access_token)"
        $this.TokenExpires = [System.DateTime]::Now.AddSeconds($response.expires_in)
        $this.AuthType = 'ServicePrincipal'
    }

    # Get a token for the Azure DevOps REST API using a managed identity
    [void]GetManagedIdentityToken()
    {
        $body = @{
            scope = '499b84ac-1321-427f-aa17-267ca6975798/.default'
        }
        $header = @{
            Metadata = 'true'
        }
        If($env:IDENTITY_HEADER) {
            $header.Add('X-IDENTITY-HEADER', $env:IDENTITY_HEADER)
        }
        $response = Invoke-RestMethod -Uri $this.TokenEndpoint -Method Get -Body $body -Headers $header
        $this.Token = "Bearer $($response.access_token)"
        $this.TokenExpires = [System.DateTime]::Now.AddSeconds($response.expires_in)
        $this.AuthType = 'ManagedIdentity'
    }

    # Get a token for the Azure DevOps REST API using a personal access token (PAT)
    [void]GetPATToken()
    {
        # base64 encode the PAT
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes((":$($this.PAT)")))
        $this.Token = 'Basic ' + $base64AuthInfo
        $this.AuthType = 'PAT'
    }

    # Get the the up to date authentication header for the Azure DevOps REST API
    [System.Collections.Hashtable]GetHeader()
    {
        # If the token is expired, get a new one
        if ($this.TokenExpires -lt [System.DateTime]::Now) {
            switch ($this.AuthType) {
                'ServicePrincipal' {
                    $this.GetServicePrincipalToken()
                }
                'ManagedIdentity' {
                    $this.GetManagedIdentityToken()
                }
                'PAT' {
                    # PAT tokens don't expire
                }
            }
        }
        $header = @{
            Authorization = $this.Token
        }
        return $header
    }
}
