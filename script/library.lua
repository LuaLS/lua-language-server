local fs      = require 'bee.filesystem'
local plat    = require 'bee.platform'
local config  = require 'config'
local util    = require 'utility'
local lang    = require 'language'
local client  = require 'client'
local lloader = require 'locale-loader'
local fsu     = require 'fs-utility'
local define  = require "proto.define"
local files   = require 'files'
local await   = require 'await'
local timer   = require 'timer'
local encoder = require 'encoder'
local ws      = require 'workspace.workspace'
local scope   = require 'workspace.scope'
local inspect = require 'inspect'

local m = {}

m.metaPaths = {}

local function getDocFormater(uri)
    local version = config.get(uri, 'Lua.runtime.version')
    if client.isVSCode() then
        if version == 'Lua 5.1' then
            return 'HOVER_NATIVE_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_NATIVE_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_NATIVE_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_NATIVE_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_NATIVE_DOCUMENT_LUAJIT'
        end
    else
        if version == 'Lua 5.1' then
            return 'HOVER_DOCUMENT_LUA51'
        elseif version == 'Lua 5.2' then
            return 'HOVER_DOCUMENT_LUA52'
        elseif version == 'Lua 5.3' then
            return 'HOVER_DOCUMENT_LUA53'
        elseif version == 'Lua 5.4' then
            return 'HOVER_DOCUMENT_LUA54'
        elseif version == 'LuaJIT' then
            return 'HOVER_DOCUMENT_LUAJIT'
        end
    end
end

local function convertLink(uri, text)
    local fmt = getDocFormater(uri)
    return text:gsub('%$([%.%w]+)', function (name)
        local lastDot = ''
        if name:sub(-1) == '.' then
            name = name:sub(1, -2)
            lastDot = '.'
        end
        if fmt then
            return ('[%s](%s)'):format(name, lang.script(fmt, 'pdf-' .. name)) .. lastDot
        else
            return ('`%s`'):format(name) .. lastDot
        end
    end):gsub('§([%.%w]+)', function (name)
        local lastDot = ''
        if name:sub(-1) == '.' then
            name = name:sub(1, -2)
            lastDot = '.'
        end
        if fmt then
            return ('[§%s](%s)'):format(name, lang.script(fmt, name)) .. lastDot
        else
            return ('`%s`'):format(name) .. lastDot
        end
    end)
end

local function createViewDocument(name)
    local fmt = getDocFormater()
    if not fmt then
        return nil
    end
    name = name:match '[%w_%.]+'
    if name:sub(-1) == '.' then
        name = name:sub(1, -2)
    end
    return ('[%s](%s)'):format(lang.script.HOVER_VIEW_DOCUMENTS, lang.script(fmt, 'pdf-' .. name))
end

