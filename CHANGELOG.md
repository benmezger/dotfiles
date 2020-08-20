<a name="unreleased"></a>
## [Unreleased]

### Chore
- Add CHANGELOG

### Zsh
- Update PATH with GOPATH


<a name="v3.2"></a>
## [v3.2] - 2020-08-20
### Alacritty
- Enable background opacity

### Chore
- Bump actions/checkout version to v2.3.2
- Ignore ansible.cfg on Chezmoi apply
- Cache Applications on OSX
- Cache /usr/local on OSX
- Runn homebrew cleanup before caching
- Disable docker caching completly
- Pull from specified docker tag and repo owner
- Manually build and push docker image
- Fix Docker's GH name requirement
- Disable Docker layer-caching and use GH registry

### Docs
- Add OSX defaults
- Update COMMANDS.org
- Update README/COMMANDS.org

### Dunst
- Add app name to notification

### Emacs
- Remove unused ref-capture template
- Add custom orgmode file snippet
- Add weekly journal capture
- Add HUGO_TAGS to roam
- Turn on auto-fill on org buffers

### Fix
- Push docker image to Github with correct tag

### Greenclip
- Add greenclip configuration

### I3
- Add Rofi's greenclip shortcut

### I3
- Enable backlight block for status
- Add Pomodoro to status bar
- Auto hide status bar
- Allow window stick to workspaces

### Rofi
- Enable run combi
- Use papirus dark icon theme
- Show application icons
- Update rofi configuration so it uses combi

### X
- Enable xcompmgr for opacity
- Move i3 non restart startup to xinitrc

### Zsh
- Add Django aliases
- Add pacman aliases
- Add emacsclient alias
- Update ls aliases
- Remove unused ccat alias
- Add Docker tab completion
- Add chezmoi custom completion
- Add correct zsh-completion path
- Disable Tmux autostart if running on i3wm

### Reverts
- Chore: Disable Docker layer-caching and use GH registry
- Chore: Fix Docker's GH name requirement
- Chore: Manually build and push docker image
- Fix: Push docker image to Github with correct tag
- Chore: Pull from specified docker tag and repo owner


<a name="v3.1"></a>
## [v3.1] - 2020-08-12
### Alacritty
- Start in Windowed mode in Linux
- Refactor deprecated config and per machine font size

### Bash
- Add bashrc

### Chore
- Add custom ansible.cfg
- Get exit code from dotfiles
- Change workflow name
- Chezmoi ignore docs
- Tap emacs 28 on OSX
- Disable pyenv for archlinux
- Add OSX language to Python
- Force python update
- Don't enable network/slim
- Link commands to README
- Remove language from travis OSX build
- Remove problematic AUR dependencies
- Temporary disable inconsolata due to xorg-font
- Ignore ansible files with chezmoi and fix i3blocks
- Use trizen instead of pacaur
- Remove duplicate key and mount src as volume
- remove removed/moved/renamed archlinux packages
- Set state to present and sync pacman
- Use pacman module instead of command
- Include common main task in Archlinux
- Refactor Travis to handle multiple OSes
- Ignore ansible files with chezmoi and fix i3blocks
- Use trizen instead of pacaur
- Remove duplicate key and mount src as volume
- remove removed/moved/renamed archlinux packages
- Set state to present and sync pacman
- Use pacman module instead of command
- Include common main task in Archlinux
- Refactor Travis to handle multiple OSes
- Enable pyenv for Archlinux
- Use pacaur for AUR dependencies
- Add aur ansible requirement
- Add Dockerfile for Archlinux

### Dircolors
- Use gruvbox dircolors

### Docs
- Update todos
- Add custom export path
- Remove travis badge and add github workflow
- Add documentation html
- Update TODO list
- Add doom compile command
- Update todo progress
- Add basic dotfiles commands
- Update todo list
- Move markdown to orgmode

### Emacs
- Move undo plugin to :emacs section
- Enable undo tree mode
- Check if system is gnu/linux before setq
- Check if system is gnu/linux before setq

### Feat
- Use i3status-rust instead of polybar
- Add aur packages

### Font
- Use Hack font globally
- Use Hack font globally

### I3
- Add autodisplay configuration

### I3
- Enable github in status bar
- Update resize/move keybindings
- Add i3-gaps configuration and modes
- Remove pulseaudio from polybar
- set 1920x1080 resolution
- Use polybar and refactor configuration

