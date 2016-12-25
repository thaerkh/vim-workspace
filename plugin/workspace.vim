" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-workspace

let g:workspace_session_name = get(g:, 'workspace_session_name', '.session.vim')

function! s:MakeWorkspace(workspace_save_session)
  if a:workspace_save_session == 1 || get(g:, 'workspace_save_session', 1) == 1
    execute 'mksession! ' . g:workspace_session_name
  endif
endfunction

function! s:LoadWorkspace()
  if !empty(glob(g:workspace_session_name))
    if @% == ''
      execute 'source ' . g:workspace_session_name
    else
      if input('Workspace buffer conflict detected. Load pre-existing workspace? (y/n) ') == 'y'
        bufdo bd
        execute 'source ' . g:workspace_session_name
      else
        if input('Override pre-existing workspace with this one? (y/n) ') == 'n'
          let g:workspace_save_session = 0
        endif
      endif
    endif
  else
    let g:workspace_save_session = 0
  endif
endfunction

function! s:RemoveWorkspace()
    let g:workspace_save_session  = 0
    execute "call delete(expand(\x27" . g:workspace_session_name . "\x27))"
endfunction

function! s:ToggleWorkspace()
  if !empty(glob(g:workspace_session_name))
    call s:RemoveWorkspace()
  else
    call s:MakeWorkspace(1)
  endif
endfunction

augroup Workspace
  au! VimEnter * call s:LoadWorkspace()
  au! VimLeave * call s:MakeWorkspace(0)
augroup END

command! ToggleWorkspace call s:ToggleWorkspace()

" vim: ts=2 sw=2 et
