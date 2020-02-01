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

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') . '/' == wiki.path
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

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



set nopaste
" init.vim : .nvimrc
" location of init.vim : ~/.config/nvim/

" for deoplete plugin
    function! DoRemote(arg)
        UpdateRemotePlugins
    endfunction

" Vim-Plug 설정 ------------------------------------------------------------------
" 아래와 같이 설정한 다음 :PlugInstall<CR> 해주면 된다.
call plug#begin('~/.vim/plugged')

    " VIM POWER
    Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    Plug 'tpope/vim-repeat'

    " tags
    Plug 'vim-scripts/taglist.vim'
    Plug 'ludovicchabant/vim-gutentags' " 자동으로 tags 파일을 갱신해 준다.
    Plug 'majutsushi/tagbar'
    Plug 'jszakmeister/markdown2ctags', {'do' : 'cp ./markdown2ctags.py ~/.local/bin/markdown2ctags.py'}

    " version control
    Plug 'tpope/vim-fugitive'           " git 명령어 wrapper
    Plug 'simnalamburt/vim-mundo'

    " file browser
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
        " Plug 'jistr/vim-nerdtree-tabs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'

    " editing
    Plug 'tpope/vim-surround'
    Plug 'bling/vim-airline'           " BUFFER navigator, status line 을 제공한다.
    Plug 'easymotion/vim-easymotion'
    Plug 'tpope/vim-commentary'
    Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-entire'
        Plug 'kana/vim-textobj-indent'
        Plug 'thinca/vim-textobj-between'
    Plug 'wellle/targets.vim'           " text object utils
    Plug 'jiangmiao/auto-pairs'
    Plug 'godlygeek/tabular'           " 텍스트 세로 정렬 도구
    " Plug 'junegunn/vim-easy-align'
    Plug 'AndrewRadev/splitjoin.vim'

    " searching
    Plug 'vim-scripts/matchit.zip'
    Plug 'google/vim-searchindex'
    " Plug 'othree/eregex.vim'
    " Plug 'haya14busa/incsearch.vim'

    " language support
    " Plug 'scrooloose/syntastic'        " 파일을 저장할 때 자동으로 문법 검사(ale과 중복되는 기능)
    Plug 'dense-analysis/ale', { 'do': 'brew install php-cs-fixer' }
    " https://github.com/dense-analysis/ale
    " Plug 'junegunn/vim-xmark', { 'do': 'make' }

    " Plug 'valloric/youcompleteme', { 'do': 'python3 ./install.py --clang-completer --go-completer --rust-completer --js-completer --tern-completer'}

    " Plug 'wesleyche/srcexpl'
    " Plug 'honza/vim-snippets'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " screen view
    Plug 'luochen1990/rainbow'          " 괄호를 level 별로 다르게 색칠한다. html 태그에도 적용.
    Plug 'kshenoy/vim-signature'        " m mark 위치를 표시해준다.
    Plug 'airblade/vim-gitgutter'       " git diff 를 라인 넘버 옆에 표시.
    " Plug 'ap/vim-css-color'             " #rrggbb 형식의 문자열에 색깔을 입혀준다.
    Plug 'mhinz/vim-startify'           " 시작 화면을 꾸며준다. MRU가 있어 편리하다.

    " Plug 'koron/nyancat-vim'
    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

    Plug 'diepm/vim-rest-console'
    Plug 'johngrib/vim-f-hangul'
    Plug 'johngrib/FlatColor-johngrib'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'tomasr/molokai'
    Plug 'johngrib/hosu'

    " Plug 'leafgarland/typescript-vim'
    Plug 'milkypostman/vim-togglelist'
    Plug 'jszakmeister/vim-togglecursor'
    Plug 'johngrib/vim-git-msg-wheel'

    " Plug 'tpope/vim-db'
    " Plug 'bartmalanczuk/vim-trex-runner'
    Plug 'johngrib/vim-game-code-break'
    Plug 'johngrib/vim-mac-dictionary'
    Plug 'tenfyzhong/axring.vim'
    Plug 'Chiel92/vim-autoformat'

    Plug 'ternjs/tern_for_vim'
    Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}

    " typescript syntax highlight
    " Plug 'HerringtonDarkholme/yats.vim'
    Plug 'eafgarland/typescript-vim'
    " Plug 'vim-scripts/vim-auto-save'

    Plug 'neoclide/coc.nvim', {
        \'branch': 'release',
        \'do': [
            \':CocInstall coc-rls'
            \,':CocInstall coc-tsserver'
            \,':CocInstall coc-phpls'
            \,':CocInstall coc-calc'
            \,':CocInstall coc-ultisnips'
        \]}

    Plug 'SirVer/ultisnips'
    " Plug 'neoclide/coc-sources', { 'do': ':CocInstall coc-ultisnips' }

    Plug 'rust-lang/rust.vim'
    " Plug 'neoclide/coc-rls', { 'do': ':CocInstall coc-rls' }
    " Plug 'neoclide/coc-tsserver', { 'do': ':CocInstall coc-tsserver' }
    " Plug 'marlonfan/coc-phpls', { 'do': ':CocInstall coc-phpls' }
    " Plug 'weirongxu/coc-calc', { 'do': ':CocInstall coc-calc' }

