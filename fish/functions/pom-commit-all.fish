function pom-commit-all -d "Commit all poms" --wraps "mvn"
        mvn scm:checkin -Dincludes="***pom.xml" -Dmessage="Setting snapshot versions for next release"
end
