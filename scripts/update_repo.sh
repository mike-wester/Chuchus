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

    echo "****************************************************************************"
    echo "Updating repository: $dir with url: $repo_url"
    echo "Starting update in $PWD"

    main_branch="master"

    # If you have a repository where the primary branch isnt master use trunk
    if [ "$repo_url" == "git@someserver:repo/repo.git" ]; then
        $main_branch="trunk"
    fi

    # Update the repository, then stash any local changes
    echo -e "\ncalling: git fetch --all && git stash"
    (git fetch --all && git stash)

    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Switch to master/trunk branch and rebase it, then switch back to original branch
    if [ $current_branch != $main_branch ]; then
        echo -e "\ncalling: git checkout $main_branch && git rebase && git checkout $current_branch"
        (git checkout $main_branch && git rebase && git checkout $current_branch)
    fi

    # Rebase the original branch and then stash pop back to original state
    echo -e "\ncalling: git rebase && git stash pop on branch: $current_branch"
    (git rebase && git stash pop ) 

    # Switch back to the starting directory
    cd $original_dir
    echo "Done!\n"
}

directory_to_update=${1}

if [ -z "$directory_to_update" ] 
  then
    echo "No directory passed in, using current directory"
    directory_to_update=$PWD
  else 
    echo "Directory $directory_to_update passed in as argument"
fi 

echo "Updating git repo's in directory: $directory_to_update"
count=0

for dir in $(find $directory_to_update -maxdepth 4 -type d -name .git | xargs -n 1 dirname); do
    updateRepo $dir $directory_to_update #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

echo "$count local git repos have been updated!"
echo "Script complete\n"