call plug#end()

function! InstallCocPlugins()
    CocInstall coc-rls
    CocInstall coc-tsserver
    CocInstall coc-calc
    CocInstall coc-phpls
endfunction

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

if (has("termguicolors"))
    " set termguicolors
endif

" Theme
syntax enable
colorscheme flatcolor-johngrib
filetype plugin indent on " Put your non-Plugin stuff after this line

" set ----------------------------------------------------------------------

    set path+=**
    set nofixeol
    set conceallevel=0
    " set regexpengine=1

    if executable('ag')
        set grepprg=ag\ --nogroup\ --nocolor\ --column
        set grepformat=%f:%l:%c%m

    elseif executable('ack')
        set grepprg=ack\ --nogroup\ --column\ $*
        set grepformat=%f:%l:%c:%m
    endif

    if has("nvim")
        " set termguicolors
    endif

    if has("gui_macvim")
        set macmeta
        set guifont=Meslo\ LG\ S\ DZ\ Regular\ Nerd\ Font\ Complete:h14

        " macVim 에서 esc 로 영문변환, imi 는 1 또는 2 로 설정해준다
        set noimd
        set imi=1
    else
        " tmux에서 배경색이 이상하게 나오는 문제를 해결한다.
        " link : http://stackoverflow.com/a/15095377
        set t_ut=
    endif

    set nocompatible                  " vi 기능을 사용하지 않고, vim 만의 기능을 사용.
    " set linebreak                     " break at word boundary
    " set showbreak=++
    set list listchars=tab:·\ ,trail:·,extends:>,precedes:<
    set omnifunc=syntaxcomplete#Complete
    set mouse=a

    set hidden  " Buffer should still exist if window is closed
    set nopaste

    set smartcase ignorecase hlsearch incsearch
    "set tildeop    "~ 를 다른 오퍼레이터와 함께 사용한다.

    " 화면 표시
    set nu               " 라인 넘버 출력
    " set relativenumber
    set ruler            " 현재 커서 위치 (row, col) 좌표 출력
    set noerrorbells     " 에러 알림음 끄기
    " set background=dark  " 검정배경을 사용 (이 색상에 맞춰 문법 하이라이트 색상이 달라짐.)
    set laststatus=2     " 상태바를 언제나 표시할 것
    set showmatch        " 일치하는 괄호 하이라이팅
    set cursorline       " highlight current line
    set lazyredraw       " redraw only when we need to.
    set showcmd          " airline 플러그인과 충돌 가능성 있음.
    "set nowrap
    " set sidescroll=2 sidescrolloff=10
    set wildmenu wildignorecase
    set wildmode=full

    " 짜증나는 swp, backup 파일 안 만들기
    set noswapfile
    set nobackup

    set noerrorbells visualbell t_vb= " 사운드 벨, 비주얼 벨 비활성화

    augroup setgroup
        autocmd!
        autocmd GUIEnter * set visualbell t_vb=
    augroup END

    "사용
    set bs=indent,eol,start  " backspace 키 사용 가능
    set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab
    "set noimd               " no imdisable 한글 입력기 관련인데 mac 에서는 안 통하는듯
    set cindent autoindent smartindent
    set history=200 undolevels=2000
    " set cursorcolumn
    set langmap=ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz
    set splitbelow
    set splitright
    set virtualedit=block   " visual block mode를 쓸 때 문자가 없는 곳도 선택 가능하다
    set autoread
    colo darkblue

    " This enables us to undo files even if you exit Vim.
    if has('persistent_undo')
        let s:vimDir = '$HOME/.vim'
        let &runtimepath.=','.s:vimDir
        let s:undoDir = expand(s:vimDir . '/undodir')

        call system('mkdir ' . s:vimDir)
        call system('mkdir ' . s:undoDir)

        let &undodir = s:undoDir
        set undofile
    endif


" initialize 설정 ---------------------------------------------------------------

" 마지막으로 수정된 곳에 커서를 위치함
    au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "norm g`\"" |
    \ endif

