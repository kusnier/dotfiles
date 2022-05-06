#!/usr/bin/pwsh

$script_path = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$common = $(Join-Path $script_path "common.ps1")
. $common

$version = Get-MavenVersion

$selection = $version | Select-String -Pattern '([^-]+)(-[^-]+)-.*' 

if ($selection.Matches.Groups) {
    $issueSuffix = $selection.Matches.Groups[2].Value
    $newVersion = $version -replace $issueSuffix

    Write-Host "Setting version to $newVersion"
    fish -c "m-set-version $newVersion"

    find . -name 'pom.xml' | xargs git add
    git commit -m 'Remove issue suffix from version'
} else {
    Write-Warning "No issue number in version found!"
}