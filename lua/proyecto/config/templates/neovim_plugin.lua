return {
	file_structure = {
		{
			name = "lua",
			type = "directory",
			content = {
				{
					name = "%plugin_name",
					type = "directory",
					content = {
						{
							name = "init.lua",
							type = "file",
							content = {
								"local M = {}",
								"return M",
							},
						},
						{
							name = "health.lua",
							type = "file",
							content = {},
						},
					},
				},
			},
		},
		{
			name = "doc",
			type = "directory",
			content = {
				{
					name = "%plugin_name.txt",
					type = "file",
					content = {},
				},
			},
		},
		{
			name = "plugin",
			type = "directory",
			content = {
				{
					name = "%plugin_name.lua",
					type = "file",
					content = {},
				},
			},
		},
		{
			name = "README.md",
			type = "file",
			content = {
				"# %plugin_name.nvim",
			},
		},
		{
			name = ".editorconfig",
			type = "file",
			content = {
				"root = true",

				"[*]",
				"charset = utf-8",
				"trim_trailing_whitespace = true",
				"",
				"[*.lua]",
				"indent_size = 4",
				"max_line_length = 100",
			},
		},
		{
			name = ".stylua.toml",
			type = "file",
			content = {
				"indent_width = 4",
				'syntax = "LuaJIT"',
				'collapse_simple_statement = "Always"',
				'call_parentheses = "None"',
				"column_width = 100",
			},
		},
		{
			name = "CONTRIBUTING.md",
			type = "file",
			content = {
				"",
			},
		},
	},
	version_control_name = "git",
	license = {
		id = "GPL_3.0",
		file_name = "LICENSE",
	},
}
