function v-next -d "Set next minor version for pom.xml" --wraps "mvn"
    mvn build-helper:parse-version org.codehaus.mojo:versions-maven-plugin:2.3:set -DnewVersion='${parsedVersion.majorVersion}.${parsedVersion.nextMinorVersion}.0.1-SNAPSHOT'; \
    and mvn versions:update-child-modules; \
    and mvn versions:commit; \
    and if read_confirm
        pom-commit-all
    end

end


function read_confirm
  while true
    read -l -p read_confirm_prompt confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

function read_confirm_prompt
  echo 'Do you want to continue? [y/N] '
end