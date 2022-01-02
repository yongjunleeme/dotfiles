let g:python3_host_prog = ‘/path/to/python3’

" 로컬 리더 키 설정은 취향이니 각자 마음에 드는 키로 설정한다
let maplocalleader = "\\"

" 1번 위키(공개용)와 2번 위키(개인용)
let g:vimwiki_list = [
   \ {
   \    'path': '~/git/yongjunleeme.github.io/_wiki',
   \    'ext' : '.md',
   \    'diary_rel_path': '.',
   \ },
   \ {
   \    'path': '~/Dropbox/wiki',
   \    'ext' : '.md',
   \    'diary_rel_path': '.',
   \ },
\]

" 자주 사용하는 vimwiki 명령어에 단축키를 취향대로 매핑해둔다
command! WikiIndex :VimwikiIndex
nmap <LocalLeader>ww <Plug>VimwikiIndex
nmap <LocalLeader>wi <Plug>VimwikiDiaryIndex
nmap <LocalLeader>w<LocalLeader>w <Plug>VimwikiMakeDiaryNote
nmap <LocalLeader>wtt :VimwikiTable<CR>

" F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다.
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>

" Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>

" 메타데이터 updated 항목 자동 업데이트
function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre *.md call LastModified()

" 새로운 문서 파일 만들었을 때 기본 형식이 입력되도록 한다
function! NewTemplate()
    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tags    : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction
autocmd BufRead,BufNewFile *.md call NewTemplate()

augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
augroup END

" vimwiki 설정
let wiki = {}                                                                                                                       
let wiki.path = '~/Documents/yongjunleeme.github.io/_wiki/'
let wiki.ext = '.md'

let g:vimwiki_list = [wiki]
let g:vimwiki_conceallevel = 0

function! LastModified()
    if &modified
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
              \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun
autocmd BufWritePre *.md call LastModified()

" youcompletMe에서 vimwiki 무시 제거
let g:ycm_filetype_blacklist = {}

" 검색설정
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>

" 종립님 설정 복사
set smartcase	" 대문자가 검색어 문자열에 포함될 때에는 noignorecase
set ignorecase 	" 검색시 대소문자 무시
set hlsearch	" 검색시 하이라이트(색상 강조)
set incsearch	" 검색 키워드 입력시 한 글자 입력할 때마다 점진 검색

set nu 		" 라인 넘버 출력
set ruler	" 현재 커서 위치 (row, col) 좌표 출력
set noerrorbells	" 에러 알림음 끄기

set bs=indent,eol,start	" backspace 키 사용 가능
set background=dark  " 검정배경을 사용할 때, (이 색상에 맞춰 문법 하이라이트 색상이 달라짐.)

set wmnu	" tab 자동완성시 가능한 목록을 보여줌
set shiftwidth=4	" shift를 4칸으로 ( >, >>, <, << 등의 명령어)
set tabstop=4		" tab을 4칸으로

set noimd		" no imdisable 한글 입력기 관련

set autoindent	" 자동 들여쓰기
set smartindent " 자동 들여쓰기 "
set cindent		" C언어 자동 들여쓰기
set laststatus=2	" 상태바를 언제나 표시할 것
set showmatch " 일치하는 괄호 하이라이팅
set sm	" 매치되는 괄호 표시
set history=1000 "  vi 편집기록 기억갯수 .viminfo에 기록

set ai  " autoindent 자동 들여쓰기 

" 사운드 벨, 비주얼 벨 비활성화
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

:set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

"F11, w 로 set list 를 toggle 한다.
nnoremap <F11>w :set list!<ENTER>

" 마지막으로 수정된 곳에 커서를 위치함
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm g`\"" |
\ endif

"syntax on
if has("syntax")
 syntax on
endif

" ESC 대용
imap jk <Esc>
imap kj <Esc>

" 명령행 한글 입력 오류 처리
ca ㅈ w

" ctrl-j 로 라인을 분리.
nnoremap <NL> i<CR><ESC>

" copy , paste , select 기능 보완 -------------------------------
noremap <Space>y	"+y
nnoremap <Space>p	"+p
nnoremap <Space>a	gg<S-v>G

" navigation 기능 보완 ---------------------------------
nnoremap <Space>h ^
nnoremap <Space>l $
noremap <Space>j 8j
noremap <Space>k 8k

set encoding=utf-8
set guifont=ubuntu\ mono:h14:cANSI
set guifontwide=GulimChe:h13:cDEFAULT

" 메뉴 표시 언어 : 영어
lang mes en_US

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" for coding on c language
imap ,fi for(i = 0; i < ; ++i){<ENTER>}
imap ,fj for(j = 0; j < ; ++j){<ENTER>}
imap ,if if(){<ENTER>}<ESC>kf(a
imap ,wh while(){<ENTER>}<ESC>kf(a
imap ,/ /* */<ESC>2F*a<SPACE>

"Ultisnips 오류 방지
let g:UltiSnipsSnippetDirectories = []

" 커서가 있는 줄을 강조함
set cursorline

" 상태바 표시를 항상한다
set laststatus=2 
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

" 구름 입력
set noimd

"insert모드에서만 한글지원하도록
if has('mac') && filereadable('/usr/local/lib/libInputSourceSwitcher.dylib')
  autocmd InsertLeave * call libcall('/usr/local/lib/libInputSourceSwitcher.dylib', 'Xkb_Switch_setXkbLayout', 'com.apple.keylayout.US')
endif

if has("syntax")
 syntax on
endif


" 손에 잡히는 vim

set ts=4 sw=4
colo darkblue

set fencs=ucs-borm,utf-8,korea


