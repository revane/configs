set nocompatible              " be iMproved, required
filetype off                  " required

if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

let g:piperlib_ignored_dirs = [$HOME]
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mySnippets"]
let g:UltiSnipsSnippetsDir="~/.vim/mySnippets"
let g:UltiSnipsEditSplit="vertical"
let g:ackprg='ag --nogroup --nocolor --column'

" Bi-directional yank-put over ssh
nnoremap ,p :r ~/.yank<CR>
vnoremap ,y :w! ~/.yank<CR>
autocmd BufWritePost,FileWritePost .yank silent !rsync ~/.yank ci-ubu-01:.yank&
nnoremap K :Ack! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Turn off beeping and flashing.
set noeb
autocmd! GUIEnter * set vb t_vb=

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'altercation/vim-colors-solarized'

Plugin 'SirVer/ultisnips'
Plugin 'kbenzie/vim-spirv'
Plugin 'honza/vim-snippets'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/tpope-vim-abolish'
Plugin 'tpope/vim-eunuch'
Plugin 'arecarn/crunch.git'
Plugin 'naseer/logcat'
Plugin 'elzr/vim-json'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'tell-k/vim-autopep8'
Plugin 'tommcdo/vim-exchange'
Plugin 'udalov/kotlin-vim'
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'
Plugin 'cespare/vim-toml'
Plugin 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


let g:crunch_result_type_append=0
syn on
if has("gui_running")
    set background=light
    colorscheme solarized
endif
filetype plugin indent on

source /usr/share/vim/google/glug/bootstrap.vim
Glug codefmt-google

call glaive#Install()

augroup CodeFmt
    autocmd!
    autocmd FileType gn AutoFormatBuffer gn
    autocmd FileType javascript AutoFormatBuffer clang-format
augroup END

nnoremap ,cd :cd %:p:h<CR>
set tabstop=2
set bs=indent,eol,start
set shiftwidth=2
set expandtab
set nowrap
set foldmethod=marker
set nojoinspaces

let g:autopep8_max_line_length=79
let g:autopep8_ignore=""
let g:autopep8_disable_show_diff=1

let g:clang_format_path=trim(system("which clang-format"))
if has('python')
  map <C-K> :pyf ~/bin/clang-format.py<cr>
  imap <C-K> <c-o>:pyf ~/bin/clang-format.py<cr>
elseif has('python3')
  map <C-K> :py3f ~/bin/clang-format.py<cr>
  imap <C-K> <c-o>:py3f ~/bin/clang-format.py<cr>
  py3 import os; sys.path.insert(0, os.path.expanduser("~/.pyenv/versions/3.7.1/lib/python3.7/site-packages"))
endif

set cino+=>1s,:0,l1,g0,N-1s

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Default to tree mode
let g:netrw_liststyle=3

" fill rest of line with characters
function! FillLine( str )
    " set tw to the desired total length
    let tw = &textwidth
    if tw==0 | let tw = 80 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction

function! RmSpaceAndComments() range
    let currLastLine = a:lastline
    let currLength = line('$')
    " Delete empty lines
    silent! execute a:firstline . "," . currLastLine . 'g/^\s*$/d'
    let currLastLine = currLastLine - (currLength - line('$'))
    let currLength = line('$')
    " Delete comments
    silent! execute a:firstline . "," . currLastLine . 'g/^\s*\/\/\/\?/d'
endfunction

function! VirtualToOverride() range
    call cursor(a:firstline, 1)
    let firstFuncLine = search('^\s\+virtual', 'ncW', a:lastline)
    if firstFuncLine == 0
        echo "No function found in range"
        return
    endif 
    let currLastLine = a:lastline
    let currLength = line('$')
    silent! execute a:firstline . "," . currLastLine . 'call RmSpaceAndComments()'
    let currLastLine = currLastLine - (currLength - line('$'))
    let currLength = line('$')
    " Join multi-line decls.
    silent! execute a:firstline . "," . currLastLine . 'g!/;$/.,/;$/j'
    let currLastLine = currLastLine - (currLength - line('$'))
    let currLength = line('$')
    " Convert virtuals to override
    silent! execute a:firstline . "," . currLastLine . 's/virtual\s*\(.*\) = 0;/\1 override;/'
endfunction

function! OverridesToBodies() range
    let origLength = line('$')
    silent! execute a:firstline . "," . a:lastline . 's/\s\+override;/{\/\/}'
    let newLastline = a:lastline - (origLength - line('$'))
    silent! execute a:firstline . "," . newLastline . 'pyf ~/bin/clang-format.py'
endfunction

function! MkMock() range
    let currLastLine = a:lastline
    let currLength = line('$')
    silent! execute a:firstline . "," . currLastLine . 'call RmSpaceAndComments()'
    let currLastLine = currLastLine - (currLength - line('$'))
    let currLength = line('$')
    " Join multi-line function defs into one line
    silent! execute a:firstline . "," . currLastLine . 'g!/;$/.,/;$/j'
    let currLastLine = currLastLine - (currLength - line('$'))
    let currLength = line('$')
    " Introdce MOCK_ macros
    silent! execute a:firstline . "," . currLastLine . 's/virtual\s\s*\(\S\S*\)\s\s*\(\w\w*\)\(.*\) = 0;/MOCK_METHOD0(\2, \1\3);/'
endfunction

function! MkTitle(char)
    yank
    put
    exe "norm 0v$r" . a:char . "o"
endfunction

map ,t1 :call MkTitle('/')<CR>
map ,t2 :call MkTitle('=')<CR>
map ,t3 :call MkTitle('-')<CR>
map ,f :call FillLine('-')<CR>
if g:os == "Linux"
    set guifont=Fira\ Code\ 10
elseif g:os == "Darwin"
    set guifont=Monaco:h12
endif