### Inputrc
- Update colors-stats and completion

### Polybar
- Add initial polybar configuration

### Refactor
- Refactor ansible roles and CI

### Rofi
- Use gruvbox-dark-hard theme

### Vim
- Cleanup plugins

### X
- Add dwm to session list
- Speed up keyboard

### Zsh
- Check if nvim exists before aliasing vim


<a name="v3.0"></a>
## [v3.0] - 2020-08-06
### Chore
- Handle chezmoi in Ansible roles
- Add default chezmoi sourceDir

### Docs
- Add todo file

### Feat
- Add dotfiles with chezmoi project structure

### Refactor
- Remove dotfiles


<a name="v2.2"></a>
## [v2.2] - 2020-08-05
### Chore
- Remove master branch
- Update OSX brew dependencies

### Emacs
- Reindent config.el
- Update todo keywords and org capture templates
- Enable org's journal/latex support
- Remove find-file org-roam hook
- toggle max frame on startup
- Use usr/local/bin wakatime version
- Remove format-all ignored configuration
- Set org-archive-location to archives/ dir
- Use doom-vibrant theme
- Run formatter only on specific modes

### Fix
- Enable onsave format and ignore specific modes

### Theme
- Use nord colorscheme

### Vim
- Disable statusline background

### Reverts
- Theme: Use nord colorscheme
- Emacs: Use doom-vibrant theme
- Vim: Disable statusline background


<a name="v2.0"></a>
## [v2.0] - 2020-07-26
### Alacritty
- Remove deprecated Faux scrolling
- Fixed shell path and font-size
- Fixed shell path and font-size
- Fixed font size
- Add custom point size and fix shell program path
- Update theme from Molokai to Gruvbox

### Bin
- Use zsh instead of bash for initializing Emacs
- Add emacs start script which check for a running server first

### Brew
- Add maccy and syncthing to Ansible task

### Chore
- Cache pyenv
- Update Travis failing ansible test
- Clone Emacs doom
- Add Brave-browser and remove some applications from OSX role
- Install Ansible requirements before running the playbook
- Build OSX branch on travis

### Docs
- Add initial README.md
- Update README.md

### Dunst
- Add simpler theme

