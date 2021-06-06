<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/logo.png" height="220">
</p>
<p align="center">
<img src="https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/demo.gif" >
</p>

# Features

## Workspace Sessions

#### Persistent Vim Session

Session tracking can be activated automatically (disabled by default):
```
let g:workspace_autocreate = 1
```

Toggling the `ToggleWorkspace` command on will persistently track your session found in a current working directory, and all workspace features will be enabled. Conversely, toggling the command off will remove the session and disable the workspace features.

If Vim is run with a file argument and it's already in the session's workspace, Vim will load the session and go to the tab window that contains it. Otherwise, it will be loaded as a new tab in the session. If you would rather create a new buffer in the existing tab instead of creating a new tab:
```
let g:workspace_create_new_tabs = 0  " enabled = 1 (default), disabled = 0
```

It is recommended you bind this command to a convenient shortcut, such as the following:
```
nnoremap <leader>s :ToggleWorkspace<CR>
```
The following default can be configured if you wish to change the session name:
```
let g:workspace_session_name = 'Session.vim'
```

Use `g:workspace_session_directory` to save all your session files in a single directory outside of your workspace. Example:
```
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
```
Note: this will use the workspace directory as the session file name, overriding `g:workspace_sesssion_name`.

If you'd like sessions to not load if you're explicitly loading a file in a workspace directory (as opposed to an argument-less `vim`), the following in your vimrc will provide that behaviour:
```
let g:workspace_session_disable_on_args = 1
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
Preview windows will close on InsertLeave, to mitigate the default behaviour of being an orphaned window.

## Autosave
Files edited in a workspace session will autosave on InsertLeave, idle (CursorHold), pane switches (FocusLost and FocusGained), or buffer switches (BufLeave).

FocusLost and FocusGained triggers will typically trigger only with GUI versions of Vim. However, there are plugins that enables these for the console version within Tmux (i.e. sjl/vitality.vim).

This autosave feature enforces a last writer wins policy (eventual consistency).

You can manually enable the autosave feature outside of a workspace session with the `ToggleAutosave` command.

If you would like autosave to be always on, even outside of a session, add the following to your vimrc:
```
let g:workspace_autosave_always = 1
```

If you would like to disable autosave for some reason (i.e. too much IO on disk), it can be disabled as shown here:
```
let g:workspace_autosave = 0
```

#### Untrailing Spaces & Untrailing Tabs
By default, all trailing spaces and tabs are trimmed before a buffer is autosaved. If you don't prefer this behaviour, add this line:
```
let g:workspace_autosave_untrailspaces = 0
let g:workspace_autosave_untrailtabs = 0
```

#### Ignore List
Git commit filetypes won't autosave (or trim trailing spaces) by default. You can customize the ignore list with this line:
```
let g:workspace_autosave_ignore = ['gitcommit']
```

## Indent Guides
This feature has been moved to its own plugin [vim-indentguides](https://github.com/thaerkh/vim-indentguides).

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
