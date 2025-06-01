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
"let g:UltiSnipsSnippetDirectories=["UltiSnips", "mySnippets"]
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

" Load the default google configuration and install Glug
source /usr/share/vim/google/google.vim

"==================================="
" Load and Configure Google Plugins "
"==================================="
" For more plugins, see go/vim/plugins

" :PiperSelectActiveFiles comes by default from google.vim. It's so useful that
" we map it to <leader>p (i.e., ,p).
" Use :h piper for more details about the piper integration
noremap <leader>p :PiperSelectActiveFiles<CR>

" Load the blaze plugins, with the ,b prefix on all commands.
" Thus, to Blaze build, you can do <leader>bb.
" Since we've set the mapleader to ',' above, this should be ,bb in practice
Glug blaze plugin[mappings]='<leader>b'

" Loads youcompleteme, the awesomest autocompletion engine.
" See go/ycm for more details.
Glug youcompleteme-google

" GTImporter is a script that uses GTags to find and sort Java imports. This is
" only useful for Java, so you will want to remove these lines if you don't use
" Java. You can use with codefmt to auto-sort on write with:
" autocmd FileType java AutoFormatBuffer gtimporter
Glug gtimporter
" Import the work under the cursor
nnoremap <leader>si :GtImporter<CR>
" Sort the imports in the (java) file
nnoremap <leader>ss :GtImporterSort<CR>

" Load the code formatting plugin. We first load the open-source version. Then,
" we load the internal google settings. Then, we automatically enable formatting
" when we write the file for Go, BUILD, proto, and c/cpp files.
" Use :h codefmt-google or :h codefmt for more details.
Glug codefmt
Glug codefmt-google

" Wrap autocmds inside an augroup to protect against reloading this script.
" For more details, see:
" https://learnvimscriptthehardway.stevelosh.com/chapters/14.html
augroup autoformat
  autocmd!
  " Autoformat BUILD files on write.
  autocmd FileType bzl AutoFormatBuffer buildifier
  " Autoformat go files on write.
  autocmd FileType go AutoFormatBuffer gofmt
  " Autoformat proto files on write.
  autocmd FileType proto AutoFormatBuffer clang-format
  " Autoformat c and c++ files on write.
  autocmd FileType c,cpp AutoFormatBuffer clang-format
augroup END

" Load the G4 plugin, which allows G4MoveFile, G4Edit, G4Pending, etc.
" Use :h g4 for more details about this plugin
Glug g4

" Load the Related Files plugin. Use :h relatedfiles for more details
Glug relatedfiles
nnoremap <leader>rf :RelatedFilesWindow<CR>

" Enable the corpweb plugin, which allows us to open codesearch from vim
Glug corpweb
" search in codesearch for the word under the cursor
nnoremap <leader>ws :CorpWebCs <cword> <CR>
" search in codesearch for the current file
nnoremap <leader>wf :CorpWebCsFile<CR>

" Load the Critique integration. Use :h critique for more details
Glug critique

set rtp+=~/.vim/bundle/Vundle.vim
if isdirectory(expand('$HOME/.vim/bundle/Vundle.vim'))
  call vundle#begin()
  " Let Vundle manage Vundle, required
  Plugin 'VundleVim/vundle.vim'
  " Install plugins that come from github.  Once Vundle is installed, these can be
  " installed with :PluginInstall

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
  Plugin 'cespare/vim-toml'
  Plugin 'https://gn.googlesource.com/gn', { 'rtp': 'misc/vim' }
  Plugin 'dhruvasagar/vim-table-mode'

  call vundle#end()
else
  echomsg 'Vundle is not installed. You can install Vundle from'
      \ 'https://github.com/VundleVim/Vundle.vim'
endif



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