### Emacs
- Temporary disable syntax plugin
- Update elfeed org-files
- Update roam private files
- Enable yasnippet-snippets
- Enable Doom debugger
- Remove duplicate org variable declaration
- Load org-projectile after projectile
- Defer packages
- Enable org-projectile per project TODO
- Enable yaml mode
- Use InconsolataDZ font and monokai theme
- Disable icons
- Add org-roam hooks from jethrokuan/dots
- Add org-roam plugin
- Disable indent-guides
- Disable continuous word count for org-mode
- Enable fill-column and indent-guides
- Fix org-capture templates
- Add ob-mermaid org-mode minor-mode
- Change elfeed-org files path
- org will log everything in a drawer
- Add better org-mode defaults and custom todo-keywords
- Better deft defaults
- Add org-clock-persist and enable deft package
- Reformat doom's init.el
- Disable doom-dashboard
- Remove assembly, enable hugo and gnuplot for orgmode
- log time when closing an issue
- Remove org-jira
- redefine org-jira variables and set custom JQLS
- Disable super-save
- Enable org-mode/org-jira and update def-package declarations
- Disable evil-normalize-all buffers and add isort package
- Set xref definitions evil binding
- Use LSP instead of eglot
- Ignore check startup files for exec-path-from-shell
- Disable ccls package due to lsp's version
- Check if emacs is running under osx before using execpath
- Add Golang support
- Set CCLS executable path before requiring ccls
- Remove "^" from ivy counsel-mx
- Move setup minibuffer to use-package :custom
- Use clang-format package for c-mode files
- Change how eglot is started
- Copy $PATH env when running exec-path-from-shell
- Make projectile set pyenv when entering a Python project
- Use blacken for running black automatically when on python-mode
- Add ccls package fro C completion
- Remove lsp-ui as its not supported by EGLOT
- python.el general refactoring
- Add company-tabnine package
- Remove indent-guide
- Configure anybar to notify if Emacs is running or not
- Fixed icons and font when running Emacs daemon mode
- Start server if server is not running
- Remove all packages in package list and use use-package
- Defer python up to 2
- Remove invalid variable
- Defer .1 for in package-use
- Add requirements to user-package in completion.el
- Add extra configuration for doom-modeline and use gruvbox
- Custom C hooks
- Projectile known projects and cache files should be set before package-use
- Use regex for counsel-rg instead of fuzzy matching
- Check startup time, set LANG env and fix undo-tree issue
- Configure company-complete keybinding and irony autosetup
- Remove company-c-headers and use irony instead
- 3rd party removal update
- Add Irony-mode for C source files
- Fixes emacs-cache-directory call on Projectile and Undotree
- Fixed Linux frame-font
- Fixed font size for Linux
- Quick fix for Emacs which allows downloading packages
- Fix undo-tree history directory
- Fixes Emacs bug which returns bad request for installing packages
- Add projectile evil keys
- Add projectile known projects to cache folder
- Add .cache directory to temporary files
- Don't defer execpath
- Set cache directory and store undo-tree history
- Improve startup time by defering packages
- Remove evil normal state message
- Remove ^ from ivy-initial-inputs-alist
- Enable tabs by using centaur-tabs
- Automatically close all Magit buffers on magit-quit
- Don't set mode-icons-mode since Doom-modeline does this for us
- Use Doom-themes and Doom-modeline [testing]
- Add magit- keys to evil-leader
- Fix evil-leader key
- Fix evil-leader key
- Set evil keybinding
- Surpress messages when on minibuffer.
- Disable C-x C-b which was binded to buffer-list
- Save buffer when evil-insert exists
- Set evil-leader keybindings
- Add before-save-hook when on Python-mode
- silently save
- add super_save package
- Store point position
- Configure buffer/window evil-leader keys and remove load message
- Set new evil-leader bindings
- Add evil-magit to dependencies
- Let pyenv-mode-auto handle the switch instead.
- Make RG ignore huge lines
- Set evil-leader to counsel-gel
- Make evil-mode drop to normal state after 30sec of idle
- Make projectile sort by recently active buffers/opened files
- Load execpath only if system is OSX
- Add unicode to org-mode TODO keywords
- Turn-off bell completly
- Switch font size if system is gnu/linux
- Set counsel kill-ring history key binding
- Run black before saving a Python file
- Highligh 80 line column
- Add smex as dependecy for managing ivy's M-x history
- Set counsel kill-ring history key binding
- Disable mouse in Emacs
- Add ivy-rich and icons to dependecy list
- Remove counsel-rhythmbox keybind
- Set evil key for specific modes
- Install flx for fuzzy matching
- Set magit and projectile completion system
- Fixed conusel ensure typo
- Add etags support
- Swith python version on projectile change
- set counse-imenu to a evil-leader key
- Add new leader-keys to evil
- Add evil-leader to ivy-resume
- ignore .ido and smex files
- Enable Ivy-mode globally with evil-mode leader configured
- Completly disable helm-mode
- Refactored helm-fuzzy variables
- Ignore projectile cache file
- Set a better cache and enable Helm integration

### Feat
- Add Travis config
- Add Ansible files for auto install

### Fix
- Disable Emacs server
- Check if pyenv exists and if so, evaluate it
- Don't let homebrew autoupdate
- Remove duplicated LS_COLORS and GREP_COLORS
- Updated Alacritty's config

### GIt
- Ignore ccls-cache

### GPG
- Fixed Linux pinentry program

### Git
- Remove conflicting Ruby ignore with Go required paths
- Add correct PGP key
- Ignore Terraform cache files
- Ignore emacs temporary files
- Add useful commit tips as a git-commit template
- Prune when pulling from origin
- Remove diff-so-fancy as diff pager
- Add merge strategy to git's global config
- Merge  strategy to specific files where merge should not overwrite
- Ignore Emacs's irony files
- Fixed templatedir path
- Don't add Makefile to the global git ignore file
- Set custom hooks for git init

### Gnupg
- Add pinentry-mac's program to gpg agent

### I3
- Start ckb-next for the keyboard and solaar for the mouse.

### I3
- Fixed font size for i3bar

### I3wm
- Add gruvbox colors and bind Alacritty to $mod+Return

### Ipython
- Add vi key-bindings

### Kitty
- Add Kitty's terminal configuration

### Linux
- Merged linux configuration to OSX

### Misc
- Remove deprecated Alacritty config
- Configure tab sizes for html and js related files
- Add Rofi config

### Refactor
- Remove old Emacs configuration

### TMP
- REMOVE README.md FROM CKL
- Added first anex modified file

