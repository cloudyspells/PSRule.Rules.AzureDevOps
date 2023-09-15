# PSRule.Rules.AzureDevOps.psm1
# PSRule module for Azure DevOps

# Dot source all function scripts from src/Functions
Get-ChildItem -Path "$PSScriptRoot/Functions/*.ps1" | ForEach-Object {
    . $_.FullName
}
