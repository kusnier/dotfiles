#!/bin/bash
# git-author-rewrite.sh
# This script replace author/committer name/email in a git repo commit history

#SOURCES:
#https://gist.github.com/octocat/0831f3fbd83ac4d46451
#https://gist.github.com/frz-dev/adf8c2c7275da1369e0cc340feda0ba0
#https://gist.github.com/octocat/0831f3fbd83ac4d46451#gistcomment-2178506

### Print Guide ###
function print_help {
   echo "Syntax: 
 git-author-rewrite [-cn|--current_name CURRENT_NAME] [-ce|--current_email CURRENT_EMAIL] 
		    [-nn|--new_name NEW_NAME] [-ne|--new_email NEW_EMAIL] 
		    [-c|--committer] [-f]

 -cn -ce : name/email to match
 -nn -ne : new name/email
 -c : rewrite committer's name/email
 -f : force backup overwrite (needed when executing multiple times)
 -h : prints this guide

Notes:
 -  At least one old name/email and one new name/email must be provided.
 -  Unknown options will be passed to the 'git filter' command
 -  For all matches, both author/committer name and email will be replaced (if both are provided)
 -  To push the changes use the following command:
	git push --force --tags origin 'refs/heads/*'"
}


### Parse Arguments ###
POSITIONAL=()
while [[ $# -gt 0 ]]
do
   arg="$1"

   case $arg in
     -h)
	print_help
	exit 0
	shift
     ;;
     -cn|--current_name)
	CURRENT_NAME="$2"
	shift
	shift
     ;;
     -ce|--current_email)
	CURRENT_EMAIL="$2"
	shift
	shift
     ;;
     -nn|--new_name)
	NEW_NAME="$2"
	shift
	shift
     ;;
     -ne|--new_email)
	NEW_EMAIL="$2"
	shift
	shift
     ;;
     -c|--committer)
	COMMITTER="true"
	shift
     ;;
     *) # unknown option
	POSITIONAL+=("$1") # save it in an array for later
	shift
    ;;
   esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

### Check parameters ###
if [ -z "$CURRENT_EMAIL" ] && [ -z "$CURRENT_NAME" ]; then
   echo "Please insert at least old name or old email"
   exit 1
fi
if [ -z "$NEW_EMAIL" ] && [ -z "$NEW_NAME" ]; then
   echo "Please insert at least new name or new email"
   exit 2
fi

### Apply Changes ###
git filter-branch --env-filter "
   if [ \"\$GIT_AUTHOR_NAME\" = \"${CURRENT_NAME}\" ] || [ \"\$GIT_AUTHOR_EMAIL\" = \"${CURRENT_EMAIL}\" ]
   then
      [ ! -z \"$NEW_NAME\" ] && export GIT_AUTHOR_NAME=\"${NEW_NAME}\"
      [ ! -z \"$NEW_EMAIL\" ] && export GIT_AUTHOR_EMAIL=\"${NEW_EMAIL}\"
   fi

   if ( [ \"\$GIT_COMMITTER_EMAIL\" = \"${CURRENT_EMAIL}\" ] ) && [ \"$COMMITTER\" = \"true\" ] && [ ! -z \"$NEW_EMAIL\" ]
   then
      export GIT_COMMITTER_EMAIL=\"${NEW_EMAIL}\"
   fi

   if [ \"\$GIT_COMMITTER_NAME\" = \"${CURRENT_NAME}\" ] && [ \"$COMMITTER\" = \"true\" ] && [ ! -z \"$NEW_NAME\" ]
   then
      export GIT_COMMITTER_NAME=\"${NEW_NAME}\"
   fi
   " $@ --tag-name-filter cat -- --branches --tags

exit 0
