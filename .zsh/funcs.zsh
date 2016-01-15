# generate git ignore
function gitignore(){
    curl -L -s https://www.gitignore.io/api/$@;
}

# start ipython notebook in the background
ipynb(){
	ipython notebook --pylab inline >/dev/null 2>&1 </dev/null &;
    disown;
}

# kill ipython notebook process
ipynbk(){
    kill $(ps aux | grep '[i]python notebook' | awk '{print $2}')
}

# pdpid=$(pgrep -f powerline-daemon)
# pdpid=$(ps ax | grep powerline-daemon | cut -d":" -f1 | cut -d" " -f1 | head -n 1)
# if [ -z $pdpid ]; then
#     powerline-daemon -q&
# fi

take(){
	mkdir -p $1
	cd $1
}

function copyfile {
	[[ "$#" != 1 ]] && return 1
	local file_to_copy=$1
	cat $file_to_copy | pbcopy
}

# sources
if [ -d "$HOME/.zsh/z" ]; then
	source $HOME/.zsh/z/z.sh # z for cd
fi

if [ -d "$HOME/.zsh/s" ]; then
	source $HOME/.zsh/s/s.sh # s is a tool for ssh like z for cd
fi

if [ -d "$HOME/.zsh/bd/" ]; then
	source $HOME/.zsh/bd/bd.zsh # Quickly go back to a specific parent directory instead of typing cd ../../.. redundantly
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add ~/.ssh/bdigi_ocean
fi

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}
