local lclient  = require 'lclient'
local util     = require 'utility'
local ws       = require 'workspace'
local jsonc    = require 'jsonc'
local jsonb    = require 'json-beautify'
local client   = require 'client'
local provider = require 'provider'
local json     = require 'json'

local configPath = LOGPATH .. '/modify-luarc.json'

---@async
lclient():start(function (languageClient)
    languageClient:registerFakers()

    CONFIGPATH = configPath

    languageClient:initialize()

    ws.awaitReady()

    -------------------------------

    util.saveFile(configPath, jsonb.beautify(json.createEmptyObject()))

    provider.updateConfig()

    client.setConfig({
        {
            action = 'set',
            key    = 'Lua.runtime.version',
            value  = 'LuaJIT',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.runtime.version'] = 'LuaJIT',
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['Lua.runtime.version'] = json.null,
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'set',
            key    = 'Lua.runtime.version',
            value  = 'LuaJIT',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.runtime.version'] = 'LuaJIT',
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify(json.createEmptyObject()))

    provider.updateConfig()

    client.setConfig({
        {
            action = 'add',
            key    = 'Lua.diagnostics.disable',
            value  = 'undefined-global',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.diagnostics.disable'] = {
            'undefined-global',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['Lua.diagnostics.disable'] = {}
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'add',
            key    = 'Lua.diagnostics.disable',
            value  = 'undefined-global',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.diagnostics.disable'] = {
            'undefined-global',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['Lua.diagnostics.disable'] = {
            'unused-local'
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'add',
            key    = 'Lua.diagnostics.disable',
            value  = 'undefined-global',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.diagnostics.disable'] = {
            'unused-local',
            'undefined-global',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify(json.createEmptyObject()))

    provider.updateConfig()

    client.setConfig({
        {
            action = 'prop',
            key    = 'Lua.runtime.special',
            prop   = 'include',
            value  = 'require',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.runtime.special'] = {
            ['include'] = 'require',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['Lua.runtime.special'] = json.createEmptyObject()
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'prop',
            key    = 'Lua.runtime.special',
            prop   = 'include',
            value  = 'require',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.runtime.special'] = {
            ['include'] = 'require',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['Lua.runtime.special'] = {
            ['import'] = 'require',
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'prop',
            key    = 'Lua.runtime.special',
            prop   = 'include',
            value  = 'require',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['Lua.runtime.special'] = {
            ['import']  = 'require',
            ['include'] = 'require',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        ['runtime.version'] = json.null,
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'set',
            key    = 'Lua.runtime.version',
            value  = 'LuaJIT',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        ['runtime.version'] = 'LuaJIT',
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        Lua = {
            runtime = {
                version = json.null,
            }
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'set',
            key    = 'Lua.runtime.version',
            value  = 'LuaJIT',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            }
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        runtime = {
            version = json.null,
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'set',
            key    = 'Lua.runtime.version',
            value  = 'LuaJIT',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        runtime = {
            version = 'LuaJIT',
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        diagnostics = {
            disable = {
                'unused-local',
            }
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'add',
            key    = 'Lua.diagnostics.disable',
            value  = 'undefined-global',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        diagnostics = {
            disable = {
                'unused-local',
                'undefined-global',
            }
        }
    }))

    -------------------------------

    util.saveFile(configPath, jsonb.beautify {
        runtime = {
            special = {
                import = 'require',
            }
        }
    })

    provider.updateConfig()

    client.setConfig({
        {
            action = 'prop',
            key    = 'Lua.runtime.special',
            prop   = 'include',
            value  = 'require',
        }
    })

    assert(util.equal(jsonc.decode_jsonc(util.loadFile(configPath)), {
        runtime = {
            special = {
                import  = 'require',
                include = 'require',
            }
        }
    }))
end)
