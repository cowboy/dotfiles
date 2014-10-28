set go-=T " Hide toolbar
set go-=r " Hide right scrollbar
set go-=L " Hide left scrollbar

" My favorite font!
set guifont=mplusForPowerline-1m-regular:h16

" Cmd-[, ]: Buffer Navigation
nmap <D-[> :bprev<CR>
nmap <D-]> :bnext<CR>
vmap <D-[> <Esc>:bprev<CR>
vmap <D-]> <Esc>:bnext<CR>

" Cmd-T: New buffer
macm File.New\ Tab key=<nop>
nmap <D-t> :enew<CR>
vmap <D-t> <Esc>:enew<CR>

" Cmd-Enter: Toggle Fullscreen
nmap <d-cr> :set invfu<cr>
vmap <d-cr> <Esc>:set invfu<cr>gv
