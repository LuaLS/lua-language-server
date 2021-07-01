local fs      = require 'bee.filesystem'
local config  = require 'config'
local util    = require 'utility'
local lang    = require 'language'
local client  = require 'provider.client'
local lloader = require 'locale-loader'
local fsu     = require 'fs-utility'
local define  = require "proto.define"

local m = {}

local function getDocFormater()
    local version = config.get 'Lua.runtime.version'
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

local function convertLink(text)
    local fmt = getDocFormater()
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

local function compileSingleMetaDoc(script, metaLang, status)
    if not script then
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
    if config.get 'Lua.runtime.version' == 'LuaJIT' then
        version = 5.1
        jit = true
    else
        version = tonumber(config.get 'Lua.runtime.version':sub(-3))
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
                compileBuf[#compileBuf+1] = convertLink(line)
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
            compileBuf[#compileBuf+1] = convertLink(des)
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

local function compileMetaDoc()
    local langID  = lang.id
    local version = config.get 'Lua.runtime.version'
    local metaPath = fs.path(METAPATH) / config.get 'Lua.runtime.meta':gsub('%$%{(.-)%}', {
        version  = version,
        language = langID,
    })

    local metaLang = loadMetaLocale('en-US')
    if langID ~= 'en-US' then
        loadMetaLocale(langID, metaLang)
    end
    --log.debug('metaLang:', util.dump(metaLang))

    m.metaPath = metaPath:string()
    m.metaPaths = {}
    fs.create_directories(metaPath)
    local out = fsu.dummyFS()
    local templateDir = ROOT / 'meta' / 'template'
    for libName, status in pairs(define.BuiltIn) do
        status = config.get 'Lua.runtime.builtin'[libName] or status
        if status == 'disable' then
            goto CONTINUE
        end
        libName = libName .. '.lua'
        local libPath = templateDir / libName
        local metaDoc = compileSingleMetaDoc(fsu.loadFile(libPath), metaLang, status)
        if metaDoc then
            local outPath = metaPath / libName
            out:saveFile(libName, metaDoc)
            m.metaPaths[#m.metaPaths+1] = outPath:string()
        end
        ::CONTINUE::
    end
    fsu.fileSync(out, metaPath)
end

local function initFromMetaDoc()
    compileMetaDoc()
end

local function init()
    initFromMetaDoc()
end

function m.init()
    init()
end

return m
