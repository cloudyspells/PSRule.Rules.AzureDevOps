<#  .SYNOPSIS
    Processes a directory of files and populates a given folder with markdown files
    documenting each cmdlet in the module.

    .DESCRIPTION
    Processes a directory of files and populates a given folder with markdown files
    documenting each cmdlet in the module.

    .PARAMETER InputPath
    Path from which to import the module

    .PARAMETER OutputPath
    Output path for markdown files

    .EXAMPLE
    ./build/wiki/Export-CmdletDocs.ps1 `
        -InputPath ./src/PSRule.Rules.AzureDevOps/en `
        -OutputPath ./Rules.md `
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $InputPath,

    [Parameter(Mandatory = $true)]
    [string]
    $OutputPath
)

# Import the module as it lives within the repository
Import-Module $InputPath -Force

# Export markdown helpers for each function
New-MarkdownHelp `
    -Module PSRule.Rules.AzureDevOps `
    -Verbose `
    -Force `
    -NoMetadata `
    -OutputFolder $OutputPath