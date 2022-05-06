#!/usr/bin/pwsh

$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common

$issueNumber = (Get-IssueNumberFromBranch) -replace '-'

if ($issueNumber) {
    $version = Get-MavenVersion
    $splittedVersion = $version.Split('-')
    $newVersion = "{0}-{1}-{2}" -f $splittedVersion[0], $issueNumber, $splittedVersion[1]

    Write-Host "Setting version to $newVersion"
    fish -c "m-set-version $newVersion"

    git add **/pom.xml pom.xml
    git commit -m 'Add issue suffix to version'

} else {
    Write-Warning "No issue number found!"
}