local template = require 'config.template'

print('[config] 测试中...')

do
    assert(template['Lua.runtime.version'].default == 'Lua 5.4')
    assert(template['Lua.runtime.version']:checker 'Lua 5.1')
    assert(not template['Lua.runtime.version']:checker 'Lua 4.0')

    assert(template['Lua.runtime.path']:checker { '?.lua' })
    assert(template['Lua.runtime.path']:loader { '?/init.lua' }[1] == '?/init.lua')

    local nss = template['Lua.runtime.nonstandardSymbol']
    assert(nss:loader { '?' }[1] == nil)
    assert(nss:loader { '?.' }[1] == '?.')
    assert(nss:loader { '//', 'continue' }[2] == 'continue')

    assert(template['Lua.runtime.builtin'].default.basic == 'default')
    assert(template['Lua.runtime.builtin']:checker { basic = 'enable' })
    assert(not template['Lua.runtime.builtin']:checker { basic = 'maybe' })

    local severity = template['Lua.diagnostics.severity']
    assert(severity:checker { ['unused-local'] = 'Error' })
    assert(not severity:checker { ['unused-local'] = 'Fatal' })
    assert(severity:loader { ['unused-local'] = 'Warning!' }['unused-local'] == 'Warning!')

    assert(template['Lua.diagnostics.groupSeverity']:checker { unused = 'Fallback' })
    assert(not template['Lua.diagnostics.groupSeverity']:checker { unused = 'Whatever' })

    assert(template['Lua.hint.enable'].default == false)
    assert(template['Lua.diagnostics.workspaceDelay'].default == 3000)
    assert(template['Lua.diagnostics.workspaceDelay']:loader(3.5) == 3)
    assert(template['files.exclude'].default['**/.git'] == true)
    assert(template['Lua.workspace.checkThirdParty']:checker 'Ask')
    assert(template['Lua.workspace.checkThirdParty']:checker(true))
    assert(template['editor.acceptSuggestionOnEnter'].default == 'on')
end

local config = ls.config.create(test.rootUri)

do
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.4')
    assert(config:get(test.fileUri, 'Lua.completion.showWord') == 'Fallback')
    assert(config:get(test.fileUri, 'Lua.workspace.ignoreDir')[1] == '.vscode')
    assert(config:get(test.fileUri, 'Lua.completion.workspaceWord') == true)
    assert(config:get(test.fileUri, 'Lua.hint.enable') == false)

    config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.1')
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.1')

    config:set(test.rootUri, 'Lua.runtime.version', 'Lua 4.0')
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.4')

    config:set(test.rootUri, 'Lua.diagnostics.workspaceDelay', 3.5)
    assert(config:get(test.fileUri, 'Lua.diagnostics.workspaceDelay') == 3)

    config:set(test.rootUri, 'Lua.runtime.nonstandardSymbol', { '?', '?.' })
    assert(config:get(test.fileUri, 'Lua.runtime.nonstandardSymbol')[1] == '?.')

    config:set(test.rootUri, 'Lua.runtime.nonstandardSymbol', nil)
    assert(#config:get(test.fileUri, 'Lua.runtime.nonstandardSymbol') == 0)

    local subUri = test.rootUri .. '/sub/file.lua'
    config:set(test.rootUri, 'Lua.completion.showWord', 'Disable')
    config:set(test.rootUri .. '/sub', 'Lua.completion.showWord', 'Enable')
    assert(config:get(subUri, 'Lua.completion.showWord') == 'Enable')
    assert(config:get(test.rootUri .. '/other.lua', 'Lua.completion.showWord') == 'Disable')

    config:set(test.rootUri .. '/sub', 'Lua.completion.showWord', 'Bad')
    assert(config:get(subUri, 'Lua.completion.showWord') == 'Fallback')

    config:set(test.rootUri, 'Lua.completion.showWord', nil)
    assert(config:get(subUri, 'Lua.completion.showWord') == 'Fallback')

    config:set(test.rootUri, 'Lua.diagnostics.workspaceDelay', nil)
    config:set(test.rootUri, 'Lua.runtime.version', nil)
end

do
    assert(test.scope:makeCompileOptions(test.fileUri) == nil)

    test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'LuaJIT')
    local options = test.scope:makeCompileOptions(test.fileUri)
    assert(options and options.version == 'Lua 5.1' and options.jit == true)
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)

    test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.3')
    options = test.scope:makeCompileOptions(test.fileUri)
    assert(options and options.version == 'Lua 5.3' and options.jit == nil)
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)

    test.scope.config:set(test.rootUri, 'Lua.runtime.unicodeName', true)
    options = test.scope:makeCompileOptions(test.fileUri)
    assert(options and options.unicodeName == true and options.version == nil)
    test.scope.config:set(test.rootUri, 'Lua.runtime.unicodeName', nil)
end

do
    config:applyClientConfig {
        runtime = {
            version = 'Lua 5.1',
            nonstandardSymbol = { '?.' },
        },
        completion = {
            showWord = 'BadValue',
        },
    }

    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.1')
    assert(config:get(test.fileUri, 'Lua.runtime.nonstandardSymbol')[1] == '?.')
    assert(config:get(test.fileUri, 'Lua.completion.showWord') == 'Fallback')

    config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.3')
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.3')

    config:applyClientConfig {
        runtime = {
            version = 'Lua 5.2',
        },
    }

    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.3')
    assert(config:get(test.fileUri, 'Lua.runtime.nonstandardSymbol')[1] == nil)

    config:applyClientConfig {
        diagnostics = {
            enable = false,
        },
    }

    assert(config:get(test.fileUri, 'Lua.diagnostics.enable') == false)
    assert(config:get(test.rootUri, 'Lua.runtime.version') == 'Lua 5.3')
end

do
    local rcUri = test.rootUri .. '/.luarc.json'

    assert(config:applyRC(rcUri, {
        runtime = {
            version = 'Lua 5.2',
        },
    }) == true)
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.2')

    assert(config:applyRC(rcUri, {
        runtime = {
            version = 'Lua 5.2',
        },
    }) == false)

    assert(config:applyRC(rcUri, {
        runtime = {
            version = 'Lua 5.3',
        },
    }) == true)

    assert(config:applyRC(rcUri, {
        diagnostics = {
            enable = false,
        },
    }) == true)
    assert(config:get(test.fileUri, 'Lua.runtime.version') == 'Lua 5.4')
    assert(config:get(test.fileUri, 'Lua.diagnostics.enable') == false)

    assert(config:removeRC(rcUri) == true)
    assert(config:get(test.fileUri, 'Lua.diagnostics.enable') == false)
    assert(config:removeRC(rcUri) == false)
end

do
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.3')
    test.scope:buildRoots({})
    local metaRoot
    for _, root in ipairs(test.scope.roots) do
        if root.kind == 'meta' then
            metaRoot = root
        end
    end
    local metaPath = metaRoot and tostring(ls.uri.decode(metaRoot.uri)) or 'no meta root'
    assert(metaRoot and ls.util.stringEndWith(metaPath, 'Lua 5.3 auto utf-8'), metaPath)
    test.scope.roots = {}
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)
end

do
    require 'language-server.capability'
    require 'language-server.capability.workspace.did-change-configuration'
    assert(ls.capability.registered['workspace/didChangeConfiguration'] ~= nil)

    local languageServer = require 'language-server'
    assert(type(languageServer.create) == 'function')
end

print('[config] 测试完毕')
