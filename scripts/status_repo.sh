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
    cd "$dir" || exit

    printf "\n****************************************************************************\n"
    printf "Checking status of repository in %s\n" "$PWD"

    # Status check current directory
    printf "\ncalling: git status\n"
    (git status) 

    # Switch back to the starting directory
    cd "$original_dir" || exit
    printf "Done!\n"
}

directory_to_process=${1}

printf "\nScript starting\n\n"

if [ -z "$directory_to_process" ] 
  then
    echo "No directory passed in, using current directory\n"
    directory_to_process=$PWD
  else 
    printf "Directory %s passed in as argument\n" "$directory_to_process"
fi 

printf "Checking status of git repositories in directory: %s\n" "$directory_to_process"
count=0

for dir in $(find "$directory_to_process" -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    statusRepo "$dir" "$directory_to_process" #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

printf "\n\n%s local git repositories status have been listed!\n" "$count"
printf "\nScript complete\n\n"