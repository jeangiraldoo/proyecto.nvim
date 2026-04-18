local Proyecto = {}

function Proyecto.get_template_names() return vim.tbl_keys(require("proyecto.config").templates) end

function Proyecto.setup(user_config)
	vim.validate("user_config", user_config, "table", true)

	if not user_config then return end

	local config = require "proyecto.config"
	local merged = vim.tbl_deep_extend("force", config, user_config)

	for k in pairs(config) do
		config[k] = nil
	end

	for k, v in pairs(merged) do
		config[k] = v
	end
end

Proyecto.new = require "proyecto.new"

return Proyecto
