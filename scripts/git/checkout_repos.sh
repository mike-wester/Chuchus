#!/bin/bash
# Usage:
#   ./checkout_repos.sh
#   example usage:
#       Windows: checkout_repos.sh C:/dev/myLocalRepositories
#       MacOs:   sudo checkout_repos.sh /Users/username/dev/myLocalRepositories

checkoutRepo() {


    local url="$1"

    printf "\n****************************************************************************\n"
    printf "\nCreating repository with url: %s\n" "$url"

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

printf "\n\n%s local git repositories status have been created!\n" "$count"
printf "\nScript complete\n\n"