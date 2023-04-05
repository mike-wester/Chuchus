#!/bin/bash
# Usage:
#   ./status_repo.sh [parent_directory] 
#   example usage:
#       Windows: status_repo.sh C:/dev/myLocalRepositories
#       MacOs:   sudo status_repo.sh /Users/username/dev/myLocalRepositories

statusRepo() {

    local dir="$1"
    local original_dir="$2"

    # Switch to the git repository
    cd $dir

    echo "****************************************************************************"
    echo "Checking status of repository in $PWD"

    # Status check current directory
    echo -e "\ncalling: git status"
    (git status) 

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
    echo "Directory $directory_to_process passed in as argument"
fi 

echo "Checking status of git repositories in directory: $directory_to_process"
count=0

for dir in $(find $directory_to_process -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    statusRepo $dir $directory_to_process #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

echo "$count local git repositories status have been listed!"
echo "Script complete\n"