# Defined in /tmp/fish.3cOozG/m-set-version.fish @ line 2
function m-set-version
	mvn versions:set -DartifactId='*' -DgenerateBackupPoms=false -DprocessAllModules=true -DnewVersion=$argv
end
