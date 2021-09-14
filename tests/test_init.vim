" Add this repo to the front of 'runtimepath'
exe 'set rtp^=' .. expand('<sfile>:p:h:h')
runtime! plugin/plenary.vim

" Find test_helper from lua
lua <<EOF
require("plenary/busted")
package.path = vim.fn.expand('<sfile>:p:h') .. '/?.lua;' .. package.path
EOF
