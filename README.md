vim-workspace
=========
A minimalist Vim session and undofile history wrapper plugin for seamlessly keeping track of your project workspace.

![img](https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/demo.gif)

## Installation
This plugin follows the standard runtime path structure, and can be installed with a variety of plugin managers.
### Using Plug
Paste the following in your vimrc:
```
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall
endif

call plug# begin('~/.vim/plugged')
Plug 'thaerkh/vim-workspace'
call plug# end()
```
Once you fire up Vim, it will auto-download Plug for you and install the vim-workspace plugin ready for use.
## Usage
### Persistent Workspace
The following is an example binding for the `ToggleWorkspace` command, which when toggled on will track your session, until it's toggled off.
```
nnoremap <leader>m :ToggleWorkspace<CR>
```
If you open Vim with file arguments and a workspace session already exists, the plugin will prompt you for whether you want to overwrite with the new session or load the pre-existing one.

The following session name is the configurable default, if you wish to change it:
```
let g:workspace_session_name = '.session.vim'
```
### Persistent Undo History

When in a workspace, file undo history and cursor position is persisted between sessions, without needing to keep Vim on.

The following are configurable defaults:
```
let g:workspace_persist_undo_history = 1
let g:workspace_undodir='.undodir'
```
### File Autosave
Being in a workspace enables a file autosave feature that saves the buffer if a cursor is idle for the allotted updatetime, or if exiting insert mode.

These are the configurable defaults:
```
let g:workspace_autosave = 1
let g:workspace_autosave_updatetime = 1000
```

## License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
