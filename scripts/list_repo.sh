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

    printf "\n****************************************************************************\n"
    printf "List branches in %s\n" "$PWD"

    # List current local branches for the directory
    printf "calling: git branch -l\n\n"
    (git branch -l) 

    # Switch back to the starting directory
    cd "$original_dir" || exit
    printf "\nDone!\n"
}

directory_to_process=${1}

printf "\nScript starting\n\n"

if [ -z "$directory_to_process" ] 
  then
    printf "No directory passed in, using current directory\n"
    directory_to_process=$PWD
  else 
    printf "Directory %s passed in as argument\n" "$directory_to_process"
fi 

printf "Listing of git repository branches from base directory: %s\n" "$directory_to_process"
count=0

for dir in $(find "$directory_to_process" -maxdepth 2 -type d -name .git | xargs -n 1 dirname); do
    listRepo "$dir" "$directory_to_process" #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

printf "\n\n%s local git repositories have been listed!\n" "$count"
printf "\nScript complete\n\n"