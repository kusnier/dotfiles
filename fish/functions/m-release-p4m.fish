function m-release-p4m

    set URL "$JENKINS_RELEASE_URL/Release%20P4M.next"

    m-release-job-url $URL
end
