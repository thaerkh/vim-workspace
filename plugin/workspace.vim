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
      if input('Override pre-existing workspace with this one? (y/n) ') == 'n'
        if input('Load pre-existing workspace? (y/n) ') == 'y'
          bufdo bd
          execute 'source ' . g:workspace_session_name
        else
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

augroup Workspace
  au! VimEnter * call s:LoadWorkspace()
  au! VimLeave * call s:MakeWorkspace(0)
augroup END

command! MakeWorkspace call s:MakeWorkspace(1)
command! SaveWorkspace call s:MakeWorkspace(1)
command! LoadWorkspace call s:LoadWorkspace()
command! RemoveWorkspace call s:RemoveWorkspace()

" vim: ts=2 sw=2 et
