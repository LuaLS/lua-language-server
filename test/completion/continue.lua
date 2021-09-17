local define = require 'proto.define'
local config = require 'config'

config.set('Lua.completion.callSnippet',    'Disable')
config.set('Lua.completion.keywordSnippet', 'Disable')
config.set('Lua.completion.workspaceWord',  false)

ContinueTyping = true

TEST [[
local zabcde
za<??>
]]
{
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Variable,
    }
}

TEST [[
-- zabcde
io.z<??>
]]
{
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Text,
    }
}


TEST [[
-- provider
pro<??>
]]
{
    {
        label = 'provider',
        kind = define.CompletionItemKind.Text,
    }
}

TEST [[
---@param n '"abcdefg"'
local function f(n) end

f 'abc<??>'
]]
{
    {
        label    = "'abcdefg'",
        kind     = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    }
}

TEST [[
---@type '"abcdefg"'
local t

if t == 'abc<??>'
]]
{
    {
        label    = "'abcdefg'",
        kind     = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    }
}

ContinueTyping = false
