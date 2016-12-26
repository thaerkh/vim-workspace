vim-workspace
=========
A minimalist vim session wrapper that will auto update any workspace sessions tied to a working project directory.

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
Once you fire up vim, it will auto-download Plug for you and install the vim-workspace plugin ready for use.
## Usage
The following command is exposed:

`ToggleWorkspace` - This will toggle tracking your workspace, and running it again will delete your workspace.

Once you make the session, the plugin will automatically update it for you until you toggle it off.

Example binding:

`nnoremap <leader>m :ToggleWorkspace<CR>`

You can customize what the session name will be, using the following plugin default as an example:

`let g:workspace_session_name = '.session.vim'`

If you open vim standalone, it will automatically load the previous session if it exists.

If you open vim with file arguments and a workspace session already exists, the plugin will prompt you for whether you want to overwrite with the new session or load the pre-existing one.
## License
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
