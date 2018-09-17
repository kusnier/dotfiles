# Defined in /tmp/fish.461f8i/svn-url.fish @ line 1
function svn-url
	svn info | grep "^URL:" | cut --delimiter " " --fields=2
end
