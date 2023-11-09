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
local encoder = require 'encoder'
local ws      = require 'workspace.workspace'
local scope   = require 'workspace.scope'
local inspect = require 'inspect'
local jsonb   = require 'json-beautify'
local jsonc   = require 'jsonc'

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
    return text:gsub('%$([%.%w_%:]+)', function (name)
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
    name = name:match '[%w_%.%:]+'
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
    local text = table.concat(compileBuf)
    if disable and status == 'default' then
        return text, false
    end
    if status == 'disable' then
        return text, false
    end
    return text, true
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
    ---@type fs.path
    local metaPath = fs.path(METAPATH) / config.get(uri, 'Lua.runtime.meta'):gsub('%$%{(.-)%}', {
        version  = version,
        language = langID,
        encoding = encoding,
    })

    local metaLang = loadMetaLocale('en-US')
    if langID ~= 'en-US' then
        loadMetaLocale(langID, metaLang)
    end

    local metaPaths = {}
    scp:set('metaPaths', metaPaths)
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

        ---@type fs.path
        local libPath = templateDir / (libName .. '.lua')
        local metaDoc, include = compileSingleMetaDoc(uri, fsu.loadFile(libPath), metaLang, status)
        if metaDoc then
            metaDoc = encoder.encode(encoding, metaDoc, 'auto')

            local outputLibName = libName:gsub('%.', '/') .. '.lua'
            if outputLibName ~= libName then
                out:createDirectories(fs.path(outputLibName):parent_path())
            end

            local ok, err = out:saveFile(outputLibName, metaDoc)
            if not ok then
                log.debug("Save Meta File Failed:", err)
                goto CONTINUE
            end

            local outputPath = metaPath / outputLibName
            m.metaPaths[outputPath:string()] = true
            log.debug('Meta path:', outputPath:string())

            if include then
                metaPaths[#metaPaths+1] = outputPath:string()
            end
        end
        ::CONTINUE::
    end
    local result = fsu.fileSync(out, metaPath)
    if #result.err > 0 then
        log.warn('File sync error:', inspect(result))
    end
end

---@param libraryDir fs.path
---@return table?
local function loadSingle3rdConfigFromJson(libraryDir)
    local path = libraryDir / 'config.json'
    local configText = fsu.loadFile(path)
    if not configText then
        return nil
    end

    local suc, cfg = xpcall(jsonc.decode_jsonc, function (err)
        log.error('Decode config.json failed at:', libraryDir:string(), err)
    end, configText)
    if not suc then
        return nil
    end

    if type(cfg) ~= 'table' then
        log.error('config.json must be an object:', libraryDir:string())
        return nil
    end

    return cfg
end

---@param libraryDir fs.path
---@return table?
local function loadSingle3rdConfigFromLua(libraryDir)
    local path = libraryDir / 'config.lua'
    local configText = fsu.loadFile(path)
    if not configText then
        return nil
    end

    local env = setmetatable({}, { __index = _G })
    local f, err = load(configText, '@' .. libraryDir:string(), 't', env)
    if not f then
        log.error('Load config.lua failed at:', libraryDir:string(), err)
        return nil
    end

    local suc = xpcall(f, function (err)
        log.error('Load config.lua failed at:', libraryDir:string(), err)
    end)

    if not suc then
        return nil
    end

    local cfg = {}
    for k, v in pairs(env) do
        cfg[k] = v
    end

    return cfg
end

---@param libraryDir fs.path
local function loadSingle3rdConfig(libraryDir)
    local cfg = loadSingle3rdConfigFromJson(libraryDir)
    if not cfg then
        cfg = loadSingle3rdConfigFromLua(libraryDir)
        if not cfg then
            return
        end
        local jsonbuf = jsonb.beautify(cfg)
        client.requestMessage('Info', lang.script.WINDOW_CONFIG_LUA_DEPRECATED, {
            lang.script.WINDOW_CONVERT_CONFIG_LUA,
        }, function (action, index)
            if index == 1 and jsonbuf then
                fsu.saveFile(libraryDir / 'config.json', jsonbuf)
                fsu.fileRemove(libraryDir / 'config.lua')
            end
        end)
    end

    cfg.path = libraryDir:filename():string()
    cfg.name = cfg.name or cfg.path

    if fs.exists(libraryDir / 'plugin.lua') then
        cfg.plugin = true
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
    local scp = scope.getScope(uri)
    local configs = scp:get 'thirdConfigsCache'
    if configs then
        return configs
    end
    configs = {}
    scp:set('thirdConfigsCache', configs)
    load3rdConfigInDir(innerThirdDir, configs, true)
    local thirdDirs = config.get(uri, 'Lua.workspace.userThirdParty')
    for _, thirdDir in ipairs(thirdDirs) do
        load3rdConfigInDir(fs.path(thirdDir), configs)
    end
    return configs
end

local function apply3rd(uri, cfg, onlyMemory)
    local changes = {}
    if cfg.settings then
        for key, value in pairs(cfg.settings) do
            if type(value) == 'table' then
                if #value == 0 then
                    for k, v in pairs(value) do
                        changes[#changes+1] = {
                            key    = key,
                            action = 'prop',
                            prop   = k,
                            value  = v,
                            uri    = uri,
                        }
                    end
                else
                    for _, v in ipairs(value) do
                        changes[#changes+1] = {
                            key    = key,
                            action = 'add',
                            value  = v,
                            uri    = uri,
                        }
                    end
                end
            else
                changes[#changes+1] = {
                    key    = key,
                    action = 'set',
                    value  = value,
                    uri    = uri,
                }
            end
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

local hasAsked = {}
---@async
local function askFor3rd(uri, cfg, checkThirdParty)
    if hasAsked[cfg.name] then
        return nil
    end

    if checkThirdParty == 'Apply' then
        apply3rd(uri, cfg, false)
    elseif checkThirdParty == 'ApplyInMemory' then
        apply3rd(uri, cfg, true)
    elseif checkThirdParty == 'Disable' then
        return nil
    elseif checkThirdParty == 'Ask' then
        hasAsked[cfg.name] = true
        local applyAndSetConfig = lang.script.WINDOW_APPLY_WHIT_SETTING
        local applyInMemory = lang.script.WINDOW_APPLY_WHITOUT_SETTING
        local dontShowAgain   = lang.script.WINDOW_DONT_SHOW_AGAIN
        local result = client.awaitRequestMessage('Info'
            , lang.script('WINDOW_ASK_APPLY_LIBRARY', cfg.name)
            , {applyAndSetConfig, applyInMemory, dontShowAgain}
        )
        if not result then
            -- "If none got selected"
            -- See: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#window_showMessageRequest
            return nil
        end
        if result == applyAndSetConfig then
            apply3rd(uri, cfg, false)
        elseif result == applyInMemory then
            apply3rd(uri, cfg, true)
        else
            client.setConfig({
                {
                    key    = 'Lua.workspace.checkThirdParty',
                    action = 'set',
                    value  = 'Disable',
                    uri    = uri,
                },
            }, false)
        end
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

local function check3rdByWords(uri, configs, checkThirdParty)
    if not files.isLua(uri) then
        return
    end
    local id = 'check3rdByWords:' .. uri
    await.close(id)
    await.call(function () ---@async
        await.sleep(0.1)
        local text = files.getText(uri)
        if not text then
            return
        end
        for _, cfg in ipairs(configs) do
            if not cfg.words then
                goto CONTINUE
            end
            if hasAsked[cfg.name] then
                goto CONTINUE
            end
            local library = ('%s/library'):format(cfg.dirname)
            if util.arrayHas(config.get(uri, 'Lua.workspace.library'), library) then
                goto CONTINUE
            end
            for _, word in ipairs(cfg.words) do
                await.delay()
                if wholeMatch(text, word) then
                    log.info('Found 3rd library by word: ', word, uri, library, inspect(config.get(uri, 'Lua.workspace.library')))
                    ---@async
                    await.call(function ()
                        askFor3rd(uri, cfg, checkThirdParty)
                    end)
                    return
                end
            end
            ::CONTINUE::
        end
    end, id)
end

local function check3rdByFileName(uri, configs, checkThirdParty)
    local path = ws.getRelativePath(uri)
    if not path then
        return
    end
    local id = 'check3rdByFileName:' .. uri
    await.close(id)
    await.call(function () ---@async
        await.sleep(0.1)
        for _, cfg in ipairs(configs) do
            if not cfg.files then
                goto CONTINUE
            end
            if hasAsked[cfg.name] then
                goto CONTINUE
            end
            local library = ('%s/library'):format(cfg.dirname)
            if util.arrayHas(config.get(uri, 'Lua.workspace.library'), library) then
                goto CONTINUE
            end
            for _, filename in ipairs(cfg.files) do
                await.delay()
                if wholeMatch(path, filename) then
                    log.info('Found 3rd library by filename: ', filename, uri, library, inspect(config.get(uri, 'Lua.workspace.library')))
                    ---@async
                    await.call(function ()
                        askFor3rd(uri, cfg, checkThirdParty)
                    end)
                    return
                end
            end
            ::CONTINUE::
        end
    end, id)
end

---@async
local function check3rd(uri)
    if ws.isIgnored(uri) then
        return
    end
    local checkThirdParty = config.get(uri, 'Lua.workspace.checkThirdParty')
    -- Backwards compatability: `checkThirdParty` used to be a boolean.
    if not checkThirdParty or checkThirdParty == 'Disable' then
        return
    elseif checkThirdParty == true then
        checkThirdParty = 'Ask'
    end
    local scp = scope.getScope(uri)
    if not scp:get 'canCheckThirdParty' then
        return
    end
    local thirdConfigs = load3rdConfig(uri) or false
    if not thirdConfigs then
        return
    end
    check3rdByWords(uri, thirdConfigs, checkThirdParty)
    check3rdByFileName(uri, thirdConfigs, checkThirdParty)
end

local function check3rdOfWorkspace(suri)
    local scp = scope.getScope(suri)
    scp:set('thirdConfigsCache', nil)
    scp:set('canCheckThirdParty', true)
    local id = 'check3rdOfWorkspace:' .. scp:getName()
    await.close(id)
    ---@async
    await.call(function ()
        ws.awaitReady(suri)
        for uri in files.eachFile(suri) do
            check3rd(uri)
        end
        for uri in files.eachDll() do
            check3rd(uri)
        end
    end, id)
end

config.watch(function (uri, key, value, oldValue)
    if key:find '^Lua.runtime' then
        initBuiltIn(uri)
    end
    if key == 'Lua.workspace.checkThirdParty'
    or key == 'Lua.workspace.userThirdParty'
    or key == '' then
        check3rdOfWorkspace(uri)
    end
end)

---@async
files.watch(function (ev, uri)
    if ev == 'update'
    or ev == 'dll' then
        await.sleep(1)
        check3rd(uri)
    end
end)

ws.watch(function (ev, uri)
    if ev == 'startReload' then
        initBuiltIn(uri)
    end
end)

return m
