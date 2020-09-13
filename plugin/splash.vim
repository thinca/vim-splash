" Changes the splash of Vim as you like.
" Version: 1.1
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

if exists('g:loaded_splash')
  finish
endif
let g:loaded_splash = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -complete=file Splash call splash#command(<q-args>)

" if &shortmess doesn't contain 'I', vim will splash
if get(g:, 'splash#enable', stridx(&shortmess, 'I') == -1)
  augroup plugin-splash
    autocmd!
    autocmd VimEnter * nested call splash#intro()
    autocmd StdinReadPre * autocmd! plugin-splash VimEnter
  augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo
