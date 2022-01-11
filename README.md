# exrc.nvim
Secure local config files. Requires neovim-nightly.


```lua
use {
	'klapacz/exrc.nvim',
	requires = { 'nvim-lua/plenary.nvim' },
	config = function()
		require('exrc').source()
		vim.keymap.set('n', '<leader>so', require('exrc').source)
	end,
}
```
