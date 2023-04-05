#!/bin/bash
# Usage:
#   ./list_repo.sh [parent_directory] 
#   example usage:
#       Windows: list_repo.sh C:/dev/myLocalRepositories
#       MacOs:   sudo list_repo.sh /Users/username/dev/myLocalRepositories

listRepo() {

    local dir="$1"
    local original_dir="$2"

    # Switch to the git repository
    cd $dir

    echo "****************************************************************************"
    echo "List branches in $PWD"

    # List current local branches for the directory
    echo -e "\ncalling: git branch -l"
    (git branch -l) 

    # Switch back to the starting directory
    cd $original_dir
    echo "Done!\n"
}

directory_to_process=${1}

if [ -z "$directory_to_process" ] 
  then
    echo "No directory passed in, using current directory"
    directory_to_process=$PWD
  else 
    echo "Directory $directory_to_update passed in as argument"
fi 

echo "Listing of git repository branches from base directory: $directory_to_process"
count=0

for dir in $(find $directory_to_process -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    listRepo $dir $directory_to_process #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

echo "$count local git repositories have been listed!"
echo "Script complete\n"