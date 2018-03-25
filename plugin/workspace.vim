" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-workspace

let g:workspace_session_name = get(g:, 'workspace_session_name', 'Session.vim')
let g:workspace_session_disable_on_args = get(g:, 'workspace_session_disable_on_args', 0)
let g:workspace_undodir = get(g:, 'workspace_undodir', '.undodir')
let g:workspace_persist_undo_history = get(g:, 'workspace_persist_undo_history', 1)
let g:workspace_autosave = get(g:, 'workspace_autosave', 1)
let g:workspace_autosave_always = get(g:, 'workspace_autosave_always', 0)
let g:workspace_autosave_ignore = get(g:, 'workspace_autosave_ignore', ['gitcommit', 'gitrebase', 'nerdtree'])
let g:workspace_autosave_untrailspaces = get(g:, 'workspace_autosave_untrailspaces', 1)
let g:workspace_autosave_au_updatetime = get(g:, 'workspace_autosave_au_updatetime', 3)
let g:workspace_autocreate = get(g:, 'workspace_autocreate', 0)
let g:workspace_nocompatible = get(g:, 'workspace_nocompatible', 1)

function! s:WorkspaceExists()
  return filereadable(g:workspace_session_name)
endfunction

function! s:IsAbsolutePath(path)
  return (fnamemodify(a:path, ':p') == a:path)
endfunction

function! s:MakeWorkspace(workspace_save_session)
  if a:workspace_save_session == 1 || get(s:, 'workspace_save_session', 0) == 1
    let s:workspace_save_session = 1
    if s:IsAbsolutePath(g:workspace_session_name)
      execute printf('mksession! %s', g:workspace_session_name)
    else
      execute printf('mksession! %s/%s', getcwd(), g:workspace_session_name)
    endif
  endif
endfunction

function! s:FindOrNew(filename)
  let a:bufnr = bufnr(a:filename)
  for tabnr in range(1, tabpagenr("$"))
    for bufnr in tabpagebuflist(tabnr)
      if (bufnr == a:bufnr)
        execute 'tabn ' . tabnr
        call win_gotoid(win_findbuf(a:bufnr)[0])
        return
      endif
    endfor
  endfor
  tabnew
  execute 'buffer ' . a:bufnr
endfunction

function! s:CloseHiddenBuffers()
  let a:visible_buffers = {}
  for tabnr in range(1, tabpagenr('$'))
    for bufnr in tabpagebuflist(tabnr)
      let a:visible_buffers[bufnr] = 1
    endfor
  endfor

  for bufnr in range(1, bufnr('$'))
    if bufexists(bufnr) && !has_key(a:visible_buffers,bufnr)
      execute printf('bwipeout %d', bufnr)
    endif
  endfor
endfunction

function! s:ConfigureWorkspace()
  call s:SetUndoDir()
  call s:SetAutosave(1)
endfunction

function! s:RemoveWorkspace()
  let s:workspace_save_session  = 0
  execute printf('call delete("%s")', g:workspace_session_name)
  if !g:workspace_autosave_always
    call s:SetAutosave(0)
  endif
endfunction

function! s:ToggleWorkspace()
  if s:WorkspaceExists()
    call s:RemoveWorkspace()
    execute printf('silent !rm -rf %s', g:workspace_undodir)
    call feedkeys("") | silent! redraw!  " Recover view from external comand
    echo 'Workspace removed!'
  else
    call s:MakeWorkspace(1)
    call s:ConfigureWorkspace()
    echo 'Workspace created!'
  endif
endfunction

function! s:LoadWorkspace()
  if index(g:workspace_autosave_ignore, &filetype) != -1 || get(s:, 'read_from_stdin', 0) || (g:workspace_session_disable_on_args && argc() != 0)
    return
  endif

  if s:WorkspaceExists()
    let s:workspace_save_session = 1
    let a:filename = expand(@%)
    if g:workspace_nocompatible | set nocompatible | endif
    execute 'source ' . g:workspace_session_name
    call s:ConfigureWorkspace()
    call s:FindOrNew(a:filename)
  else
    if g:workspace_autocreate
      call s:ToggleWorkspace()
    else
      let s:workspace_save_session = 0
    endif
  endif
  set sessionoptions-=options
endfunction

function! s:UntrailSpaces()
  if g:workspace_autosave_untrailspaces && &modifiable
    let curr_row = line('.')
    let curr_col = virtcol('.')
    execute 's/\ \+$//e'
    cal cursor(curr_row, curr_col)
  endif
endfunction

function! s:Autosave(timed)
  if index(g:workspace_autosave_ignore, &filetype) != -1 || &readonly || mode() == 'c' || pumvisible()
    return
  endif

  let current_time = localtime()
  let s:last_update = get(s:, 'last_update', 0)
  let s:time_delta = current_time - s:last_update

  if a:timed == 0 || s:time_delta >= 1
    let s:last_update = current_time
    checktime  " checktime with autoread will sync files on a last-writer-wins basis.
    call s:UntrailSpaces()
    silent! doautocmd BufWritePre %  " needed for soft checks
    silent! update  " only updates if there are changes to the file.
    if a:timed == 0 || s:time_delta >= g:workspace_autosave_au_updatetime
      silent! doautocmd BufWritePost %  " Periodically trigger BufWritePost.
    endif
  endif
endfunction

function! s:SetAutosave(enable)
  if !g:workspace_autosave
    return
  endif
  if a:enable == 1
    let s:autoread = &autoread
    let s:autowriteall = &autowriteall
    let s:swapfile  = &swapfile
    let s:updatetime = &updatetime
    set autoread
    set autowriteall
    set noswapfile
    set updatetime=1000
    if !has('nvim')
      let s:swapsync = &swapsync
      set swapsync=""
    endif
    augroup WorkspaceToggle
      au! BufLeave,FocusLost,FocusGained,InsertLeave * call s:Autosave(0)
      au! CursorHold * call s:Autosave(1)
      au! BufEnter * call s:MakeWorkspace(0)
    augroup END
    let s:autosave_on = 1
  else
    let &autoread = s:autoread
    let &autowriteall = s:autowriteall
    let &updatetime = s:updatetime
    let &swapfile = s:swapfile
    if !has('nvim')
      let &swapsync = s:swapsync
    endif
    au! WorkspaceToggle * *
    let s:autosave_on = 0
  endif
endfunction

function! s:ToggleAutosave()
  if get(s:, 'autosave_on', 0)
    call s:SetAutosave(0)
    echo 'Autosave disabled!'
  else
    call s:SetAutosave(1)
    echo 'Autosave enabled!'
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
endfunction

augroup Workspace
  au! VimEnter * nested call s:LoadWorkspace()
  au! StdinReadPost * let s:read_from_stdin = 1
  au! VimLeave * call s:MakeWorkspace(0)
  au! InsertLeave * if pumvisible() == 0|pclose|endif
  au! SessionLoadPost * call s:PostLoadCleanup()
augroup END

augroup WorkspaceAutosave
  au! VimEnter * if g:workspace_autosave_always == 1 | call s:SetAutosave(1) | endif
augroup END

command! ToggleAutosave call s:ToggleAutosave()
command! ToggleWorkspace call s:ToggleWorkspace()
command! CloseHiddenBuffers call s:CloseHiddenBuffers()

" vim: ts=2 sw=2 et
