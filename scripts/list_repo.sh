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
    cd "$dir" || exit

    printf "****************************************************************************"
    printf "List branches in %s" "$PWD"

    # List current local branches for the directory
    printf "\ncalling: git branch -l"
    (git branch -l) 

    # Switch back to the starting directory
    cd "$original_dir" || exit
    printf "Done!\n"
}

directory_to_process=${1}

if [ -z "$directory_to_process" ] 
  then
    printf "No directory passed in, using current directory"
    directory_to_process=$PWD
  else 
    printf "Directory %s passed in as argument" "$directory_to_process"
fi 

printf "Listing of git repository branches from base directory: %s" "$directory_to_process"
count=0

for dir in $(find "$directory_to_process" -print0 -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    listRepo "$dir" "$directory_to_process" #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

printf "%s local git repositories have been listed!" "$count"
printf "Script complete\n"