function m-clear-logs

    truncate --size 0 /mnt/c/medavis/medavis-wildfly-dist/standalone/log/*.log
    truncate --size 0 /mnt/c/projects/server/IT.wildfly-9.0.2.Final/standalone/log/*.log

end
