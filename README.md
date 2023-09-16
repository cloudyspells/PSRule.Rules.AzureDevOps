# PSRule.Rules.AzureDevOps

## Azure DevOps rules module for PSRule

This powershell module is built to be used with
[Bernie White's](https://github.com/BernieWhite) excellent
[PSRule]https://github.com/microsoft/PSRule) module to check
an Azure DevOps project against some best practices for a
secure development environment.

This module is very much in early stage of development and
should not be considered stable. Any input on the direction
of the module and included rules is very much appreciated.
Please consider opening an issue with your ideas.

## Usage

To use this module, you need to have [PSRule] installed.
You can install it from the PowerShell Gallery:

```powershell
Install-Module -Name PSRule -Scope CurrentUser
```

Once you have PSRule installed, you can install this module
from the PowerShell Gallery:

```powershell
Install-Module -Name PSRule.Rules.AzureDevOps -Scope CurrentUser
```

Once you have both modules installed, you can run an export of
your Azure DevOps project and run the rules against it. The `-PAT`
value needs to be an Azure DevOps Personal Access Token with
sufficient permissions to read the project data.

```powershell
$export = Export-AzDevOpsRuleData `
    -Organization "MyOrg" `
    -Project "MyProject" `
    -PAT $MyPAT `
    -OutputPath "C:\Temp\MyProject"
Assert-PSRule `
    -InputPath "C:\Temp\MyProject" `
    -Module PSRule.Rules.AzureDevOps
```
