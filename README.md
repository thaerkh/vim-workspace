vim-workspace
=========
A simple workspace management plugin that tracks files in your session, their undo history, autosaves, and keeps your code clean of leading spaces.

![img](https://raw.githubusercontent.com/thaerkh/vim-workspace/master/wiki/screenshots/demo.gif)

## Installation
This plugin follows the standard runtime path structure, and can be installed with a variety of plugin managers.
### Using Plug
Paste the following in your `~/.vimrc` file, and things will automatically install upon a vim restart or re-source:
```
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall
endif

call plug# begin('~/.vim/plugged')
Plug 'thaerkh/vim-workspace'
call plug# end()
```

### Sensible Settings
While not enabled by default, this plugin comes available with common vim settings that most/all people can agree on.

If you would like to enable these settings (viewable in `plugin/workspace.vim`), add the following to your vimrc:
```
let g:workspace_sensible_settings = 1
```
## Features
### Persistent Workspace
The following is an example binding for the `ToggleWorkspace` command that will make/remove your workspace sessions:
```
nnoremap <leader>m :ToggleWorkspace<CR>
```
 Once toggled on, your workspace will be seamlessly tracked every time you open vim in your workspace directory, and all vim-workspace features will be enabled. Conversely, toggling the command off will remove all workspace session history and disable the listed plugin features.

If you open Vim with file arguments and a workspace session already exists, the plugin will prompt you for whether you want to overwrite with the new session or load the pre-existing one.

You can use the following setting if you wish change the default session name:
```
let g:workspace_session_name = '.session.vim'
```
### Persistent Undo History

When in a workspace, file undo history is persisted between sessions, without needing to keep Vim on.

The following settings can be used if you wish to configure the feature:
```
let g:workspace_persist_undo_history = 1
let g:workspace_undodir='.undodir'
```
### Persistent Cursor positions
Any files in a workspace session will persist their cursor positions across reloads.
### File Autosave
Being in a workspace enables the file autosave feature, which will autosave when leaving insert mode, when idle (as per updatetime), or when switching buffers/tabs.

You can use these settings if you wish to change the default behaviour:
```
let g:workspace_autosave = 1
let g:workspace_autosave_updatetime = 1000
```
### Untrailing Spaces
By default, all trailing spaces are trimmed before a buffer is autosaved. This behaviour can be configured on/off with the following setting:
```
let g:workspace_autosave_untrailspaces = 1
```

## License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
