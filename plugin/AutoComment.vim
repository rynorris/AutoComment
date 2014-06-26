if !has('python')
    finish
endif

if !exists('g:autocomment_disabled')
  let g:autocomment_disabled = 0
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

exe 'python import sys; sys.path.append("' . s:plugin_path . '")'

function! DoAutoComment()

python << EOF
import vim
from autocomment import *
b = getCommentBlockAt(vim.current.window.cursor[0])
if b != None:
    formatBlockFrom(b, 1)
EOF

endfunc

function! DoFormatComment()

  if g:autocomment_disabled
    return
  endif

python << EOF
import vim
from autocomment import *
b = getCommentBlockAt(vim.current.window.cursor[0])
if b != None:
    formatBlockFrom(b, vim.current.window.cursor[0]-b.start)
EOF

endfunc

function! DoOnReturn()

python << EOF
import vim
from autocomment import *
onReturn()
EOF

endfunc

function! DoToggleAutoComment()
  let g:autocomment_disabled = g:autocomment_disabled == 0 ? 1 : 0
  if g:autocomment_disabled
    echom "Autocomment Disabled."
  else
    echom "Autocomment Enabled."
  endif
endfunc

command! ToggleAutoComment call DoToggleAutoComment()
command! AutoComment call DoAutoComment()
command! FormatComment call DoFormatComment()
command! OnReturn call DoOnReturn()

inoremap <silent> <Space> <Space><C-\><C-o>:FormatComment<CR>
"inoremap <silent> <Return> <Return><C-\><C-o>:OnReturn<CR>