local function compileSingleMetaDoc(uri, script, metaLang, status)
    if not script then
        log.error('no meta?', uri)
        return nil
    end

    local middleBuf = {}
    local compileBuf = {}

    local last = 1
    for start, lua, finish in script:gmatch '()%-%-%-%#([^\n\r]*)()' do
        middleBuf[#middleBuf+1] = ('PUSH [===[%s]===]'):format(script:sub(last, start - 1))
        middleBuf[#middleBuf+1] = lua
        last = finish
    end
    middleBuf[#middleBuf+1] = ('PUSH [===[%s]===]'):format(script:sub(last))
    local middleScript = table.concat(middleBuf, '\n')
    local version, jit
    if config.get(uri, 'Lua.runtime.version') == 'LuaJIT' then
        version = 5.1
        jit = true
    else
        version = tonumber(config.get(uri, 'Lua.runtime.version'):sub(-3)) or 5.4
        jit = false
    end

    local disable = false
    local env = setmetatable({
        VERSION = version,
        JIT     = jit,
        PUSH    = function (text)
            compileBuf[#compileBuf+1] = text
        end,
        DES     = function (name)
            local des = metaLang[name]
            if not des then
                des = ('Miss locale <%s>'):format(name)
            end
            compileBuf[#compileBuf+1] = '---\n'
            for line in util.eachLine(des) do
                compileBuf[#compileBuf+1] = '---'
                compileBuf[#compileBuf+1] = convertLink(uri, line)
                compileBuf[#compileBuf+1] = '\n'
            end
            local viewDocument = createViewDocument(name)
            if viewDocument then
                compileBuf[#compileBuf+1] = '---\n---'
                compileBuf[#compileBuf+1] = viewDocument
                compileBuf[#compileBuf+1] = '\n'
            end
            compileBuf[#compileBuf+1] = '---\n'
        end,
        DESTAIL = function (name)
            local des = metaLang[name]
            if not des then
                des = ('Miss locale <%s>'):format(name)
            end
            compileBuf[#compileBuf+1] = convertLink(uri, des)
            compileBuf[#compileBuf+1] = '\n'
        end,
        ALIVE   = function (str)
            local isAlive
            for piece in str:gmatch '[^%,]+' do
                if piece:sub(1, 1) == '>' then
                    local alive = tonumber(piece:sub(2))
                    if not alive or version >= alive then
                        isAlive = true
                        break
                    end
                elseif piece:sub(1, 1) == '<' then
                    local alive = tonumber(piece:sub(2))
                    if not alive or version <= alive then
                        isAlive = true
                        break
                    end
                else
                    local alive = tonumber(piece)
                    if not alive or version == alive then
                        isAlive = true
                        break
                    end
                end
            end
            if not isAlive then
                compileBuf[#compileBuf+1] = '---@deprecated\n'
            end
        end,
        DISABLE = function ()
            disable = true
        end,
    }, { __index = _ENV })

    util.saveFile((ROOT / 'log' / 'middleScript.lua'):string(), middleScript)

    local suc = xpcall(function ()
        assert(load(middleScript, middleScript, 't', env))()
    end, log.error)
    if not suc then
        log.debug('MiddleScript:\n', middleScript)
    end
    if disable and status == 'default' then
        return nil
    end
    return table.concat(compileBuf)
end

local function loadMetaLocale(langID, result)
    result = result or {}
    local path = (ROOT / 'locale' / langID / 'meta.lua'):string()
    local localeContent = util.loadFile(path)
    if localeContent then
        xpcall(lloader, log.error, localeContent, path, result)
    end
    return result
end

local function initBuiltIn(uri)
    log.info('Init builtin library at:', uri)
    local scp      = scope.getScope(uri)
    local langID   = lang.id
    local version  = config.get(uri, 'Lua.runtime.version')
    local encoding = config.get(uri, 'Lua.runtime.fileEncoding')
    local metaPath = fs.path(METAPATH) / config.get(uri, 'Lua.runtime.meta'):gsub('%$%{(.-)%}', {
        version  = version,
        language = langID,
        encoding = encoding,
    })

    local metaLang = loadMetaLocale('en-US')
    if langID ~= 'en-US' then
        loadMetaLocale(langID, metaLang)
    end

    if scp:get('metaPath') == metaPath:string() then
        log.debug('Has meta path, skip:', metaPath:string())
        return
    end
    scp:set('metaPath', metaPath:string())
    local suc = xpcall(function ()
        if not fs.exists(metaPath) then
            fs.create_directories(metaPath)
        end
    end, log.error)
    if not suc then
        log.warn('Init builtin failed.')
        return
    end
    local out = fsu.dummyFS()
    local templateDir = ROOT / 'meta' / 'template'
    for libName, status in pairs(define.BuiltIn) do
        status = config.get(uri, 'Lua.runtime.builtin')[libName] or status
        log.debug('Builtin status:', libName, status)
        if status == 'disable' then
            goto CONTINUE
        end
        libName = libName .. '.lua'
        local libPath = templateDir / libName
        local metaDoc = compileSingleMetaDoc(uri, fsu.loadFile(libPath), metaLang, status)
        if metaDoc then
            metaDoc = encoder.encode(encoding, metaDoc, 'auto')
            out:saveFile(libName, metaDoc)
            local outputPath = metaPath / libName
            m.metaPaths[outputPath:string()] = true
            log.debug('Meta path:', outputPath:string())
        end
        ::CONTINUE::
    end
    local result = fsu.fileSync(out, metaPath)
    if #result.err > 0 then
        log.warn('File sync error:', inspect(result))
    end
end

local function loadSingle3rdConfig(libraryDir)
    local configText = fsu.loadFile(libraryDir / 'config.lua')
    if not configText then
        return nil
    end

    local env = setmetatable({}, { __index = _G })
    assert(load(configText, '@' .. libraryDir:string(), 't', env))()

    local cfg = {}

    cfg.path = libraryDir:filename():string()
    cfg.name = cfg.name or cfg.path

    if fs.exists(libraryDir / 'plugin.lua') then
        cfg.plugin = true
    end

    for k, v in pairs(env) do
        cfg[k] = v
    end

    if cfg.words then
        for i, word in ipairs(cfg.words) do
            cfg.words[i] = '()' .. word .. '()'
        end
    end
    if cfg.files then
        for i, filename in ipairs(cfg.files) do
            if plat.OS == 'Windows' then
                filename = filename:gsub('/', '\\')
            else
                filename = filename:gsub('\\', '/')
            end
            cfg.files[i] = '()' .. filename .. '()'
        end
    end

    return cfg
end

local innerThirdDir = ROOT / 'meta' / '3rd'

local function load3rdConfigInDir(dir, configs, inner)
    if not fs.is_directory(dir) then
        return
    end
    for libraryDir in fs.pairs(dir) do
        local suc, res = xpcall(loadSingle3rdConfig, log.error, libraryDir)
        if suc and res then
            if inner then
                res.dirname = ('${3rd}/%s'):format(res.path)
            else
                res.dirname = ('%s/%s'):format(dir:string(), res.path)
            end
            configs[#configs+1] = res
        end
    end
end

local function load3rdConfig(uri)
    local configs = {}
    load3rdConfigInDir(innerThirdDir, configs, true)
    local thirdDirs = config.get(uri, 'Lua.workspace.userThirdParty')
    for _, thirdDir in ipairs(thirdDirs) do
        load3rdConfigInDir(fs.path(thirdDir), configs)
    end
    return configs
end

local function apply3rd(uri, cfg, onlyMemory)
    local changes = {}
    if cfg.configs then
        for _, change in ipairs(cfg.configs) do
            changes[#changes+1] = {
                key    = change.key,
                action = change.action,
                prop   = change.prop,
                value  = change.value,
                uri    = uri,
            }
        end
    end

    if cfg.plugin then
        changes[#changes+1] = {
            key    = 'Lua.runtime.plugin',
            action = 'set',
            value  = ('%s/plugin.lua'):format(cfg.dirname),
            uri    = uri,
        }
    end

    changes[#changes+1] = {
        key    = 'Lua.workspace.library',
        action = 'add',
        value  = ('%s/library'):format(cfg.dirname),
        uri    = uri,
    }

    client.setConfig(changes, onlyMemory)
end

local hasAsked
---@async
local function askFor3rd(uri, cfg)
    if hasAsked then
        return nil
    end
    hasAsked = true
    local yes1 = lang.script.WINDOW_APPLY_WHIT_SETTING
    local yes2 = lang.script.WINDOW_APPLY_WHITOUT_SETTING
    local no   = lang.script.WINDOW_DONT_SHOW_AGAIN
    local result = client.awaitRequestMessage('Info'
        , lang.script('WINDOW_ASK_APPLY_LIBRARY', cfg.name)
        , {yes1, yes2, no}
    )
    if not result then
        return nil
    end
    if result == yes1 then
        apply3rd(uri, cfg, false)
        client.setConfig({
            {
                key    = 'Lua.workspace.checkThirdParty',
                action = 'set',
                value  = false,
                uri    = uri,
            },
        }, false)
    elseif result == yes2 then
        apply3rd(uri, cfg, true)
        client.setConfig({
            {
                key    = 'Lua.workspace.checkThirdParty',
                action = 'set',
                value  = false,
                uri    = uri,
            },
        }, true)
    end
end

---@param a string
---@param b string
---@return boolean
local function wholeMatch(a, b)
    local pos1, pos2 = a:match(b)
    if not pos1 then
        return false
    end
    local left  = a:sub(pos1 - 1, pos1 - 1)
    local right = a:sub(pos2, pos2)
    if left:match '[%w_]'
    or right:match '[%w_]' then
        return false
    end
    return true
end

local function check3rdByWords(uri, text, configs)
    if hasAsked then
        return
    end
    await.call(function () ---@async
        for _, cfg in ipairs(configs) do
            if cfg.words then
                for _, word in ipairs(cfg.words) do
                    await.delay()
                    if wholeMatch(text, word) then
                        askFor3rd(uri, cfg)
                        return
                    end
                end
            end
        end
    end)
end

local function check3rdByFileName(uri, configs)
    if hasAsked then
        return
    end
    local path = ws.getRelativePath(uri)
    if not path then
        return
    end
    await.call(function () ---@async
        for _, cfg in ipairs(configs) do
            if cfg.files then
                for _, filename in ipairs(cfg.files) do
                    await.delay()
                    if wholeMatch(path, filename) then
                        askFor3rd(uri, cfg)
                        return
                    end
                end
            end
        end
    end)
end

local lastCheckedUri = {}
local function checkedUri(uri)
    if  lastCheckedUri[uri]
    and timer.clock() - lastCheckedUri[uri] < 5 then
        return false
    end
    lastCheckedUri[uri] = timer.clock()
    return true
end

local thirdConfigs
local function check3rd(uri)
    if hasAsked then
        return
    end
    if not config.get(uri, 'Lua.workspace.checkThirdParty') then
        return
    end
    if thirdConfigs == nil then
        thirdConfigs = load3rdConfig(uri) or false
    end
    if not thirdConfigs then
        return
    end
    if checkedUri(uri) then
        if files.isLua(uri) then
            local text = files.getText(uri)
            if text then
                check3rdByWords(uri, text, thirdConfigs)
            end
        end
        check3rdByFileName(uri, thirdConfigs)
    end
end

config.watch(function (uri, key, value, oldValue)
    if key:find '^Lua.runtime' then
        initBuiltIn(uri)
    end
end)

files.watch(function (ev, uri)
    if ev == 'update'
    or ev == 'dll' then
        check3rd(uri)
    end
end)

function m.init()
    initBuiltIn(nil)
    for _, scp in ipairs(ws.folders) do
        initBuiltIn(scp.uri)
    end
end

return m
