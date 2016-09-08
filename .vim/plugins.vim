call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'                                          " base16 themes
Plug 'tpope/vim-fugitive'                                               " git <3
Plug 'scrooloose/syntastic'                                             " syntax checking
Plug 'editorconfig/editorconfig-vim'
Plug 'ctrlpvim/ctrlp.vim'                                               " fuzzy searching
Plug 'airblade/vim-gitgutter'                                           " show what lines have changed when inside a git repo
Plug 'valloric/youcompleteme', {'do': './install.py --clang-completer'} " completion
Plug 'haya14busa/incsearch.vim'                                         " a better insearch
Plug 'junegunn/vim-easy-align'                                          " easy align text
Plug 'jamessan/vim-gnupg'                                               " transparent editing of gpg files
Plug 'plasticboy/vim-markdown'                                          " Markdown vim mode

" Add plugins to &runtimepath
call plug#end()
