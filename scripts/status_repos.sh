#!/bin/bash
# Usage:
#   ./status_repos.sh [parent_directory] 
#   example usage:
#       Windows: status_repos.sh C:/dev/myLocalRepositories
#       MacOs:   sudo status_repos.sh /Users/username/dev/myLocalRepositories

statusRepo() {

    local dir="$1"
    local original_dir="$2"

    cd $dir # switch to the git repo
    repo_url=$(git config --get remote.origin.url)

    echo "****************************************************************************"
    echo "Checking status in $PWD"

    # update the repo, then stash any local changes
    echo -e "\ncalling: git status"
    (git status) 

    #switch back to the starting directory
    cd $original_dir
    echo "Done!"
    echo ""
}

directory_to_update=${1}

if [ -z "$directory_to_update" ] 
  then
    echo "No directory passed in, using current directory"
    directory_to_update=$PWD
  else 
    echo "Directory passed in, using $directory_to_update"
fi 

echo "Checking status of git repo's in directory: $directory_to_update"
count=0

for dir in $(find $directory_to_update -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    statusRepo $dir $directory_to_update #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

echo "$count local git repos status have been listed!"
echo "Script complete"