let s:sources = split(glob(expand('<sfile>:h:h:h') . '/sample/**/*.txt'))

function! leaderf#splash#source(args) abort "{{{
	for l:dir in get(g:, 'splash#dirs', [])
		let s:sources += split(glob(l:dir . '/**'))
	endfor
	return s:sources
endfunction "}}}

function! leaderf#splash#accept(line, args) abort "{{{
	execute 'Splash ' . a:line
endfunction "}}}
