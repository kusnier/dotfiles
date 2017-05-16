function pom-commit-all -d "Commit all poms" --wraps "mvn"
    set poms ***pom.xml
    mvn scm:checkin -Dincludes="$poms" -Dmessage="Setting snapshot versions for next release"
end
