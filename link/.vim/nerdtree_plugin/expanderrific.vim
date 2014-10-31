" expanderrific.vim
" https://github.com/cowboy/dotfiles
"
" Allow right/left to expand/collapse NERDTree dirs in a more meaningful way.

" Ben Alman
" http://benalman.com/

if exists("g:loaded_nerdtree_expanderrific")
  finish
endif
let g:loaded_nerdtree_expanderrific = 1

let expanderrific_expand   = ['l', '<Right>']
let expanderrific_collapse = ['h', '<Left>']

for key in expanderrific_expand
  call NERDTreeAddKeyMap({'key': key, 'scope': 'DirNode', 'callback': 'NERDTreeExpanderrificExpand'})
endfor

for key in expanderrific_collapse
  call NERDTreeAddKeyMap({'key': key, 'scope': 'Node', 'callback': 'NERDTreeExpanderrificCollapse'})
endfor

function! NERDTreeExpanderrificExpand(dir)
  let opts = {'reuse': 1}
  if g:NERDTreeCascadeOpenSingleChildDir == 0
    call a:dir.open(opts)
  else
    call a:dir.openAlong(opts)
  endif
  call b:NERDTree.render()
endfunction

function! NERDTreeExpanderrificCollapse(node)
  let node = a:node
  if !a:node.path.isDirectory || !a:node.isOpen
    let node = a:node.parent
  endif
  if node != b:NERDTreeRoot
    call node.close()
    call b:NERDTree.render()
    call node.putCursorHere(0, 0)
  endif
endfunction