" map ----------------------------------------------------------------------
    let mapleader = "\<Space>"
    let maplocalleader = "\\"
    " nnoremap <Leader>e :browse oldfiles<CR>

    nnoremap <CR> :
    " nnoremap / /\v
    nnoremap k gk
    nnoremap gk k
    nnoremap j gj
    nnoremap gj j

    nnoremap & :&&<CR>
    xnoremap & :&&<CR>

    nnoremap <F10>r :source ~/.vimrc<CR>
    "nnoremap gv `[v`]    " highlight last inserted text
    nnoremap K i<CR><Esc>

    " copy , paste , select 기능 보완
    nnoremap Y y$
    nnoremap <Leader>y "+y
    nnoremap <Leader>Y "+yg_
    vnoremap <Leader>y "+y
    nnoremap <Leader>d "+d
    nnoremap <Leader>D "+yD
    vnoremap <Leader>d "+d
    nnoremap <Leader>p "+p
    nnoremap <Leader>P "+P
    " nnoremap <F3>     :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

    " 버퍼 관리
    " nnoremap <M-T> :enew<CR>       " 새로운 버퍼를 연다
    nnoremap <silent> <F8>        :bnext!<CR>
    nnoremap <silent> <PageUp>    :bnext!<CR>
    nnoremap <silent> <F7>        :bprevious!<CR>
    nnoremap <silent> <PageDown>  :bprevious!<CR>
    nnoremap <silent> <F12>d      :bd!<CR>
    " 현재 버퍼를 닫고 이전 버퍼로 이동
    nnoremap <silent> <F12>q      :bp <BAR> bd #<CR>
    nnoremap <silent> <F12><F12>  :Buffers<CR>
    " 현재 버퍼만 남기고 모두 닫기
    nnoremap <silent> <F12>o      :%bd <BAR> e # <BAR> bd #<CR>

    inoremap <C-e> <C-O>$
    inoremap <C-l> <right>


    "Bubble lines
    " nnoremap <M-K> ddkP
    " nnoremap <M-J> ddp
    " nnoremap gV `[v`]

    " nnoremap <leader>ev :vsplit $MYVIMRC<cr>

    " 윈도우 관리
    nnoremap <M-+> <C-w>+
    nnoremap <M-_> <C-w>-
    nnoremap <M-<> <C-w><
    nnoremap <M->> <C-w>>
    nnoremap <nowait> <Esc>+ <C-w>+
    nnoremap <nowait> <Esc>_ <C-w>-
    nnoremap <nowait> <Esc>< <C-w><
    nnoremap <nowait> <Esc>> <C-w>>
    nnoremap <M-h> <C-w>h
    nnoremap <M-j> <C-w>j
    nnoremap <M-k> <C-w>k
    nnoremap <M-l> <C-w>l

    " reselect visual block after indent/outdent
    " link: http://tilvim.com/2013/04/24/reindenting.html
    " vnoremap < <gv
    " vnoremap > >gv

    " completion
    " <c-x><c-l>  whole lines :h i^x^l
    " <c-x><c-l>  keywords from current file  :h i^x^n
    " <c-x><c-k>  keywords from 'dictionary' option   :h i^x^k
    " <c-x><c-t>  keywords from 'thesaurus' option    :h i^x^t
    " <c-x><c-i>  keywords from current and included files    :h i^x^i
    " <c-x><c-]>  tags    :h i^x^]
    " <c-x><c-f>  file names  :h i^x^f
    " <c-x><c-d>  definitions or macros   :h i^x^d
    " <c-x><c-v>  Vim commands    :h i^x^v
    " <c-x><c-u>  user defined (as specified in 'completefunc')   :h i^x^u
    " <c-x><c-o>  omni completion (as specified in 'omnifunc')    :h i^x^o
    " <c-x>s  spelling suggestions

