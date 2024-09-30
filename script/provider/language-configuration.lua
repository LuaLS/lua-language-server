local config = require 'config'
local ws = require 'workspace'
local util = require 'utility'

local function getConfig(key)
    local scope = ws.getFirstScope()
    local uri = scope.uri
    return config.get(uri, key)
end

-- Enumeration of commonly encountered syntax token types.
local SyntaxTokenType = {
    Other = 0, -- Everything except tokens that are part of comments, string literals and regular expressions.
    Comment = 1, -- A comment.
    String = 2, -- A string literal.
    RegEx = 3 -- A regular expression.
}

-- Describes what to do with the indentation when pressing Enter.
local IndentAction = {
    None = 0, -- Insert new line and copy the previous line's indentation.
    Indent = 1, -- Insert new line and indent once (relative to the previous line's indentation).
    IndentOutdent = 2, -- Insert two new lines: the first one indented which will hold the cursor, and the second one at the same indentation level.
    Outdent = 3 -- Insert new line and outdent once (relative to the previous line's indentation).
}

local languageConfiguration = {
    id = 'lua',
    configuration = {
        autoClosingPairs = {
            { open = "{", close = "}" },
            { open = "[", close = "]" },
            { open = "(", close = ")" },
            { open = "'", close = "'", notIn = { SyntaxTokenType.String } },
            { open = '"', close = '"', notIn = { SyntaxTokenType.String } },
            { open = "[=", close = "=]" },
            { open = "[==", close = "==]" },
            { open = "[===", close = "===]" },
            { open = "[====", close = "====]" },
            { open = "[=====", close = "=====]" },
        },
        onEnterRules = {
            {
                beforeText = [[\)\s*$]],
                afterText = [[^\s*end\b]],
                action = {
                    indentAction = IndentAction.IndentOutdent,
                }
            },
            {
                beforeText = [[\b()\s*$]],
                afterText = [[^\s*end\b]],
                action = {
                    indentAction = IndentAction.IndentOutdent,
                }
            },
            {
                beforeText = [[\b(repeat)\s*$]],
                afterText = [[^\s*until\b]],
                action = {
                    indentAction = IndentAction.IndentOutdent,
                }
            },
        },
    },
}

local completeAnnotation = {
    configuration = {
        onEnterRules = {
            {
                beforeText = [[^\s*---@]],
                action = {
                    indentAction = IndentAction.None,
                    appendText = "---@"
                }
            },
            {
                beforeText = [[^\s*--- @]],
                action = {
                    indentAction = IndentAction.None,
                    appendText = "--- @"
                }
            },
            {
                beforeText = [[^\s*--- ]],
                action = {
                    indentAction = IndentAction.None,
                    appendText = "--- "
                }
            },
            {
                beforeText = [[^\s*---]],
                action = {
                    indentAction = IndentAction.None,
                    appendText = "---"
                }
            },
        },
    },
}

local M = {}

function M.make()
    local result = languageConfiguration
    if getConfig 'Lua.language.completeAnnotation' then
        result = util.mergeStruct(result, completeAnnotation)
    end
    return result
end

return M
