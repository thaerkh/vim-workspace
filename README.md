<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/logo.png" height="220">
</p>
=========
<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/demo.gif" >
</p>
Automatically manage your Vim session, coupled with tunable autosave features.
# Features
## Sensible Settings
While `not enabled by default`, this plugin comes available with useful vim settings that everybody can agree on.

If you would like to enable these settings (viewable in `plugin/workspace.vim`), add the following to your vimrc:
```
let g:workspace_sensible_settings = 1
```
## Workspace Sessions
#### Persistent Vim Session
Toggling the `ToggleWorkspace` command on will persistently track your session found in a current working directory, and all workspace features will be enabled. Conversely, toggling the command off will remove the session and disable the workspace features.

If Vim is run with a file argument and it's already in the session's workspace, Vim will load the session and go to the tab window that contains it. Otherwise, it will be loaded as a new tab in the session.

It is recommended you bind this command to a convenient shortcut, such as the following:
```
nnoremap <leader>s :ToggleWorkspace<CR>
```
The following default can be configured if you wish to change the session name:
```
let g:workspace_session_name = 'Session.vim'
```

#### Hidden Buffers
Over time, hidden buffers can build up to a point where most are unnecessary, with only those currently tied to a tab window being important.
When called, the command `CloseHiddenBuffers` will close any hidden buffers meeting this criteria.

#### Undo History

When in a workspace, file undo history is persisted between sessions, without needing to keep Vim on. Cursor positions will also persist across session reloads.

The following defaults can be configured if you wish to change feature behaviour:
```
let g:workspace_persist_undo_history = 1  " enabled = 1 (default), disabled = 0
let g:workspace_undodir='.undodir'
```

#### Omni Completion
Vim's omni completion is enabled by default. Any preview windows will automatically close on InsertLeave.

## Autosave
Files edited in a workspace session will autosave on InsertLeave, idle (CursorHold), pane switches (FocusLost and FocusGained), or buffer switches (BufLeave).

FocusLost and FocusGained triggers will typically trigger only with GUI versions of Vim. However, there are plugins that enables these for the console version within Tmux (i.e. sjl/vitality.vim).

The following defaults are shown as configuration examples, if you wish to change feature behaviour:
```
let g:workspace_autosave = 1
set updatetime=4000  " Default Vim setting (specifies CursorHold wait time).
```

#### Untrailing Spaces
By default, all trailing spaces are trimmed before a buffer is autosaved. If you don't prefer this behaviour, add this line:
```
let g:workspace_autosave_untrailspaces = 0
```

#### Autosave Ignore List
Git commit filetypes won't autosave (or trim trailing spaces) by default. You can customize the ignore list with this line:
```
let g:workspace_autosave_ignore = ['gitcommit']
```

## Indent Guides
Add the following if you would like to have indent guides for your files:
```
let g:workspace_indent_guides = 1
```
Manually calling the command `ToggleIndentGuides` will toggle indent guides scoped to a specific buffer.

Space indents are visually identified by the "┆" character, while tabs are distinguished by "|".

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
