function scan-dependency
    set -l artifactId $argv[1]
    for dir in (find . -type d)
        if test -f $dir/pom.xml
            echo "Directory: $dir"
            mvn -f $dir/pom.xml dependency:list | grep $artifactId
        end
    end
end