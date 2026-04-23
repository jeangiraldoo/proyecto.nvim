local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

return {
	templates = vim.iter(vim.fs.dir(vim.fs.joinpath(dir, "templates"))):fold({}, function(acc, name, type)
		if type == "file" then
			local template_name = name:gsub("%.lua$", "")
			acc[template_name] = require("proyecto.config.templates." .. template_name)
		end

		return acc
	end),
	version_control = {
		git = { "git", "init", "." },
		jujutsu = {},
	},
	new = {
		default_project_name = "proyect",
		ui = {
			layout = {
				width = 0.5,
				height = 0.5,
			},
			views = {
				project_name_prompt = {
					header = {
						lines = {
							"New project",
							"",
							"[Enter] Confirm   [q] Quit",
							"",
						},
						center = true,
					},
					prompt = "Project name:",
				},
				template_selection = {
					header = {
						lines = {
							"Select the template to use",
							"",
							"[Enter] Confirm   [q] Quit",
							"",
						},
						center = true,
					},
					cursor_text = ">",
					gutter_text = "--> ",
				},
				template_customization = {
					header = {
						lines = {
							"Template customization",
							"",
							"[Enter] Confirm   [q] Quit   [g] Cycle version control [p] Cycle license",
							"",
						},
						center = true,
					},
					version_control = {
						text = "Version control: ",
						cycle_keymap = "t",
					},
					license = {
						text = "License: ",
						cycle_keymap = "p",
					},
					dir_structure = {
						lines = {
							"",
							"Directory structure",
							"",
						},
						center = false,
					},
				},
			},
		},
	},
	licenses = vim.iter(vim.fs.dir(vim.fs.joinpath(dir, "licenses"))):fold({}, function(acc, name, type)
		if type == "file" then
			local license_name = name:gsub("%.txt$", "")

			acc[license_name] = vim.fn.readfile(vim.fs.joinpath(dir, "licenses", name))
		end

		return acc
	end),
}
