" Vim plugin
" Author:  Thaer Khawaja
" License: Apache 2.0
" URL:     https://github.com/thaerkh/vim-workspace

let g:workspace_session_name = get(g:, 'workspace_session_name', 'Session.vim')
let g:workspace_undodir = get(g:, 'workspace_undodir', '.undodir')
let g:workspace_persist_undo_history = get(g:, 'workspace_persist_undo_history', 1)
let g:workspace_autosave = get(g:, 'workspace_autosave', 1)
let g:workspace_autosave_ignore = get(g:, 'workspace_autosave_ignore', ['gitcommit', 'gitrebase'])
let g:workspace_autosave_untrailspaces = get(g:, 'workspace_autosave_untrailspaces', 1)
let g:workspace_autosave_au_updatetime = get(g:, 'workspace_autosave_au_updatetime', 4)
let g:workspace_sensible_settings = get(g:, 'workspace_sensible_settings', 0)
let g:workspace_autocreate = get(g:, 'workspace_autocreate', 0)
let g:workspace_indentguides = get(g:, 'workspace_indentguides', 0)
let g:workspace_indentguides_ignore  = get(g:, 'workspace_indentguides_ignore', [])


function! s:SetSensibleSettings()
  " Needed for plugin features
  set completeopt=menuone,longest,preview
  set encoding=utf-8
  set omnifunc=syntaxcomplete#Complete
  set sessionoptions-=options

  if g:workspace_sensible_settings
    " Environment behaviour
    filetype plugin indent on
    syntax on
    set nocompatible
    set clipboard=unnamedplus
    set complete-=i
    set path+=**
    set updatetime=1000
    set wildmenu
    set wildmode=list:longest,full

    if !has('nvim')
      set swapsync=""
    endif

    " Editor view
    set foldmethod=indent
    set nofoldenable
    set incsearch
    set laststatus=2
    set linebreak
    set list
    set listchars=extends:>,precedes:<
    set number
    set ruler

    " Editing behaviour
    set autoindent
    set backspace=indent,eol,start
    set smarttab

    nnoremap Q <Nop>
  endif
endfunction

function! s:WorkspaceExists()
  return filereadable(g:workspace_session_name)
endfunction

function! s:MakeWorkspace(workspace_save_session)
  if a:workspace_save_session == 1 || get(s:, 'workspace_save_session', 0) == 1
    let s:workspace_save_session = 1
    execute printf('mksession! %s/%s', getcwd(), g:workspace_session_name)
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
      execute printf('bdelete %d', bufnr)
    endif
  endfor
endfunction

function! s:ConfigureWorkspace()
  call s:SetUndoDir()
  call s:SetAutosave()
endfunction

function! s:RemoveWorkspace()
  let s:workspace_save_session  = 0
  execute printf('call delete("%s")', g:workspace_session_name)
  if g:workspace_autosave
    set noautoread
    set noautowrite
    au! WorkspaceToggle * *
  endif
endfunction

function! s:ToggleWorkspace()
  if s:WorkspaceExists()
    call s:RemoveWorkspace()
    execute printf('silent !rm -rf %s', g:workspace_undodir)
    call feedkeys("") | silent! redraw!
    echo 'Workspace removed!'
  else
    call s:MakeWorkspace(1)
    call s:ConfigureWorkspace()
    echo 'Workspace created!'
  endif
endfunction

function! s:LoadWorkspace()
  if index(g:workspace_autosave_ignore, &filetype) != -1
    return
  endif

  if s:WorkspaceExists()
    let s:workspace_save_session = 1
    let a:filename = expand(@%)
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
endfunction

function! s:UntrailSpaces()
  if g:workspace_autosave_untrailspaces && &modifiable
    let curr_row = line('.')
    let curr_col = virtcol('.')
    :%s/\ \+$//e
    cal cursor(curr_row, curr_col)
  endif
endfunction

function! s:Autosave(timed)
  if index(g:workspace_autosave_ignore, &filetype) != -1 || &readonly || mode() == 'c'
    return
  endif

  let current_time = localtime()
  let s:last_update = get(s:, 'last_update', 0)
  let s:time_delta = current_time - s:last_update
  if a:timed == 0 || s:time_delta >= 1
    let s:last_update = current_time
    checktime
    call s:UntrailSpaces()
    silent! update
    if a:timed == 0 || s:time_delta >= g:workspace_autosave_au_updatetime
      doautocmd BufWritePost %
    endif
  endif
endfunction

function! s:SetAutosave()
  if g:workspace_autosave
    set autoread
    set autowrite
    augroup WorkspaceToggle
      au! BufLeave,FocusLost,FocusGained,InsertLeave * call s:Autosave(0)
      au! CursorHold * call s:Autosave(1)
      au! BufEnter * call s:MakeWorkspace(0)
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

function! s:ToggleIndentGuides(user_initiated)
  if !g:workspace_indentguides && !a:user_initiated
    return
  end
  if index(g:workspace_indentguides_ignore, &filetype) != -1 && !a:user_initiated
    return
  endif

  if get(b:, 'toggle_indentguides', 1)
    execute "highlight Conceal ctermfg=238 ctermbg=NONE guifg=Grey27 guibg=NONE"
    execute "highlight SpecialKey ctermfg=238 ctermbg=NONE guifg=Grey27 guibg=NONE"
    execute 'syntax match IndentGuideSpaces /^\ \+/ containedin=ALL contains=IndentGuideDraw keepend'
    execute printf('syntax match IndentGuideDraw /\(^\|\ \)\{%i}\zs / contained conceal cchar=┆', &l:shiftwidth - 1)

    " TODO-TK: local and global listchars are the same, and s: variables are failing (??)
    let g:original_listchars = get(g:, 'original_listchars', &g:listchars)
    let &g:listchars = &g:listchars . ',tab:| ,trail:·'

    setlocal concealcursor=inc
    setlocal conceallevel=2
    setlocal list

    let b:toggle_indentguides = 0
  else
    syntax clear IndentGuideSpaces
    syntax clear IndentGuideDraw

    let &l:conceallevel = &g:conceallevel
    let &l:concealcursor = &g:concealcursor
    let &g:listchars = g:original_listchars
    setlocal nolist
    let b:toggle_indentguides = 1
  endif
endfunction

function! s:PostLoadCleanup()
  if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endfunction

augroup Workspace
  au! BufWinEnter * call s:ToggleIndentGuides(0)
  au! VimEnter * nested call s:LoadWorkspace()
  au! VimLeave * call s:MakeWorkspace(0)
  au! InsertLeave * if pumvisible() == 0|pclose|endif
  au! SessionLoadPost * call s:PostLoadCleanup()
augroup END

command! ToggleIndentGuides call s:ToggleIndentGuides(1)
command! ToggleWorkspace call s:ToggleWorkspace()
command! WorkspaceExists call s:WorkspaceExists()
command! CloseHiddenBuffers call s:CloseHiddenBuffers()

call s:SetSensibleSettings()

" vim: ts=2 sw=2 et
