# Defined in /tmp/fish.fpHiIe/m-set-version.fish @ line 2
function m-set-version
	mvn versions:set -DgenerateBackupPoms=false -DprocessAllModules=true -DnewVersion=$argv
end
