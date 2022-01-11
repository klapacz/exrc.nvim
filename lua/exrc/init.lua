local Path = require('plenary.path')
local sha = require('exrc.sha2')
local cache_file_path = 'exrc/cache.json'

local function source ()
	local exrc_path = vim.fn.fnamemodify('.exrc', ':p')
	local exrc_file = Path:new(exrc_path)
	if not exrc_file:exists() then
			return
	end

	local cache_file = Path:new(vim.fn.stdpath('cache')):joinpath(cache_file_path)
	if not cache_file:exists() then
		cache_file:touch({ parents = true })
		cache_file:write('{}', 'w')
	end

	local cache = vim.json.decode(cache_file:read())
	local cached_checksum = cache[exrc_path]
	local checksum = sha.sha256(exrc_file:read())

	if checksum ~= cached_checksum then
		local state = checksum == nil and "not recognized" or "changed"

		vim.ui.select(
			{"Yes", "No"},
			{ prompt = '.exrc file ' .. state .. ', trust and exec?' },
			function (result)
				if result ~= "Yes" then return end

				cache[exrc_path] = checksum
				cache_file:write(vim.json.encode(cache), 'w')
				vim.cmd('source ' .. exrc_path)
			end
		)
		return
	end

	vim.cmd('source ' .. exrc_path)
end

vim.api.nvim_add_user_command('Exrc', source, {})

return {
		source = source,
}

