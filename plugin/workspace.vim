" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-workspace

let g:workspace_session_name = get(g:, 'workspace_session_name', 'Session.vim')
let g:workspace_undodir = get(g:, 'workspace_undodir', '.undodir')
let g:workspace_persist_undo_history = get(g:, 'workspace_persist_undo_history', 1)
let g:workspace_autosave = get(g:, 'workspace_autosave', 1)
let g:workspace_autosave_updatetime = get(g:, 'workspace_autosave_updatetime', 1000)
let g:workspace_autosave_untrailspaces = get(g:, 'workspace_autosave_untrailspaces', 1)
let g:workspace_sensible_settings = get(g:, 'workspace_sensible_settings', 0)  " off by default


function! s:SetSensibleSettings()
  if g:workspace_sensible_settings
    " Environment behaviour
    filetype plugin indent on
    syntax on
    set nocompatible
    set clipboard=unnamedplus
    set encoding=utf-8
    set hidden
    set path+=**
    set wildmenu
    set wildmode=list:longest,full

    " Editor view
    set cursorline
    set foldmethod=indent
    set nofoldenable
    set incsearch
    set laststatus=2
    set linebreak
    set number
    set ruler

    " Editing behaviour
    set autoindent
    set backspace=indent,eol,start
    set smarttab
  endif
endfunction

function! s:WorkspaceExists()
  return filereadable(g:workspace_session_name)
endfunction

function! s:MakeWorkspace(workspace_save_session)
  if a:workspace_save_session == 1 || get(s:, 'workspace_save_session', 1) == 1
    let s:workspace_save_session = 1
    execute 'mksession! ' . g:workspace_session_name
  endif
endfunction

function! s:LoadWorkspace()
  if s:WorkspaceExists()
    call s:ConfigureWorkspace()
    if @% == ''
      execute 'source ' . g:workspace_session_name
    else
      if input('A workspace exists! Would you like to load it? (y/n) ') != 'n'
        bufdo bd
        execute 'source ' . g:workspace_session_name
      else
        let s:workspace_save_session = 0
      endif
    endif
  else
    let s:workspace_save_session = 0
  endif
endfunction

function! s:ConfigureWorkspace()
  call s:SetUndoDir()
  call s:SetAutosave()
endfunction

function! s:RemoveWorkspace()
  let s:workspace_save_session  = 0
  execute "call delete(expand(\x27" . g:workspace_session_name . "\x27))"
endfunction

function! s:ToggleWorkspace()
  if s:WorkspaceExists()
    call s:RemoveWorkspace()
    execute 'silent !rm -rf ' . g:workspace_undodir
    redraw!
    echo 'Workspace removed!'
  else
    call s:MakeWorkspace(1)
    call s:ConfigureWorkspace()
    echo 'Workspace created!'
  endif
endfunction

function! s:UntrailSpaces()
  if g:workspace_autosave_untrailspaces && &modifiable
    let curr_row = line('.')
    let curr_col = virtcol('.')
    :%s/\s\+$//e
    cal cursor(curr_row, curr_col)
  endif
endfunction

function! s:SetAutosave()
  if g:workspace_autosave
    execute 'set updatetime=' . resolve(g:workspace_autosave_updatetime)
    augroup Workspace
      au! BufLeave,CursorHold,FocusLost,InsertLeave,TabLeave,WinLeave * call s:UntrailSpaces() | silent! write
    augroup END
  endif
endfunction

function! s:SetUndoDir()
  if g:workspace_persist_undo_history
    if !isdirectory(g:workspace_undodir)
      call mkdir(g:workspace_undodir)
    endif
    execute 'set undodir=' . resolve(g:workspace_undodir)
    set undofile
  endif
endfunction

function! s:PostLoadCleanup()
  if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  if exists(':AirlineRefresh')
    AirlineRefresh
  endif
endfunction

augroup Workspace
  au! VimEnter * call s:LoadWorkspace()
  au! VimLeave * call s:MakeWorkspace(0)
  au! SessionLoadPost * call s:PostLoadCleanup()
augroup END

command! ToggleWorkspace call s:ToggleWorkspace()

call s:SetSensibleSettings()

" vim: ts=2 sw=2 et
