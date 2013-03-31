" Changes the splash of Vim as you like.
" Version: 1.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

if exists('g:loaded_splash')
  finish
endif
let g:loaded_splash = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -complete=file Splash call splash#command(<q-args>)

augroup plugin-splash
  autocmd!
  autocmd VimEnter * nested call splash#intro()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
