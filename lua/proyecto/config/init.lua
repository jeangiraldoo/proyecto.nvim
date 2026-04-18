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
	},
	licenses = {
		MIT = {},
		GPLv3 = {},
	},
	ui = {
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
					cycle_keymap = "g",
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
}
