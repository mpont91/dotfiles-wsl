" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"turn on syntax highlighting
syntax on

" ================ General Config ====================

set number                      "Line numbers are good
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set ruler                       "Add the current line and column"


" ================ Scrolling ========================

set scrolloff=8                 "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1


" ================ Searching ========================

set incsearch                   "Show results as you type
set hlsearch                    "Highlight all matches