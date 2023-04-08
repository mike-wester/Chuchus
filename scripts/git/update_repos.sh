#!/bin/bash
# Usage:
#   ./update_repo.sh [parent_directory] 
#   example usage:
#       Windows: update_repo.sh C:/dev/myLocalRepositories
#       MacOs:   sudo update_repo.sh /Users/username/dev/myLocalRepositories

updateRepo() {

    local dir="$1"
    local original_dir="$2"

    # Switch to the git repository
    cd "$dir" || exit

    repo_url=$(git config --get remote.origin.url)

    printf "\n****************************************************************************\n"
    printf "Updating repository: $dir with url: %s\n" "$repo_url"
    printf "Starting update in %sd\n" "$PWD"

    main_branch="master"

    # If you have a repository where the primary branch isnt master use trunk
    if [ "$repo_url" == "git@someserver:repo/repo.git" ]; then
        main_branch="trunk"
    fi

    # Update the repository, then stash any local changes
    printf "calling: git fetch --all && git stash\n\n"
    (git fetch --all && git stash)

    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Switch to master/trunk branch and rebase it, then switch back to original branch
    if [ "$current_branch" != "$main_branch" ]; then
        printf "calling: git checkout $main_branch && git rebase && git checkout %s\n" "$current_branch"
        (git checkout $main_branch && git rebase && git checkout "$current_branch")
    fi

    # Rebase the original branch and then stash pop back to original state
    printf "calling: git rebase && git stash pop on branch: %s\n" "$current_branch"
    (git rebase && git stash pop ) 

    # Switch back to the starting directory
    cd "$original_dir" || exit
    printf "Done!\n"
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

printf "Updating git repo's in directory: %s\n" "$directory_to_process"
count=0

for dir in $(find "$directory_to_process" -maxdepth 2 -type d -name .git | xargs -n 1 dirname); do
    updateRepo "$dir" "$directory_to_process" #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

printf "\n\n%s local git repositories status have been listed!\n" "$count"
printf "\nScript complete\n\n"