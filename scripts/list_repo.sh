#!/bin/bash
# Usage:
#   ./list_repo.sh [parent_directory] 
#   example usage:
#       Windows: list_repo.sh C:/dev/myLocalRepositories
#       MacOs:   sudo list_repo.sh /Users/username/dev/myLocalRepositories

listRepo() {

    local dir="$1"
    local original_dir="$2"

    cd $dir # switch to the git repo
    repo_url=$(git config --get remote.origin.url)

    echo "****************************************************************************"
    echo "List branches in $PWD"

    # update the repo, then stash any local changes
    echo -e "\ncalling: git branch -l"
    (git branch -l) 

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

echo "Listing of git repo's in directory: $directory_to_update"
count=0

for dir in $(find $directory_to_update -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    listRepo $dir $directory_to_update #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

echo "$count local git repos have been listed!"
echo "Script complete"