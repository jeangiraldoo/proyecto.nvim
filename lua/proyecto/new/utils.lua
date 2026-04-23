local Utils = {}

function Utils.project_name_gsub(project_name, text)
	vim.validate("project_name", project_name, "string")
	vim.validate("text", text, "string")

	return text:match "%%plugin_name" and text:gsub("%%plugin_name", project_name) or text
end

local cols = vim.api.nvim_get_option_value("columns", {})
local lines = vim.api.nvim_get_option_value("lines", {})

-- local WINDOW_DIMENSIONS = {
-- 	WIDTH = math.ceil(cols * 0.5),
-- 	HEIGHT = math.ceil(lines * 0.5 - 4),
-- }

function Utils.center_text(str)
	local shift = math.floor(math.ceil(cols * 0.5) / 2) - math.floor(string.len(str) / 2)
	return string.rep(" ", shift) .. str
end
function Utils.open_window(buf_id)
	local layout = require("proyecto.config").new.ui.layout
	local width = math.ceil(cols * layout.width)
	local height = math.ceil(lines * layout.height)

	return vim.api.nvim_open_win(buf_id, true, {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = math.ceil((lines - height) / 2 - 1),
		col = math.ceil((cols - width) / 2),
	})
end

return Utils
