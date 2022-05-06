function Get-GitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

function Get-IssueNumberFromBranch {

    #"feature/ROS-278-use-the-service-user-for-the-setting-up-the-ros-installation"
    $selection = Get-GitBranchName | Select-String -Pattern '.*\/(\w+-\d+)' 
    return $selection.Matches.Groups[1].Value
}

function Get-MavenVersion {

    $InstallerPOM = Join-Path (".") "pom.xml"
    $xml = New-Object XML
    $xml.PreserveWhitespace = $true
    $xml.Load($InstallerPOM)
    return $xml.project.version
}