local initFont = vim.inspect(vim.opt.guifont._value):match('%"(.+)%"')
local currFont
local currFontName
local currFontSize

local function get_font()
	currFont = vim.inspect(vim.opt.guifont._value)
	currFontName = currFont:match('%"(.+)%"'):gsub("(.*)%:.*$", "%1")
	currFontSize = currFont:match('%"(.+)%"'):gsub(".*:h", "")
end

local function set_font()
	vim.opt.guifont = currFont
end

local function update_font(size)
	get_font()
	if size == 'grow' then
		currFont = currFontName .. ':h' .. tostring(tonumber(currFontSize) + 1)
	elseif size == 'shrink' then
		currFont = currFontName .. ':h' .. tostring(tonumber(currFontSize) - 1)
	end
	set_font()
end

local function reset_font()
	vim.opt.guifont = initFont
end

vim.api.nvim_create_user_command('FontSizeUp', function() update_font('grow') end, { bang = true })
vim.api.nvim_create_user_command('FontSizeDown', function() update_font('shrink') end, { bang = true })
vim.api.nvim_create_user_command('FontDefault', function() reset_font() end, { desc = 'Reset to default font', bang = true })

vim.keymap.set('n', '<C-+>', function() update_font('grow') end, { desc = 'Increase font size', remap = false })
vim.keymap.set('n', '<C-S-+>', function() update_font('grow') end, { desc = 'Increase font size', remap = false })
vim.keymap.set('n', '<C-->', function() update_font('shrink') end, { desc = 'Decrease font size', remap = false })
vim.keymap.set('n', '<C-ScrollWheelUp>', function() update_font('grow') end, { desc = 'Increase font size', remap = false })
vim.keymap.set('n', '<C-ScrollWheelDown>', function() update_font('shrink') end, { desc = 'Decrease font size', remap = false })
vim.keymap.set('n', '<A-C-=>', reset_font, { desc = 'Reset to default font', remap = false })

return {
	update_font = update_font,
	reset_font = reset_font
}
