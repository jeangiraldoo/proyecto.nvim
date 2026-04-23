local Utils = require "proyecto.new.utils"
local config = require "proyecto.config"

local view_config = config.new.ui.views.template_customization

local TemplateCustomizationView = {}

local function generate_ascii_dir_structure(dir_struct, plugin_name)
	local lines = {
		"project/",
	}
	local function itera(content, depth, num_bars)
		for idx, item_opts in ipairs(content) do
			local item_name = Utils.project_name_gsub(plugin_name, item_opts.name)
			-- local item_name = item_opts.name:match "%%plugin_name" and item_opts.name:gsub("%%plugin_name", plugin_name)
			-- 	or item_opts.name

			local has_siblings_left = content[idx + 1] ~= nil
			local chars = has_siblings_left and "├── " or "└── "
			local str = chars .. item_name

			local bars = string.rep("│   ", num_bars)
			if depth > 1 and num_bars < depth - 1 then bars = bars .. "    " end

			table.insert(lines, bars .. str)

			if item_opts.content and item_opts.type == "directory" then
				itera(item_opts.content, depth + 1, has_siblings_left and num_bars + 1 or num_bars)
			end
		end
	end

	itera(dir_struct, 1, 0)

	return lines
end

function TemplateCustomizationView.create(project_name, template_name, on_select)
	local buf_id = vim.api.nvim_create_buf(false, true)

	vim.cmd "stopinsert"
	local lines = view_config.header.center and vim.tbl_map(Utils.center_text, view_config.header.lines)
		or view_config.header.lines

	local function create_option_cycler(key, text, initial_val, available_vals)
		table.sort(available_vals)

		table.insert(lines, text .. initial_val.val)
		local row = #lines

		local counter = 1

		if available_vals[counter] == initial_val.val then counter = counter + 1 end

		vim.keymap.set("n", key, function()
			local next_version_control_idx = (counter % #available_vals) + 1
			local next_version_control = available_vals[next_version_control_idx]

			if next_version_control == initial_val.val then
				counter = counter + 1
				next_version_control_idx = (counter % #available_vals) + 1
			end

			counter = counter + 1
			initial_val.val = available_vals[next_version_control_idx]

			vim.api.nvim_buf_set_lines(buf_id, row - 1, row, true, { text .. initial_val.val })
		end, { buf = buf_id })
	end

	local template_opts = config.templates[template_name]

	local displayed_vcs = { val = template_opts.version_control }
	create_option_cycler(
		view_config.version_control.cycle_keymap,
		view_config.version_control.text,
		displayed_vcs,
		vim.tbl_keys(config.version_control)
	)

	local displayed_license = { val = template_opts.license.id }
	create_option_cycler(
		view_config.license.cycle_keymap,
		view_config.license.text,
		displayed_license,
		vim.tbl_keys(config.licenses)
	)

	local dir_structure_lines = view_config.dir_structure.center
			and vim.tbl_map(Utils.center_text, view_config.dir_structure.lines)
		or vim.deepcopy(view_config.dir_structure.lines)

	vim.list_extend(dir_structure_lines, generate_ascii_dir_structure(template_opts.file_structure, project_name))
	vim.list_extend(lines, dir_structure_lines)
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

	vim.keymap.set("n", "<CR>", function() on_select(displayed_vcs.val, displayed_license.val) end)

	return buf_id
end

return TemplateCustomizationView
