NeoBundle 'tomasr/molokai'
NeoBundle "scrooloose/syntastic"
NeoBundle "jmcantrell/vim-virtualenv"
NeoBundle 'gorodinskiy/vim-coloresque'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'vim-scripts/grep.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell.vim'
NeoBundle "majutsushi/tagbar"
NeoBundle "ervandew/supertab"
NeoBundle "MattesGroeger/vim-bookmarks"
NeoBundle "sjl/gundo.vim"
NeoBundle "mileszs/ack.vim"
NeoBundle "gregsexton/gitv"
NeoBundle "Lokaltog/vim-easymotion"
NeoBundle "Raimondi/delimitMate"
NeoBundle "terryma/vim-multiple-cursors"
NeoBundle "vim-scripts/SearchComplete"
NeoBundle 'Valloric/YouCompleteMe', {
     \ 'build' : {
     \     'mac' : './install.sh --clang-completer',
     \     'unix' : './install.sh --clang-completer',
     \    }
     \ }
NeoBundle "Yggdroot/indentLine"
NeoBundle "jamessan/vim-gnupg"
NeoBundle "myusuf3/numbers.vim"
" NeoBundle "powerline/powerline", {'rtp': 'powerline/bindings/vim/'}
NeoBundle "christoomey/vim-tmux-navigator"
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'edkolev/tmuxline.vim'
