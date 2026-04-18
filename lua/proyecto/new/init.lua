local Utils = require "proyecto.new.utils"

local New = {}
local function create_node(path, node, project_name)
	local node_name = Utils.project_name_gsub(project_name, node.name)

	if node.type == "directory" then
		local new_dir_path = vim.fs.joinpath(path, node_name)
		vim.fn.mkdir(new_dir_path, "p")

		for _, child in ipairs(node.content or {}) do
			create_node(new_dir_path, child, project_name)
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

function New.create(template_name, opts)
	local config = require "proyecto.config"
	local template = config.templates[template_name]

	if not template then
		vim.notify("Invalid template: " .. tostring(template_name), vim.log.levels.ERROR)
		return
	end

	local project_name = opts.project_name or config.new.default_project_name
	local root = opts.root or vim.fn.getcwd()

	for _, node in ipairs(template.file_structure) do
		create_node(root, node, project_name)
	end

	if template.version_control_name and config.version_control[template.version_control_name] then
		vim.system(config.version_control[template.version_control_name])
	end

	if template.license and config.licenses[template.license.id] then
		local license_path = vim.fs.joinpath(root, template.license.file_name)
		vim.fn.writefile(config.licenses[template.license.id], license_path)
	end

	vim.notify("Project successfully created", vim.log.levels.INFO)
end

return New
