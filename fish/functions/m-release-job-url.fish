# Defined in /tmp/fish.4REDT0/m-release-job-url.fish @ line 2
function m-release-job-url
	set RELEASE true
    set URL "$JENKINS_RELEASE_URL/$argv[1]"

    echo Send post to $URL
    curl -X POST "$URL/buildWithParameters?RELEASE=$RELEASE" --netrc --insecure -v
end
