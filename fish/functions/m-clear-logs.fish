# Defined in /tmp/fish.QYV1bh/m-clear-logs.fish @ line 2
function m-clear-logs
	truncate --size 0 /mnt/c/medavis/wildfly/standalone/log/*.log
    truncate --size 0 /mnt/c/projects/server/IT.wildfly-9.0.2.Final/standalone/log/*.log
end
