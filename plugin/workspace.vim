" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-workspace

let g:workspace_session_name = get(g:, 'workspace_session_name', '.session.vim')
let g:workspace_undodir = get(g:, 'workspace_undodir', '.undodir')
let g:workspace_persist_undo_history = get(g:, 'workspace_persist_undo_history', 1)
let g:workspace_autosave = get(g:, 'workspace_autosave', 1)
let g:workspace_autosave_updatetime = get(g:, 'workspace_autosave_updatetime', 1000)
let g:workspace_autosave_untrailspaces = get(g:, 'workspace_autosave_untrailspaces', 1)


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
      if input('Workspace buffer conflict detected. Load pre-existing workspace? (y/n) ') == 'y'
        bufdo bd
        execute 'source ' . g:workspace_session_name
      else
        if input('Override pre-existing workspace with this one? (y/n) ') == 'n'
          let s:workspace_save_session = 0
        endif
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
  if g:workspace_autosave_untrailspaces
    let curr_row = line('.')
    let curr_col = virtcol('.')
    :%s/\s\+$//e
    cal cursor(curr_row, curr_col)
  endif
endfunction

function! s:SetAutosave()
  if g:workspace_autosave
    execute 'set updatetime=' . resolve(g:workspace_autosave_updatetime)
    if &modifiable
      au! BufLeave,CursorHold,FocusLost,InsertLeave,TabLeave,WinLeave * call s:UntrailSpaces() | silent! write
    endif
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

augroup Workspace
  au! VimEnter * call s:LoadWorkspace()
  au! VimLeave * call s:MakeWorkspace(0)
  au! SessionLoadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

command! ToggleWorkspace call s:ToggleWorkspace()

" vim: ts=2 sw=2 et
