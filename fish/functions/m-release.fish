function m-release

	# set SVN_ROOT https://...
	# SVN_ROOT is set in ~/.local.fish

    set COMPONENTS common-component ejbframeworkparent \
        order-component document-component person-component workflow-component \
        communication-stack master-data-component vaadin-ui 

    set APPS admin-app p4m-next

    new-scratch

    echo Checkout apps...
    for app in $APPS;
        echo
        echo Checkout $app in the current path;
        svn co --quiet $SVN_ROOT/$app/trunk $app
    end

    for app in $APPS;
        echo
        echo Search snapshots in $app
        cd $app
        mvn dependency:list -DincludeGroupIds=de.medavis | grep de.medavis: | grep SNAPSHOT | sort | uniq
        cd -
    end


    echo Checkout components in background jobs into the current path...
    for component in $COMPONENTS $APPS;
        #echo
        #echo Checkout $component in the current path;
        svn co --quiet $SVN_ROOT/$component/trunk $component &
    end
end
