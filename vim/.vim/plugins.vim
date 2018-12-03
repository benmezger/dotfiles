call plug#begin('~/.vim/plugged')

Plug 'chriskempson/base16-vim'                      " base16 themes
Plug 'tpope/vim-fugitive'                           " git <3
Plug 'tpope/vim-git'                                " vim Git runtime files
Plug 'editorconfig/editorconfig-vim'                " editorConfig plugin for Vim
Plug 'Shougo/denite.nvim'                           " more generic than fuzzy finder
Plug 'airblade/vim-gitgutter'                       " show what lines have changed when inside a git repo
Plug 'haya14busa/incsearch.vim'                     " a better insearch
Plug 'junegunn/vim-easy-align'                      " easy align text
Plug 'plasticboy/vim-markdown', {'for': 'markdown'} " Markdown vim mode
Plug 'mhinz/vim-startify'                           " the fancy start screen for vim
Plug 'tpope/vim-eunuch'                             " helpers for UNIX
Plug 'easymotion/vim-easymotion'                    " Vim motions on speed
Plug 'luochen1990/rainbow'                          " Rainbow Parentheses Improved
Plug 'dag/vim-fish'                                 " Vim support for editing fish scripts
Plug 'neomake/neomake'                              " lint checker
Plug 'bling/vim-bufferline'                         " how the list of buffers in the command bar
Plug 'mkitt/tabline.vim'                            " Configure tabs within Terminal Vim
Plug 'Yggdroot/indentLine'                          " Display the indention levels with thin vertical line

" autocomplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Python autocomplete
Plug 'zchee/deoplete-jedi'

" C/C++ autocomplete
Plug 'zchee/deoplete-clang'

" Add plugins to &runtimepath
call plug#end()

