<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/logo.png" height="220">
</p>
=========
<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/demo.gif" >
</p>
Automatically take care the little things, so that you don't have to: persist files in your workspace session, persist their undo history, autosave, untrail spaces, and more!
# Features
## Sensible Settings
While `not enabled by default`, this plugin comes available with common unobtrusive vim settings that everybody can agree on.

If you would like to enable these settings (viewable in `plugin/workspace.vim`), add the following to your vimrc:
```
let g:workspace_sensible_settings = 1
```
## Workspace
#### Persistent Vim Session
Toggling the `ToggleWorkspace` command on will persistently track your session found in a current working directory, and all workspace features will be enabled. Conversely, toggling the command off will remove the session and disable the workspace features.

If Vim is run with a file argument and it's already in the session's workspace, Vim will load the session and go to the tab window that contains it. Otherwise, it will be loaded as a new tab in the session.

It is recommended you bind this command to a convenient shortcut, such as the following:
```
nnoremap <leader>w :ToggleWorkspace<CR>
```
The following default can be configured if you wish to change the session name:
```
let g:workspace_session_name = 'Session.vim'
```
#### Undo History

When in a workspace, file undo history is persisted between sessions, without needing to keep Vim on.

The following defaults can be configured if you wish to change feature behaviour:
```
let g:workspace_persist_undo_history = 1
let g:workspace_undodir='.undodir'
```
#### Cursor Positions
Any files in a workspace session will persist their cursor positions across reloads.
#### File Autosave
Files edited in a workspace session will autosave when leaving insert mode, idle in normal mode (defined by updatetime), or leaving a buffer view.

The following defaults can be configured if you wish to change feature behaviour:
```
let g:workspace_autosave = 1
set updatetime=1000
```
#### Untrailing Spaces
By default, all trailing spaces are trimmed before a buffer is autosaved.

The following default can be configured if you wish to enable (1) or disable (0) the feature.
```
let g:workspace_autosave_untrailspaces = 1
```
#### Omni Completion
Vim's omni completion is enabled by default, and any orphaned preview windows will automatically close when leaving insert mode.

# Installation
This plugin requires Vim 8.0, follows the standard runtime path structure, and can be installed with a variety of plugin managers.
### Using Plug
Paste the following in your `~/.vimrc` file:
```
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'thaerkh/vim-workspace'
call plug#end()
```
If you don't already have Plug, this will auto-download Plug for you and install the workspace plugin.

If you already have Plug, simply paste `Plug 'thaerkh/vim-workspace'` and call `:PlugInstall` to install the plugin.

Remember to `:PlugUpdate` often to get all the latest features and bug fixes!
### Using Vundle
Paste this in your `~./vimrc`:
```
Plugin 'thaerkh/vim-workspace'
```
### Using Pathogen
cd into your bundle path and clone the repo:
```
cd ~/.vim/bundle
git clone https://github.com/thaerkh/vim-workspace
```

# License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