### Test
- Remove OSX's /Application directory from Travi's cache system

### Tmux
- Use themepack instead of custom theme
- Set new theme and remove custom theme
- Set mode style (mode-highlight colour)
- Refactored Tmux config

### Vim
- Use gruvbox theme
- Fixed wrong gitignore file
- Add gitignore

### X
- Remove rofi from XResource and use Gruvbox theme

### ZSH
- Move pyenv to it's own scope

### Zsh
- Add FZF options
- Update env-secrets path
- Install zsh wakatime plugin
- Move pyenv to zshenv instead and don't rehash
- Disable beep
- Remove duplicate eval on dircolors
- Set Golang path
- Fixes pyenv not auto-switching versions between projects
- Check if shell is running within an SSH session
- Export path before checking if pyenv exists
- Check OS before sourcing Antibody
- Check OS before sourcing Antibody
- Fix Antibody path
- USe Gruvbox hard dark base16 theme
- source secrets env if available
- Speed up pyenv init by launching zsh
- Set custom backward delete word function
- Set pyenv path before checking if command exists in init.zsh
- evaluate pyenv in zshrc and export variables in zshenv
- Set PYENV_VERSION, initialize virtualenv and don't source path.zsh
- Re-indent
- Move path file to zshenv
- Move env file to zshenv instead
- Set antibody full path instead
- Removed unused alias
- Set antibody full path instead
- Removed unused alias
-  Autoenv plugin for managing directory .envs
- Don't use unicode for GITLINE untracked upstream
- Add rbenv support
- Make sure we import init.zsh before everything else
- Make sure yo import init before everything else
- Make virtualenvwrapper use pyenv
- Initialize fasd if command exists
- Check if fasd exists before making the alias
- Remove redundent source of init and move antibody to first line
- Check if file exists before sourcing it
- Overwrite ls alias if exa exists
- Don't try to auto-correct command arguments
- Fix OSX ls alias
- Don't use unicode for non-tracked upstream git branch
- Load api keys
- Enable GPG agent to autostart when the shell starts
- Use gpg-agent plugin from OMZ
- Check OSTYPE of settting dircolor alias
- Set LS colors

### Reverts
- Emacs: Save buffer when evil-insert exists
- Zsh: Don't use unicode for non-tracked upstream git branch


<a name="v1.1"></a>
## [v1.1] - 2019-05-16
### Alacritty
- Keybindings for font-size and new instance

### Emacs
- Projectile indexing and caching config.
- Kill minibuffer when outsite of it gets clicked
- human-readable file size in dired-mode
- Add helm-rg and ripgrep as dependency
- Move evil's minibuffer setup to :custom instead of :config
- Update gitignore
- Add auto package update plugin
- Use diminish to hide minor-modes from showing in the modeline
- Set extra configurations for general usage, such as:
- Ignore projectile bookmarks
- Don't add new line to a new task
- Set exec-path-froms-shell variables to copy
- Set evil-leader bookmark-jum and elpy-goto-def binding
- Bind f to helm-projectile
- Add projectile package
- Set default shell
- set evil-leader package and bind it to keys
- Add new line to capture-template title
- Refactor variables
- Add GTD support for org-mode
- Fixed org-mode journal agenda
- Set org-journal file format.
- Start with a maximized frame
- Set pgp as org-mode filetype
- Use icons for modes
- Fixed packages.el indentation
- Set wakatime home path
- Fixed helm.el indentation
- Set helm-grep commands
- Fixed helm.el indentation
- General changes to orgmode and org-journal
- Renamed frame-font to InconsolataDZ
- Add PGP mode
- Use asciidoc-mode package
- Close org-journa on save
- Set git-gutter at the right fringe
- Use relative numbers type
- org-mode auto indent, and set custom time-stamp format
- Fix org-agenda files directory
- Set org-agenda files
- Fixed missing lisp parenthesis
- Org-mode include diary and todos in agenda
- use org-journal package
- Set org-mode keybindings and default note file
- Use semi-column instead of column for avy-goto-char
- Use Avy package instead of ace-jump
- Enabled dired all-the-icons mode
- Display battery status
- Change evil-mode cursor type and move back to normal-state on save
- Set font correctly
- Use internal line number instead
- Add ace-jump mode
- Enable highlight-indent-guides mode
- Disable highligh-indentation minor-mode on elpy
- Set linum height
- Allow evil mode on minibuffer
- Runf flycheck only on save.
- Add exec-path to package when using OSX
- Yaml mode package
- Enable global completion
- Set yasnippet directory
- Enable markdown mode
- Show parenthesis connection mode
- Fixed relative linum which was not working properly
- Add undo-tree package
- set personal information
- Save history
- Display time
- Bind C-c h o to helm-occur
- Use helm-mini instead of helm-buffer-list.
- Bind M-x to helm-M-x
- Add yasnippet package
- Use mode-line-bell to flash the modeline
- set no-config-load-theme for modeline and workspace variable
- Add smart-mode-line to packages
- set evil-want-integration
- Enable visual bell
- Fixed missing parenthesis
- Load gitgutter
- Add git-gutter to packages
- Use emac's own line numering
- Use inconsolata-dz font globally.
- Set which-key to use setupbuffer and set Helm fuzzy config
- Add helm-ls-git-ls to packages
- Use evil-magit for a better evil and magit integration
- Refactor code indentation
- Add orgmode to packages
- First Emacs config

