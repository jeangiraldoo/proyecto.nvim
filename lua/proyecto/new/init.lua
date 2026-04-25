local Utils = require "proyecto.new.utils"

local New = {}

local function setup_buf(buf_id, win_id)
	vim.api.nvim_win_set_buf(win_id, buf_id)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf_id })

	vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win_id, true) end, { buf = buf_id })
end

local function _create_node(path, node, project_name)
	vim.validate("path", path, "string")
	vim.validate("node", node, "table")
	vim.validate("project_name", project_name, "string")

	local node_name = Utils.project_name_gsub(project_name, node.name)

	if node.type == "directory" then
		local new_dir_path = vim.fs.joinpath(path, node_name)
		vim.fn.mkdir(new_dir_path, "p")

		for _, child in ipairs(node.content or {}) do
			_create_node(new_dir_path, child, project_name)
		end
	elseif node.type == "file" then
		local new_file_path = vim.fs.joinpath(path, node_name)

		if vim.loop.fs_stat(new_file_path) then
			vim.notify("File already exists: " .. new_file_path, vim.log.levels.WARN)
			return
		end

		local file_content = vim.iter(node.content)
			:map(function(line) return Utils.project_name_gsub(project_name, line) end)
			:totable()
		vim.fn.writefile(file_content or {}, new_file_path)
	end
end

function New.launch_UI()
	local name_prompt_view = require "proyecto.new.UI_views.project_name_prompt"

	local win_id
	local prompt_buf_id = name_prompt_view.create(function(project_name)
		local template_selection_view = require "proyecto.new.UI_views.template_selection"

		local template_selection_buf_id = template_selection_view.create(function(template_name)
			local template_customization_view = require "proyecto.new.UI_views.template_customization"
			local template_customization_buf_id = template_customization_view.create(
				project_name,
				template_name,
				function(version_control, license)
					vim.api.nvim_win_close(win_id, true)
					New.create(template_name, {
						project_name = project_name,
						version_control_name = version_control,
						license = { id = license, file_name = "LICENSE" },
					})
				end
			)
			setup_buf(template_customization_buf_id, win_id)
		end)
		setup_buf(template_selection_buf_id, win_id)
	end)

	win_id = Utils.open_window(prompt_buf_id)
	setup_buf(prompt_buf_id, win_id)
end

function New.create(template_name, opts)
	vim.validate("template_name", template_name, "string")

	vim.validate("opts", opts, "table", true)
	vim.validate("opts.project_name", opts.project_name, "string", true)
	vim.validate("opts.root", opts.root, "string", true)

	local config = require "proyecto.config"
	local template = config.templates[template_name]

	if not template then
		vim.notify("Invalid template: " .. tostring(template_name), vim.log.levels.ERROR)
		return
	end

	local project_name = opts.project_name or config.new.default_project_name
	local root = opts.root or vim.fn.getcwd()

	for _, node in ipairs(template.file_structure) do
		_create_node(root, node, project_name)
	end

	local version_control_name = opts and opts.version_control_name or template.version_control_name

	vim.system(config.version_control[version_control_name])

	local license = opts and opts.license or template.license
	local license_path = vim.fs.joinpath(root, license.file_name)
	vim.fn.writefile(config.licenses[license.id], license_path)

	vim.notify("Project successfully created", vim.log.levels.INFO)
end

return New
