lua << EOF
vim.keymap.set('n', '<leader>t', function ()
	require('plenary.reload').reload_module("exrc")
	require("exrc").source()
end)
EOF


