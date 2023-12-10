# PSRule.Rules.AzureDevOps.psm1
# PSRule module for Azure DevOps

# Azure DevOps Rest API connection object
$script:connection = $null

# Add all classes from src/Classes
Get-ChildItem -Path "$PSScriptRoot/Classes/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Dot source all function scripts from src/Functions
Get-ChildItem -Path "$PSScriptRoot/Functions/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Define the types to export with type accelerators.
$ExportableTypes =@(
    [AzureDevOpsConnection]
)
# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)
# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get
foreach ($Type in $ExportableTypes) {
    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        $Message = @(
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' - '

        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'TypeAcceleratorAlreadyExists',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )
    }
}
# Add type accelerators for every exportable type.
foreach ($Type in $ExportableTypes) {
    $TypeAcceleratorsClass::Add($Type.FullName, $Type) | Out-Null
}
# Remove type accelerators when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    foreach($Type in $ExportableTypes) {
        $TypeAcceleratorsClass::Remove($Type.FullName) | Out-Null
    }
}.GetNewClosure()



<#
    .SYNOPSIS
    Run all JSON export functions for Azure DevOps for analysis by PSRule

    .DESCRIPTION
    Run all JSON export functions for Azure DevOps using Azure DevOps Rest API and this modules functions for analysis by PSRule

    .PARAMETER Project
    Project name for Azure DevOps

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsRuleData -Project $Project -OutputPath $OutputPath
#>
Function Export-AzDevOpsRuleData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Project,
        [Parameter(Mandatory)]
        [string]
        $OutputPath
    )
    Export-AzDevOpsReposAndBranchPolicies -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsEnvironmentChecks -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsServiceConnections -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsPipelines -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsPipelinesSettings -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsVariableGroups -Project $Project -OutputPath $OutputPath
    Export-AzDevOpsReleaseDefinitions -Project $Project -OutputPath $OutputPath
}
Export-ModuleMember -Function Export-AzDevOpsRuleData -Alias Export-AzDevOpsProjectRuleData
# End of Function Export-AzDevOpsRuleData

<#
    .SYNOPSIS
    Export rule data for all projects in the DevOps organization

    .DESCRIPTION
    Export rule data for all projects in the DevOps organization using Azure DevOps Rest API and this modules functions for analysis by PSRule

    .PARAMETER OutputPath
    Output path for JSON files

    .EXAMPLE
    Export-AzDevOpsOrganizationRuleData -OutputPath $OutputPath
#>
Function Export-AzDevOpsOrganizationRuleData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $OutputPath
    )
    $projects = Get-AzDevOpsProjects
    $projects | ForEach-Object {
        $project = $_
        # Create a subfolder for each project
        $subPath = "$($OutputPath)\$($project.name)"
        if(!(Test-Path -Path $subPath)) {
            New-Item -Path $subPath -ItemType Directory
        }
        Export-AzDevOpsRuleData -Project $project.name -OutputPath $subPath
    }
}
Export-ModuleMember -Function Export-AzDevOpsOrganizationRuleData
# End of Function Export-AzDevOpsOrganizationRuleData

Export-ModuleMember -Function Get-AzDevOpsProjects
Export-ModuleMember -Function Connect-AzDevOps
Export-ModuleMember -Function Disconnect-AzDevOps