<#  .SYNOPSIS
    Process a directory of files and generate an index page for our wiki

    .DESCRIPTION
    Processes a given directory of files according to a given regex and
    generates an index page for our wiki in markdown format

    .PARAMETER InputPath
    Input path for files to process

    .PARAMETER OutputPath
    Output path for markdown file

    .PARAMETER FilterRegex
    Regex to filter files to process

    .PARAMETER Header
    Header for the index page

    .PARAMETER IntroductoryText
    Introductory text for the index page

    .EXAMPLE
    ./tools/New-IndexPage.ps1 `
        -InputPath ./src/PSRule.Rules.AzureDevOps/en `
        -OutputPath ./Rules.md `
        -FilterRegex ".*\.md" `
        -Header "Rules" `
        -IntroductoryText "This page contains a list of all rules in the PSRule.Rules.AzureDevOps module."
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $InputPath,

    [Parameter(Mandatory = $true)]
    [string]
    $OutputPath,

    [Parameter(Mandatory = $true)]
    [string]
    $FilterRegex,

    [Parameter(Mandatory = $true)]
    [string]
    $Header,

    [Parameter(Mandatory = $true)]
    [string]
    $IntroductoryText
)

# Generate wiki entry
$WikiEntry = @()
$WikiEntry += "# $($Header)"
$WikiEntry += ""
$WikiEntry += "$($IntroductoryText)"
$WikiEntry += ""
(Get-ChildItem -Path $InputPath -Filter $FilterRegex).name | ForEach-Object {
    $WikiEntry += "- [$($_.TrimEnd(".md"))](./src/PSRule.Rules.AzureDevOps/en/$($_))"
}

# Write wiki entry to file
$WikiEntry | Out-File -FilePath $OutputPath -Encoding UTF8 -Force