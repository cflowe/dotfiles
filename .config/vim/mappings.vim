let mapleader = " "
let maplocalleader = " "

nnoremap <Space> <Nop>

nnoremap <Leader>ve :edit $MYVIMRC<CR>
nnoremap <Leader>vs :source $MYVIMRC<CR>

nnoremap <Leader>e :edit<Space>
nnoremap <Leader>n :next<CR>
nnoremap <Leader>N :N<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :qa<CR>
nnoremap <Leader>x :exit<CR>

nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l

nnoremap <Leader>H <C-w>H
nnoremap <Leader>J <C-w>J
nnoremap <Leader>K <C-w>K
nnoremap <Leader>L <C-w>L

nnoremap <Leader>_ <C-w>_
nnoremap <Leader>= <C-w>=
nnoremap <Leader>+ <C-w>+
nnoremap <Leader>- <C-w>-
nnoremap <Leader>\| <C-w>\|
nnoremap <Leader>> <C-w>>
nnoremap <Leader>< <C-w><

nnoremap <Leader>wc <C-w>c
nnoremap <Leader>wn <C-w>n
nnoremap <Leader>wo <C-w>o
nnoremap <Leader>wp <C-w>p
nnoremap <Leader>ww <C-w>w

"========================================
" open split below, stay in current window
"nnoremap <leader>sb :belowright split \| wincmd p<CR>

" open split below, move into it
"nnoremap <leader>sB :belowright split<CR>

" open split above, stay in current window
"nnoremap <leader>st :aboveleft split \| wincmd p<CR>

" open split above, move into it
"nnoremap <leader>sT :aboveleft split<CR>

"========================================
" terminal on the right, keep focus in editor
"nnoremap <leader>tr :belowright vsplit \| terminal \| wincmd p<CR>

" terminal on the right, jump into it
"nnoremap <leader>tR :belowright vsplit \| terminal<CR>

" terminal on the left, keep focus
"nnoremap <leader>tl :aboveleft vsplit \| terminal \| wincmd p<CR>

" terminal on the left, jump into it
"nnoremap <leader>tL :aboveleft vsplit \| terminal<CR>

"========================================
nnoremap <Leader>wh :leftabove vsplit<CR>
nnoremap <Leader>wl :rightbelow vsplit<CR>
nnoremap <Leader>wk :leftabove split<CR>
nnoremap <Leader>wj :rightbelow split<CR>

nnoremap <Leader>bw :write<CR>
nnoremap <Leader>bj :bnext<CR>
nnoremap <Leader>bk :bprevious<CR>
nnoremap <Leader>bl :buffers<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bb <C-^>

nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tj :tabnext<CR>
nnoremap <Leader>tk :tabprevious<CR>
nnoremap <Leader>tl :tabs<CR>
nnoremap <Leader>tc :tabclose<CR>

"nnoremap <Leader>tj :rightbelow new \| terminal<CR>
"nnoremap <Leader>tl :rightbelow vnew \| terminal<CR>

" Leave terminal-input mode with Escape.
"tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>un :set number!<CR>
nnoremap <Leader>ur :set relativenumber!<CR>
nnoremap <Leader>uw :set wrap!<CR>

"xnoremap < <gv
"xnoremap > >gv

"xnoremap <Leader>j :move '>+1<CR>gv=gv
"xnoremap <Leader>k :move '<-2<CR>gv=gv

" Paste over selected text without replacing the unnamed register.
"xnoremap <Leader>p "_dP

nnoremap <Leader>y "+y
xnoremap <Leader>y "+y
nnoremap <Leader>Y "+Y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

nnoremap <leader>sC <Cmd>!shellcheck %<CR>
nnoremap <leader>sc <Cmd>%w !shellcheck -<CR>

tnoremap <C-Space> <C-\><C-n>
