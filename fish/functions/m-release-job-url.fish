# Defined in /tmp/fish.o1SgMi/m-release-job-url.fish @ line 2
function m-release-job-url
	set DRY_RUN false
    set USER_TOKEN $JENKINS_USER_TOKEN
    set URL "$JENKINS_RELEASE_URL/$argv[1]"

    echo Send post to $URL
    curl -X POST "$URL/buildWithParameters?DRY_RUN=$DRY_RUN" --user $USER_TOKEN --insecure -v
end
