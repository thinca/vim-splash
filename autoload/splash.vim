" Changes the splash of Vim as you like.
" Version: 1.1
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

let s:save_cpo = &cpo
set cpo&vim

function! splash#intro()
  if argc() == 0 && bufnr('$') == 1 && filereadable(g:splash#path)
    call splash#show(g:splash#path)
  endif
endfunction

function! splash#command(file)
  let file = empty(a:file) ? g:splash#path : a:file
  try
    call splash#show(file)
  catch /^splash:/
    echohl ErrorMsg
    echomsg v:exception
    echohl None
  endtry
endfunction

function! splash#show(file)
  if type(a:file) == type('')
    if !filereadable(a:file)
      throw 'splash: Can not read file: ' . a:file
    endif
    let content = map(readfile(a:file), 'iconv(v:val, "utf-8", &encoding)')
  elseif type(a:file) == type([])
    let content = a:file
  else
    throw 'splash: Invalid argument: ' . string(a:file)
  endif
  call s:clear_cmdline()
  let restore_command = s:open_new_buffer()
  call s:draw(content)
  redraw
  let char = s:getchar()
  silent execute restore_command
  call feedkeys(char)
endfunction

function! s:clear_cmdline()
  echon ''
endfunction

function! s:open_new_buffer()
  let foldenable = &l:foldenable
  let bufnr = bufnr('%')
  hide enew
  setlocal buftype=nofile nowrap nolist nonumber bufhidden=wipe
  setlocal nofoldenable
  let restore_command = bufnr == bufnr('%') ? 'enew' : bufnr . ' buffer'
  let restore_command .= ' | let &l:foldenable = ' . foldenable
  return restore_command
endfunction

function! s:getchar()
  let char = getchar()
  return type(char) == type(0) ? nr2char(char) : char
endfunction

function! s:draw(content)
  let screen_width = winwidth(0)
  let screen_height = winheight(0)
  let content_height = len(a:content)
  let padding_lines = repeat([''], screen_height - content_height - 1)
  silent put =padding_lines
  call cursor((screen_height - content_height) / 2, 1)
  silent put =s:block_centerize(a:content, screen_width)
  1
endfunction

function! s:height_middlize(max_height, body_height)
  return (a:max_height - a:body_height) / 2
endfunction

function! s:block_centerize(lines, width)
  let left = s:centerize_padding(a:width, s:block_width(a:lines))
  return map(a:lines, 'left . v:val')
endfunction

function! s:centerize_padding(max_width, body_width)
  return repeat(' ', (a:max_width - a:body_width) / 2)
endfunction

function! s:block_width(lines)
  return max(map(copy(a:lines), 'strwidth(v:val)'))
endfunction


if !exists('g:splash#path')
  let g:splash#path = expand('<sfile>:h:h') . '/sample/vimgirl.txt'
endif

let &cpo = s:save_cpo
unlet s:save_cpo
