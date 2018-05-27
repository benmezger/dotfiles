call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'                                          " base16 themes
Plug 'tpope/vim-fugitive'                                               " git <3
Plug 'tpope/vim-git'                                                    " vim Git runtime files
Plug 'scrooloose/syntastic'                                             " syntax checking
Plug 'editorconfig/editorconfig-vim'                                    " editorConfig plugin for Vim
Plug 'ctrlpvim/ctrlp.vim'                                               " fuzzy searching
Plug 'airblade/vim-gitgutter'                                           " show what lines have changed when inside a git repo
Plug 'valloric/youcompleteme', {'do': './install.py --clang-completer'} " completion
Plug 'haya14busa/incsearch.vim'                                         " a better insearch
Plug 'junegunn/vim-easy-align'                                          " easy align text
Plug 'jamessan/vim-gnupg'                                               " transparent editing of gpg files
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}                     " Markdown vim mode
Plug 'mhinz/vim-startify'                                               " the fancy start screen for vim
Plug 'tpope/vim-eunuch'                                                 " helpers for UNIX
Plug 'easymotion/vim-easymotion'                                        " Vim motions on speed
Plug 'luochen1990/rainbow'                                              " Rainbow Parentheses Improved
Plug 'mattn/gist-vim'                                                   " Github Gist support
Plug 'mattn/webapi-vim'                                                 " vim interface to Web API

" Add plugins to &runtimepath
call plug#end()

