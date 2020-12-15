local fs      = require 'bee.filesystem'
local config  = require 'config'
local util    = require 'utility'
local lang    = require 'language'
local client  = require 'provider.client'
local lloader = require 'locale-loader'

local m = {}

local function getDocFormater()
    local version = config.config.runtime.version
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
        if fmt then
            return ('[%s](%s)'):format(name, lang.script(fmt, 'pdf-' .. name))
        else
            return ('`%s`'):format(name)
        end
    end):gsub('§([%.%w]+)', function (name)
        if fmt then
            return ('[§%s](%s)'):format(name, lang.script(fmt, name))
        else
            return ('`%s`'):format(name)
        end
    end)
end

local function createViewDocument(name)
    local fmt = getDocFormater()
    if not fmt then
        return nil
    end
    name = name:match '[%w_%.]+'
    return ('[%s](%s)'):format(lang.script.HOVER_VIEW_DOCUMENTS, lang.script(fmt, 'pdf-' .. name))
end

local function compileSingleMetaDoc(script, metaLang)
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
    if config.config.runtime.version == 'LuaJIT' then
        version = 5.1
        jit = true
    else
        version = tonumber(config.config.runtime.version:sub(-3))
        jit = false
    end

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
    }, { __index = _ENV })

    util.saveFile((ROOT / 'log' / 'middleScript.lua'):string(), middleScript)

    assert(load(middleScript, middleScript, 't', env))()
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
    local version = config.config.runtime.version
    local metapath = ROOT / 'meta' / config.config.runtime.meta:gsub('%$%{(.-)%}', {
        version  = version,
        language = langID,
    })
    if fs.exists(metapath) then
        --return
    end

    local metaLang = loadMetaLocale('en-US')
    if langID ~= 'en-US' then
        loadMetaLocale(langID, metaLang)
    end
    --log.debug('metaLang:', util.dump(metaLang))

    m.metaPath = metapath:string()
    m.metaPaths = {}
    fs.create_directory(metapath)
    local templateDir = ROOT / 'meta' / 'template'
    for fullpath in templateDir:list_directory() do
        local filename = fullpath:filename()
        local metaDoc = compileSingleMetaDoc(util.loadFile(fullpath:string()), metaLang)
        local filepath = metapath / filename
        util.saveFile(filepath:string(), metaDoc)
        m.metaPaths[#m.metaPaths+1] = filepath:string()
    end
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
