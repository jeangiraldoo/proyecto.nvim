local Utils = {}

function Utils.project_name_gsub(project_name, text)
	vim.validate("project_name", project_name, "string")
	vim.validate("text", text, "string")

	return text:match "%%plugin_name" and text:gsub("%%plugin_name", project_name) or text
end

return Utils
