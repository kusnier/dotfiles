# Defined in /tmp/fish.Fg4v5Q/m-deploy-sms.fish @ line 2
function m-deploy-sms
	cp -v /mnt/c/projects/source/medavisnext/sms-service/sms-service-ear/target/sms-service-*.ear /mnt/c/medavis/wildfly/standalone/deployments/
end
