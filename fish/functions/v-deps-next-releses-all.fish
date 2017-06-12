function v-deps-next-releses-all -d "Update properties to next release version" --wraps "mvn"

    mvn versions:update-properties -Dincludes=$argv[1]*

    and if read_confirm

        mvn versions:commit
        pom-commit-all "Setting version properties for next release"
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
