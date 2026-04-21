<!-- markdownlint-disable-next-line MD033 MD041 -->
<div align="center">

![proyecto.nvim is built with lua](https://img.shields.io/badge/%20Lua-%23D0B8EB?style=for-the-badge&logo=lua)
![When was the last commit made](https://img.shields.io/github/last-commit/jeangiraldoo/proyecto.nvim?style=for-the-badge&labelColor=%232E3A59&color=%23A6D8FF)
![Neovim version 0.12](https://img.shields.io/badge/v0.10%2B-%238BD5CA?style=for-the-badge&logo=neovim&label=Neovim&labelColor=%232E3A59&color=%238BD5CA)
![Neovim is under the MIT License](https://img.shields.io/badge/MIT-%232E3A59?style=for-the-badge&label=License&labelColor=%232E3A59&color=%23F4A6A6)
![Repository size](https://img.shields.io/github/repo-size/jeangiraldoo/proyecto.nvim?style=for-the-badge&logo=files&logoColor=yellow&label=SIZE&labelColor=%232E3A59&color=%23A8D8A1)

# proyecto.nvim

Manage your projects with no bureaucracy

</div>

## Table of contents

- [Features](#features)
- [Usage](#usage)
- [Configuration](#configuration)
- [Built-in templates](#built-in-templates)

## Features

- Bootstrap any project using preconfigured templates
- Add your own project templates or customize existing ones

## Usage

The plugin providess the `:proyecto` command, which accepts the following
arguments:

### new

Bootstraps a new project using a template. Additionally, the `new` argument accepts
2 positional subarguments:

1. The template name
2. An optional project name

## Configuration

### Defaults

All options can be customized using the setup function. Here are most of the
default options:

```lua
require("proyecto").setup {
    templates = {
        -- Template definitions. See ./config/templates/ for the definitions
    },
    licenses = {
        -- Maps license names to lists of strings
        -- See ./config/licenses/ for the license files
    }
    version_control = { -- Command list per version control system
        git = { "git", "init", "." },
        jujutsu = { "jj", "init", "." },
    },
}
```

## Add licenses

There's 2 easy ways to add new licenses:

### List of strings

You can define the lines of the license file as a list of strings:

```lua
require("proyecto").setup {
    licenses = {
        new_license_name = {
            "First line of the license file",
            "Second lne..."
        }
    }
}
```

### Loading an existing file

If you have a file with the license text, you can load it into the plugin like this:

```lua
require("proyecto").setup {
    licenses = {
        new_license_name = vim.fn.readfile("") --The string must be the absolute path to the file
    }
}
```

## Built-in templates

A template is a regular Lua table that defines information about a project.
A template looks like this:

```lua
require("proyecto").setup {
    templates = {
        some_template_name = {
            file_structure = {
                --File system items
            },
            --Name of the version control to use.
            --Any of the keys found under the `version_control` option is valid
            version_control_name = "",
        }
    }
}
```

The `file_structure` option is a list of file system items.

A file system item is just a file or directory, represented as a Lua table like
this:

| Option Name | Expected Value Type       | Behavior                                                         |
| ----------- | ------------------------- | ---------------------------------------------------------------- |
| `type`      | `"directory"` \| `"file"` | Wether the item is a file or directory                           |
| `name`      | string                    | Name of the file/directory                                       |
| `content`   | str[] \| item[]           | A list of strings if `type` is "file", a list of items otherwise |

With the goal of having sane defaults, the following options have the same
default value across all templates:

```lua
{
    version_control_name = "git",
}
```