### Emcas
- Set evil-{emacs, insert, motion} states to nil

### Fish
- Add anybar completion
- Add rbenv path (quick-fix)
- Update fisher z's remote plugin directory
- Use exa command as alias to ls.
- Updated gitignore with new custom fish files.
- Update .gitignore path for fish

### Fix
- Moved .gitignore files to it's proper directory to prevent stow conflict.

### Git
- Ignore .python-version

### GnuPG
- Fixed obsolete keyserver option
- Ingore private-keys directory

### Gnupg
- Use OSX pinentry-program.
- Use pinentry-qt for Linux.
- Add gpg config.

### Misc
- Set Alacritty's default terminal program and enable persistent log
- Set indent size for *.el files
- Set snippet indent style in editorconfig

### Tmux
- Fixed unknown variable after Tmux upgrade

### Vim
- Add current git branch to statusline
- Disable runtime snippets
- More code snippets for Neosnippets
- Fixed snippet variable
- Add new line to vim snippet
- Add list comprehension to snippet list
- More Python snippets
- Add Neosnippet snippet files
- Use Neosnippet for better compatibility with deoplete.
- Ultisnips snippet file with more snippets
- Use Ctrl+<key> for Ultisnips
- Ultisnipet snippet files
- use Ultisnipet plugin for managing snippets
- fix file_rec typo to file/rec on denite
- Use vimgrep with rg on denite find file
- Use new file/rec command instead of file_rec for Denite
- Use Wakatime's plugin to create programming metrics

### X
- Set DPI for thinkpad

### Zsh
- Add prezto Git alises
- Use LS_COLORS
- Remove OMZ's tmux integration from plugin list
- Source zsh's init file and paths.zsh to get new paths
- Set tmux autostart
- Match upper and lower case
- Remove auto-suggestions which slows down the shell
- Change PGP key id
- Add z plugin
- Add zsh-history-substring-search plugin
- Move vi-bind-key to the top and remove emacs binding
- Fetch autosuggestion asynchronously
- Enable zsh-autosuggestions plugin
- Group completion by category and enable approximate matches
- Completion option
- Correct command if we run a wrong one
- Fully new ZSH config with a much faster performace

### Reverts
- Emacs: Use emac's own line numering


<a name="v1.0"></a>
## v1.0 - 2019-03-14
### Docs
- Update README.md

### Fish
- Set ambiguous width on fish and update gitignore.

### Git
- Remove credential helper
- Use mdls as textconv for PDF diff

### Misc
- Update editorconfig with html/css config

### Tmux
- removed duplicated history-limit config

### Vim
- Update base16-vim repository and check if vim has python 3

### ZSH
- Update zshrc with a better ls aliass; disable tmux auto-start; remove gpg-agent


[Unreleased]: https://github.com/benmezger/dotfiles/compare/v3.2...HEAD
[v3.2]: https://github.com/benmezger/dotfiles/compare/v3.1...v3.2
[v3.1]: https://github.com/benmezger/dotfiles/compare/v3.0...v3.1
[v3.0]: https://github.com/benmezger/dotfiles/compare/v2.2...v3.0
[v2.2]: https://github.com/benmezger/dotfiles/compare/v2.0...v2.2
[v2.0]: https://github.com/benmezger/dotfiles/compare/v1.1...v2.0
[v1.1]: https://github.com/benmezger/dotfiles/compare/v1.0...v1.1
