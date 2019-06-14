local json = require 'json'
local diagDefault = require 'constant.DiagnosticDefaultSeverity'

local VERSION = "0.9.12"

local package = {
    name = "lua",
    displayName = "Lua",
    description = "Lua Language Server coded by Lua",
    author = "sumneko",
    icon = "images/logo.png",
    license = "MIT",
    repository = {
        type = "git",
        url = "https://github.com/sumneko/lua-language-server"
    },
    publisher = "sumneko",
    categories = {
        "Linters",
        "Programming Languages",
        "Snippets"
    },
    keywords = {
        "Lua",
        "LSP",
        "GoTo Definition",
        "IntelliSense"
    },
    engines = {
        vscode = "^1.23.0"
    },
    activationEvents = {
        "onLanguage:lua"
    },
    main = "./client/out/extension",
    contributes = {
        configuration = {
            type = "object",
            title = "Lua",
            properties = {
                ["Lua.runtime.version"] = {
                    scope = "resource",
                    type = "string",
                    default = "Lua 5.3",
                    enum = {
                        "Lua 5.1",
                        "Lua 5.2",
                        "Lua 5.3",
                        "Lua 5.4",
                        "LuaJIT"
                    },
                    description = "%config.runtime.version%"
                },
                ["Lua.runtime.path"] = {
                    scope = "resource",
                    type = "array",
                    items = "string",
                    markdownDescription = "%config.runtime.path%",
                    default = {
                        "?.lua",
                        "?/init.lua",
                        "?/?.lua"
                    }
                },
                ["Lua.diagnostics.disable"] = {
                    scope = "resource",
                    type = "array",
                    items = "string",
                    description = "%config.diagnostics.disable%"
                },
                ["Lua.diagnostics.globals"] = {
                    scope = "resource",
                    type = "array",
                    items = "string",
                    description = "%config.diagnostics.globals%"
                },
                ["Lua.diagnostics.severity"] = {
                    scope = "resource",
                    type = 'object',
                    description = "%config.diagnostics.severity%",
                    title = "severity",
                    properties = {}
                },
                ["Lua.workspace.ignoreDir"] = {
                    scope = "resource",
                    type = "array",
                    items = "string",
                    markdownDescription = "%config.workspace.ignoreDir%"
                },
                ["Lua.workspace.ignoreSubmodules"] = {
                    scope = "resource",
                    type = "boolean",
                    default = true,
                    description = "%config.workspace.ignoreSubmodules%"
                },
                ["Lua.workspace.useGitIgnore"] = {
                    scope = "resource",
                    type = "boolean",
                    default = true,
                    markdownDescription = "%config.workspace.useGitIgnore%"
                },
                ["Lua.workspace.maxPreload"] = {
                    scope = "resource",
                    type = "integer",
                    default = 300,
                    description = "%config.workspace.maxPreload%"
                },
                ["Lua.workspace.preloadFileSize"] = {
                    scope = "resource",
                    type = "integer",
                    default = 100,
                    description = "%config.workspace.preloadFileSize%"
                },
                --["Lua.workspace.library"] = {
                --    scope = 'resource',
                --    type = 'object',
                --    markdownDescription = "%config.workspace.library%"
                --}
            }
        },
        grammars = {
            {
                language = "lua",
                scopeName = "source.lua",
                path = "syntaxes/lua.tmLanguage.json"
            }
        }
    },
    scripts = {
        ["vscode:prepublish"] = "cd client && npm run update-vscode && cd .."
    },
	__metadata = {
		id = "3a15b5a7-be12-47e3-8445-88ee3eabc8b2",
		publisherDisplayName = "sumneko",
		publisherId = "fb626675-24cf-4881-8c13-b465f29bec2f",
	},
}

local DiagSeverity = package.contributes.configuration.properties["Lua.diagnostics.severity"].properties
for name, level in pairs(diagDefault) do
    DiagSeverity[name] = {
        scope = 'resource',
        type = 'string',
        default = level,
        enum = {
            'Error',
            'Warning',
            'Information',
            'Hint',
        }
    }
end

package.version = VERSION

io.save(ROOT:parent_path() / 'package.json', json.encode(package))

local libraryExample = [[
```json
"Lua.workspace.library": {
    "C:/lua": true,
    "../lib": [
        "*.txt",
        "*.lua",
        "!/temp/**/*.txt"
    ]
}
```
]]

io.save(ROOT:parent_path() / 'package.nls.json', json.encode {
    ["config.runtime.version"]            = "Lua runtime version.",
    ["config.runtime.path"]               = "`package.path`",
    ["config.diagnostics.disable"]        = "Disabled diagnostic (Use code in hover brackets).",
    ["config.diagnostics.globals"]        = "Defined global variables.",
    ["config.diagnostics.severity"]       = "Modified diagnostic severity.",
    ["config.workspace.ignoreDir"]        = "Ignored directories (Use `.gitignore` grammar).",
    ["config.workspace.ignoreSubmodules"] = "Ignore submodules.",
    ["config.workspace.useGitIgnore"]     = "Ignore files list in `.gitignore` .",
    ["config.workspace.maxPreload"]       = "Max preloaded files.",
    ["config.workspace.preloadFileSize"]  = "Skip files larger than this value (KB) when preloading.",
    ["config.workspace.library"]          = [[
加载的外部函数库。
下面这个例子表示加载`C:/lua`中的所有文件，以及加载`../lib`中的`.txt`与`.lua`文件，但不加载`../lib/temp`中的`.txt`文件。加载的文件最终会受文件关联的影响，因此需要设置`.txt`文件关联`lua`后`*.txt`才有意义。
]] .. libraryExample,
})

io.save(ROOT:parent_path() / 'package.nls.zh-cn.json', json.encode {
    ["config.runtime.version"]            = "Lua运行版本。",
    ["config.runtime.path"]               = "`package.path`",
    ["config.diagnostics.disable"]        = "禁用的诊断（使用浮框括号内的代码）。",
    ["config.diagnostics.globals"]        = "已定义的全局变量。",
    ["config.diagnostics.severity"]       = "修改诊断等级。",
    ["config.workspace.ignoreDir"]        = "忽略的目录（使用 `.gitignore` 语法）。",
    ["config.workspace.ignoreSubmodules"] = "忽略子模块。",
    ["config.workspace.useGitIgnore"]     = "忽略 `.gitignore` 中列举的文件。",
    ["config.workspace.maxPreload"]       = "最大预加载文件数。",
    ["config.workspace.preloadFileSize"]  = "预加载时跳过大小大于该值（KB）的文件。",
    ["config.workspace.library"]          = [[
加载的外部函数库。
下面这个例子表示加载`C:/lua`中的所有文件，以及加载`../lib`中的`.txt`与`.lua`文件，但不加载`../lib/temp`中的`.txt`文件。加载的文件最终会受文件关联的影响，因此需要设置`.txt`文件关联`lua`后`*.txt`才有意义。
]] .. libraryExample,
})