" Plugin 설정 -------------------------------------------------------------------

    " Autopair
    let g:AutoPairsFlyMode = 0
    let g:AutoPairsShortcutToggle = ''
    let g:AutoPairsShortcutFastWrap = ''
    let g:AutoPairsShortcutJump = ''
    let g:AutoPairsShortcutBackInsert = ''

    " " incsearch
    " let g:incsearch#auto_nohlsearch = 0
    " map /  <Plug>(incsearch-forward)
    " map ?  <Plug>(incsearch-backward)
    " map g/ <Plug>(incsearch-stay)
    " map n  <Plug>(incsearch-nohl-n)
    " map N  <Plug>(incsearch-nohl-N)
    " map *  <Plug>(incsearch-nohl-*)
    " map #  <Plug>(incsearch-nohl-#)
    " map g* <Plug>(incsearch-nohl-g*)
    " map g# <Plug>(incsearch-nohl-g#)

    " Mundo
    nnoremap <LocalLeader>u :MundoToggle<cr>

    " rainbow
    nnoremap <LocalLeader>r :RainbowToggle<CR>


    " Syntastic 설정
    " https://thechefprogrammer.blogspot.kr/2014/05/syntax-check-for-php-and-javascript.html
    " set statusline+=%#warningmsg#
    " set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_php_checkers = ['php']
    let g:syntastic_check_on_wq = 0
    let g:syntastic_mode_map = { 'mode': 'passive' }
    let g:syntastic_auto_loc_list = 0
    " nnoremap <silent> <F2> :SyntasticCheck<CR>

    " let g:ale_fixers = { 'javascript': ['eslint'] }
    " let g:ale_javascript_eslint_use_global = 1
    let g:ale_lint_on_save = 1
    let g:ale_lint_on_text_changed = 0

    " rainbow
    let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

    " tabular
    vnoremap <C-t> :Tabularize /

    "eclim
    " let g:EclimCompletionMethod = 'omnifunc'

    " eregex
    nnoremap <leader>/ :call eregex#toggle()<CR>
    let g:eregex_default_enable = 0
    let g:eregex_forward_delim = '/'
    let g:eregex_backward_delim = '?'
    let g:eregex_force_case = 0

    " nmap ga <Plug>(EasyAlign)
    " xmap ga <Plug>(EasyAlign)

    nnoremap <Space>w :w<CR>
    nnoremap <silent>s <S-">
    vnoremap <silent>s <S-">

    nnoremap <LocalLeader>d :MacDictWord<CR>
    nnoremap <LocalLeader><LocalLeader>d :MacDictQuery<CR>

    nnoremap =e :Autoformat<CR>

    " srcexpl
    " nmap <LocalLeader>e :SrcExplToggle<CR>
    " let g:SrcExpl_winHeight = 8
    " let g:SrcExpl_refreshTime = 300
    " let g:SrcExpl_jumpKey = "<f2>"
    " let g:SrcExpl_gobackKey = "<SPACE>"

    " " // In order to avoid conflicts, the Source Explorer should know what plugins
    " " // except itself are using buffers. And you need add their buffer names into
    " " // below listaccording to the command ":buffers!"
    " let g:SrcExpl_pluginList = [
    "         \ "__Tag_List__",
    "         \ "_NERD_tree_"
    "     \ ]
    " let g:SrcExpl_searchLocalDef = 1
    " let g:SrcExpl_isUpdateTags = 0
    " let g:SrcExpl_prevDefKey = "<PAGEUP>"
    " let g:SrcExpl_nextDefKey = "<PAGEDOWN>"

    " multiple_cursors
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<Esc>'
    " nnoremap <C-c> :call multiple_cursors#quit()<CR>

    let g:vim_game_code_break_item_limit = 8

    let g:axring_rings = [
                \ ['&&', '||'],
                \ ['&', '|', '^'],
                \ ['&=', '|=', '^='],
                \ ['>>', '<<'],
                \ ['>>=', '<<='],
                \ ['==', '!='],
                \ ['>', '<', '>=', '<='],
                \ ['++', '--'],
                \ ['true', 'false'],
                \ ['verbose', 'debug', 'info', 'warn', 'error', 'fatal'],
                \ ]

    let g:axring_rings_go = [
                \ [':=', '='],
                \ ['byte', 'rune'],
                \ ['complex64', 'complex128'],
                \ ['int', 'int8', 'int16', 'int32', 'int64'],
                \ ['uint', 'uint8', 'uint16', 'uint32', 'uint64'],
                \ ['float32', 'float64'],
                \ ['interface', 'struct'],
                \ ]

    " let g:ale_fixers = {'php': ['php_cs_fixer']}
    let g:ale_fixers = {}
    let g:ale_fix_on_save = 1

" functions -------------------------------------------------------------------
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" autocmd BufEnter *.png,*.jpg,*gif exec "! imgcat ".expand("%") | :bw

command! ToHtml :so $VIMRUNTIME/syntax/2html.vim

" http://vim.wikia.com/wiki/Copy_filename_to_clipboard
if has('win32')
    command! GetFileName :let @*=substitute(expand("%"), "/", "\\", "g")
    command! GetFileAddress :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
else
    command! GetFileName :let @*=expand('%')
    command! GetFileAddress :let @*=expand('%:p')
endif

" 현재 편집중인 파일 경로로 pwd 를 변경한다
command! Ncd :cd %:p:h

" command! Time :put =strftime('%Y-%m-%d %H:%M:%S +0900')

" Change cursor shape between insert and normal mode in iTerm2.app + tmux + vim
" https://gist.github.com/andyfowler/1195581
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Autosave: https://github.com/907th/vim-auto-save
let g:auto_save_silent = 1

runtime! vim-include/*.vim

iabbr __email chesidyong@gmail.com
iabbr <expr> __time strftime("%Y-%m-%d %H:%M:%S")
iabbr <expr> __date strftime("%Y-%m-%d")
iabbr <expr> __file expand('%:p')
iabbr <expr> __name expand('%')
iabbr <expr> __pwd expand('%:p:h')
iabbr <expr> __branch system("git rev-parse --abbrev-ref HEAD")
iabbr <expr> __uuid system("uuidgen")
