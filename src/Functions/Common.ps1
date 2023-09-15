# Function to create Azure DevOps Rest API header from PAT
# Usage: $header = Get-AzDevOpsHeader -PAT $PAT
# --------------------------------------------------
function Get-AzDevOpsHeader {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $PAT
    )
    header = @{
        Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    }
    return $header
}
Export-ModuleMember -Function Get-AzDevOpsHeader
# End of Function Get-AzDevOpsHeader

