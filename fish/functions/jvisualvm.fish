function jvisualvm -d "jvisualvm with jboss classpath" --wraps "jvisualvm"
    eval $JAVA_HOME/bin/jvisualvm -cp $JBOSS_HOME/libexec/bin/client/jboss-client.jar
end
