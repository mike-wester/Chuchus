#!/bin/bash
# Usage:
#   ./update_repo.sh [parent_directory] 
#   example usage:
#       Windows: update_repo.sh C:/dev/myLocalRepositories
#       MacOs:   sudo update_repo.sh /Users/username/dev/myLocalRepositories

checkoutRepo() {


    local url="$1"

    printf "\n****************************************************************************\n"
    printf "\Creating repository with url: %s\n" "$repo_url"

    # Rebase the original branch and then stash pop back to original state
    printf "calling: git clone %s\n" "$url"
    (git clone "$url")

    printf "Done!\n"
}

printf "\nScript starting\n\n"

repositories_to_checkout=(
    "https://github.com/mike-wester/mike-wester.github.io.git"
    "https://github.com/mike-wester/angular-atm.git"
    "https://github.com/mike-wester/goldfish.git"
    "https://github.com/mike-wester/gremlins.git"
)

printf "Creating git repo's in directory: %s\n" "$PWD"
count=0

for url in "${repositories_to_checkout[@]}"; do
    checkoutRepo "$url" #& #uncomment to make it run in multiple threads, meh
    ((count+=1))
done

printf "\n\n%s local git repositories status have been listed!\n" "$count"
printf "\nScript complete\n\n"