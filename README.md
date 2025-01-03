# git-curl
A small batch script for environments in which you no GUI, that allows you to choose a release  to download from a github repository.
Releases are downloaded in the folder you ran the script from.
# Usage:
1. Install dependencies.
```
curl
jq
fzf
```
2. Clone the repository
3. Make it executable with `chmod +x main.sh`
4. Run the script while passing the url of the github as argument. Example: `./main.sh https://github.com/PWDSerialgamer07/git-curl/`
