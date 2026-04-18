local function get_raw_args_list(cmd_line)
	local cmd_line_without_plugin_name = cmd_line:gsub("^Proyecto%s*", "")
	local args = vim.split(cmd_line_without_plugin_name, "%s+")
	return args
end

vim.api.nvim_create_user_command("Proyecto", function(opts)
	local Proyecto = require "proyecto"

	local args = get_raw_args_list(opts.args)

	if args[1] == "new" then
		local template_name, project_name = args[2], args[3]

		Proyecto.new.create(template_name, { project_name = project_name })
	end
end, {
	nargs = "?",
	desc = "Create project from template",
	complete = function(_, cmd_line)
		local args = get_raw_args_list(cmd_line)

		if #args == 1 then -- :Proyecto <cursor>
			local valid_cmds = { "new" }
			return valid_cmds
		end

		if #args == 2 then -- :Proyecto <cmd> <cursor>
			if args[1] == "new" then
				return require("proyecto").get_template_names()
			end
		end

		return {}
	end,
})
