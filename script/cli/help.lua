local util = require 'utility'

--- @class cli.arg
--- @field type? string|string[]
--- @field description string Description of the argument in markdown format.
--- @field example? string
--- @field default? any

--- @type table<string, cli.arg>
local args = {
    ['--help'] = {
        description = [[
            Print this message.
        ]],
    },
    ['--check'] = {
        type = 'string',
        description = [[
            Perform a "diagnosis report" where the results of the diagnosis are written to the logpath.
        ]],
        example = [[--check=C:\Users\Me\path\to\workspace]]
    },
    ['--checklevel'] = {
        type = 'string',
        description = [[
            To be used with --check. The minimum level of diagnostic that should be logged.
            Items with lower priority than the one listed here will not be written to the file.
            Options include, in order of priority:

                - Error
                - Warning
                - Information
                - Hint
        ]],
        default = 'Warning',
        example = [[--checklevel=Information]]
    },
    ['--check_format'] = {
        type = { 'json',  'pretty' },
        description = [[
            Output format for the check results.
            - 'pretty': results are displayed to stdout in a human-readable format.
            - 'json': results are written to a file in JSON format. See --check_out_path
        ]],
        default = 'pretty'
    },
    ['--version'] = {
        type = 'boolean',
        description = [[
            Get the version of the Lua language server.
            This will print it to the command line and immediately exit.
        ]],
    },
    ['--doc'] = {
        type = 'string',
        description = [[
            Generate documentation from a workspace.
            The files will be written to the documentation output path passed
            in --doc_out_path.
        ]],
        example = [[--doc=C:/Users/Me/Documents/myLuaProject/]]
    },
    ['--doc_out_path'] = {
        type = 'string',
        description = [[
            The path to output generated documentation at.
            If --doc_out_path is missing, the documentation will be written
            to the current directory.
            See --doc for more info.
        ]],
        example = [[--doc_out_path=C:/Users/Me/Documents/myLuaProjectDocumentation]]
    },
    ['--doc_update'] = {
        type = 'string',
        description = [[
            Update existing documentation files at the given path.
        ]]
    },
    ['--logpath'] = {
        type = 'string',
        description = [[
            Where the log should be written to.
        ]],
        default = './log',
        example = [[--logpath=D:/luaServer/logs]]
    },
    ['--loglevel'] = {
        type = 'string',
        description = [[
            The minimum level of logging that should appear in the logfile.
            Can be used to log more detailed info for debugging and error reporting.

            Options:

                - error
                - warn
                - info
                - debug
                - trace
        ]],
        example = [[--loglevel=trace]]
    },
    ['--metapath'] = {
        type = 'string',
        description = [[
            Where the standard Lua library definition files should be generated to.
        ]],
        default = './meta',
        example = [[--metapath=D:/sumnekoLua/metaDefintions]]
    },
    ['--locale'] = {
        type = 'string',
        description = [[
            The language to use. Defaults to en-us.
            Options can be found in locale/ .
        ]],
        example = [[--locale=zh-cn]]
    },
    ['--configpath'] = {
        type = 'string',
        description = [[
            The location of the configuration file that will be loaded.
            Can be relative to the workspace.
            When provided, config files from elsewhere (such as from VS Code) will no longer be loaded.
        ]],
        example = [[--configpath=sumnekoLuaConfig.lua]]
    },
    ['--force-accept-workspace'] = {
        type = 'boolean',
        description = [[
            Allows the use of root/home directory as the workspace.
        ]]
    },
    ['--socket'] = {
        type = 'number',
        description = [[
            Will communicate to a client over the specified TCP port instead of through stdio.
        ]],
        example = [[--socket=5050]]
    },
    ['--develop'] = {
        type = 'boolean',
        description = [[
            Enables development mode. This allows plugins to write to the logpath.
        ]]
    }
}

for nm, attrs in util.sortPairs(args) do
    if attrs.type == 'boolean' then
        print(nm)
    else
        print(nm .. "=<value>")
    end
    if attrs.description then
        local normalized_description = attrs.description:gsub("^%s+", ""):gsub("\n%s+", "\n"):gsub("%s+$", "")
        print("\n    " .. normalized_description:gsub('\n', '\n    '))
    end
    local attr_type = attrs.type
    if type(attr_type) == "table" then
        print("\n    Values: " .. table.concat(attr_type, ', '))
    end
    if attrs.default then
        print("\n    Default: " .. tostring(attrs.default))
    end
    if attrs.example then
        print("\n    Example: " .. attrs.example)
    end
    print()
end
