# fetch all zsh aliases 
alias | awk -F'[ =]' '{print $1}'

print -l ${(ok)functions}
