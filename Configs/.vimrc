" wishi's vimrc
" * optimised for C, C++ and stuff
" * colors for dark backgrounds
" * + spellchecker (for GUI and CLI)
" * send good tips and ideas to wishinet-at-gmail.com

" no vi
set nocompatible
" for mutt: no backup
set nobackup
" liner numbers
set number
" indents
set autoindent
set smartindent
" highlights
syntax on

" filetype handlers
filetype plugin indent on
filetype plugin on


set nocp
set bs=2
set viminfo='20,\"500
set history=50

" ruler
set ruler
set rulerformat=%35(%-8(%4*%l%0*,%4*%c\ %)%-10(%1*0x%02B\ %2*%3b\ %)%-10(%5*%y%6*%m%7*%r%)\ %5(%3*%P%)%)
       

"let g:xml_syntax_folding=1
"set foldmethod=manual
"set foldmethod=syntax
"set foldlevel=2

" set hlsearch
" no splits

""Windows
"utocmd WinEnter * :silent! wincmd T

" tabwidth
set tabstop=3
set shiftwidth=3
set expandtab

"" colors and highlights
" colorscheme elflord

" highlight TabLine       term=reverse      cterm=reverse ctermfg=cyan ctermbg=black       guibg=#222222 guifg=#228822
" highlight TabLineFill   term=reverse      cterm=reverse ctermfg=cyan ctermbg=black       guibg=#222222 guifg=#226622
" highlight TabLineSel                      ctermfg=red ctermbg=blue                     guibg=#228822 guifg=#222222

if has('gui_running')
   colors lettuce  
   set columns=150
   set lines=50
      else
   set background=dark
   hi Cursor ctermbg=green ctermfg=NONE
"  hi NonText ctermbg=black ctermfg=blue
"  hi Normal ctermbg=black ctermfg=white
   hi StatusLine ctermbg=black ctermfg=white
   hi StatusLineNc ctermbg=white ctermfg=black
endif

" maps
nmap zp zO
nmap g1 :tabn 1<CR>
nmap g2 :tabn 2<CR>
nmap g3 :tabn 3<CR>
nmap g4 :tabn 4<CR>
nmap g5 :tabn 5<CR>
nmap g6 :tabn 6<CR>
nmap g7 :tabn 7<CR>
nmap g8 :tabn 8<CR>
nmap g9 :tabn 9<CR>
nmap ., :bp<CR>
nmap .. :bn<CR>
nmap ./ :buffers<CR>

imap <C-a> <Esc>0i
imap <C-e> <Esc>$a
map <C-a> <Esc>0i
map <C-e> <Esc>$a

" modeline
set modeline
set modelines=1

set statusline=[%1*%n%*]\ %2*%f%*%*\ %=\ %10(%m%r%y%)\ %5*%-15(%l,%c%)%*%-9(%6*0x%02B%*%)%P
set laststatus=2
" hi statusline ctermbg=green ctermfg=black cterm=NONE
" hi statuslineNC ctermbg=grey ctermfg=black cterm=NONE


"" spell checking
" map <F6> <Esc>:setlocal spell spelllang=en_us<CR>
" map <F7> <Esc>:setlocal nospell<CR>
" setlocal spell spelllang=de
set spellfile="~/.vim/spell/de.utf-8.spl"

" highligts for spelling errors on GUI and CLI
hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#ffffff guibg=#7f0000 gui=underline
hi SpellCap guifg=#ffffff guibg=#7f007f
hi SpellLocal term=reverse ctermfg=black ctermbg=darkgreen guifg=#ffffff guibg=#7f0000 gui=underline
hi SpellRare guifg=#ffffff guibg=#00007f gui=underline

hi User1 ctermfg=blue ctermbg=green
hi User2 ctermfg=darkblue ctermbg=green
hi User3 ctermfg=yellow ctermbg=green
hi User5 ctermfg=darkmagenta ctermbg=green
hi User6 ctermfg=darkred ctermbg=green


let &titlestring = expand ("%:p:~:.:h")

set digraph
" turn off annoying bell
set noerrorbells

set esckeys
set hidden
set laststatus=2
set showcmd
set showmatch
set showmode
set nosplitbelow
set whichwrap=<,>,h,l,[,]


highlight Pmenu guibg=brown gui=bold

highlight PMenu      cterm=bold ctermbg=DarkBlue ctermfg=Gray
highlight PMenuSel   cterm=bold ctermbg=Brown ctermfg=Gray
highlight PMenuSbar  cterm=bold ctermbg=DarkBlue
highlight PMenuThumb cterm=bold ctermbg=Yellow

"" Java completion 
"setlocal omnifunc=javacomplete#Complete

set go=Acgtm            " advanced, try help 'go
set nomh                " don't hide the mouse

" Python completion
if has("autocmd") 
      autocmd FileType python set complete+=k/Users/wishi/.vim/pydiction isk+=.,( 
endif                   " has("autocmd")

" MacOS ctags fix    
let Tlist_Ctags_Cmd='/opt/local/bin/ctags'
