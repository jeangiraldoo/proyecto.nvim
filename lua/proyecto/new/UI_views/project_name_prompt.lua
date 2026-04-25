local Utils = require "proyecto.new.utils"
local config = require "proyecto.config"

local view_config = config.new.ui.views.project_name_prompt

local ProjectNamePromptView = {}

function ProjectNamePromptView.create(on_confirm)
	local buf_id = vim.api.nvim_create_buf(false, true)

	local lines = view_config.header.center and vim.tbl_map(Utils.center_text, view_config.header.lines)
		or view_config.header.lines

	table.insert(lines, view_config.prompt)
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf_id })
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

	local prompt_row = #lines
	local zero_based_prompt_row = prompt_row - 1

	-- vim.api.nvim_win_set_cursor(0, { prompt_row, #view_config.prompt + 1 })
	vim.cmd "startinsert"

	local function get_typed_name()
		local prompt_line = vim.api.nvim_buf_get_lines(buf_id, zero_based_prompt_row, prompt_row, true)[1]
		local remainder = prompt_line:sub(#view_config.prompt + 1)
		return remainder
	end

	vim.api.nvim_create_autocmd({ "CursorMovedI", "CursorMoved" }, {
		buf = buf_id,
		callback = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			local cursor_row, cursor_col = cursor_pos[1], cursor_pos[2]

			if cursor_row ~= prompt_row then ---Prevent the cursor from going above the first item in the list
				vim.api.nvim_win_set_cursor(0, { prompt_row, cursor_col })
			end

			local prompt_line = vim.api.nvim_buf_get_lines(buf_id, zero_based_prompt_row, prompt_row, true)[1]
			if prompt_line:sub(1, #view_config.prompt) ~= view_config.prompt then
				vim.api.nvim_buf_set_lines(
					buf_id,
					zero_based_prompt_row,
					prompt_row,
					true,
					{ view_config.prompt .. get_typed_name() }
				)
			end

			if cursor_col < #view_config.prompt then
				vim.api.nvim_win_set_cursor(0, { prompt_row, #view_config.prompt })
			end
		end,
	})

	vim.keymap.set("i", "<CR>", function() on_confirm(get_typed_name()) end, { buf = buf_id })
	return buf_id
end

return ProjectNamePromptView
