local Utils = require "proyecto.new.utils"
local config = require "proyecto.config"

local view_config = config.new.ui.views.template_selection

local TemplateSelectionView = {}

local function create_cursor_toggler(buf_id, initial_row)
	local CURSOR_TEXT = view_config.cursor_text or ""
	local prev_row = initial_row

	return function()
		local current_line = vim.api.nvim_get_current_line()

		local line = vim.api.nvim_buf_get_lines(0, prev_row - 1, prev_row, false)[1]
		line = " " .. line:sub(2)
		vim.api.nvim_set_option_value("modifiable", true, { buf = buf_id })
		vim.api.nvim_buf_set_lines(buf_id, prev_row - 1, prev_row, false, { line })
		vim.api.nvim_set_current_line(CURSOR_TEXT .. current_line:sub(2))
		vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })

		prev_row = vim.api.nvim_win_get_cursor(0)[1]
	end
end

local function display_selectable_item_list(buf_id, items)
	local lines = view_config.header.center and vim.tbl_map(Utils.center_text, view_config.header.lines)
		or view_config.header.lines

	local first_item_row = #lines + 1

	local cursor_toggler = create_cursor_toggler(buf_id, first_item_row)

	vim.api.nvim_create_autocmd({ "CursorMovedI", "CursorMoved" }, {
		buf = buf_id,
		callback = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			local cursor_row, cursor_col = cursor_pos[1], cursor_pos[2]

			if cursor_row < first_item_row then ---Prevent the cursor from going above the first item in the list
				vim.api.nvim_win_set_cursor(0, { first_item_row, cursor_col })
			end

			cursor_toggler()
		end,
	})

	for _, i in ipairs(items) do
		table.insert(lines, view_config.gutter_text .. i)
	end

	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf_id })
	vim.api.nvim_win_set_cursor(0, { first_item_row, 0 })
end

function TemplateSelectionView.create(on_select)
	local buf_id = vim.api.nvim_create_buf(false, true)

	vim.cmd "stopinsert"
	vim.keymap.set("n", "<CR>", function()
		local first_char_col_outside_gutter = #view_config.gutter_text + 1
		local selected_template = vim.api.nvim_get_current_line():sub(first_char_col_outside_gutter)
		on_select(selected_template)
	end, { buf = buf_id })

	display_selectable_item_list(buf_id, vim.tbl_keys(config.templates))

	return buf_id
end

return TemplateSelectionView
