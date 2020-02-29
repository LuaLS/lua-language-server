local util = require 'utility'
local DiagnosticDefaultSeverity = require 'define.DiagnosticDefaultSeverity'

local m = {}
m.version = 0

local function Boolean(v)
    if type(v) == 'boolean' then
        return true, v
    end
    return false
end

local function Integer(v)
    if type(v) == 'number' then
        return true, math.floor(v)
    end
    return false
end

local function String(v)
    return true, tostring(v)
end

local function Str2Hash(sep)
    return function (v)
        if type(v) == 'string' then
            local t = {}
            for s in v:gmatch('[^'..sep..']+') do
                t[s] = true
            end
            return true, t
        end
        if type(v) == 'table' then
            local t = {}
            for _, s in ipairs(v) do
                if type(s) == 'string' then
                    t[s] = true
                end
            end
            return true, t
        end
        return false
    end
end

local function Array(checker)
    return function (tbl)
        if type(tbl) ~= 'table' then
            return false
        end
        local t = {}
        for _, v in ipairs(tbl) do
            local ok, result = checker(v)
            if ok then
                t[#t+1] = result
            end
        end
        return true, t
    end
end

local function Hash(keyChecker, valueChecker)
    return function (tbl)
        if type(tbl) ~= 'table' then
            return false
        end
        local t = {}
        for k, v in pairs(tbl) do
            local ok1, key = keyChecker(k)
            local ok2, value = valueChecker(v)
            if ok1 and ok2 then
                t[key] = value
            end
        end
        if not next(t) then
            return false
        end
        return true, t
    end
end

local function Or(...)
    local checkers = {...}
    return function (obj)
        for _, checker in ipairs(checkers) do
            local suc, res = checker(obj)
            if suc then
                return true, res
            end
        end
        return false
    end
end

local ConfigTemplate = {
    runtime = {
        version         = {'Lua 5.3', String},
        library         = {{},        Str2Hash ';'},
        path            = {{
                                "?.lua",
                                "?/init.lua",
                                "?/?.lua"
                            },        Array(String)},
    },
    diagnostics = {
        enable          = {true, Boolean},
        globals         = {{},   Str2Hash ';'},
        disable         = {{},   Str2Hash ';'},
        severity        = {
            util.deepCopy(DiagnosticDefaultSeverity),
            Hash(String, String),
        },
    },
    workspace = {
        ignoreDir       = {{},      Str2Hash ';'},
        ignoreSubmodules= {true,    Boolean},
        useGitIgnore    = {true,    Boolean},
        maxPreload      = {300,     Integer},
        preloadFileSize = {100,     Integer},
        library         = {{},      Hash(
                                        String,
                                        Or(Boolean, Array(String))
                                    )}
    },
    completion = {
        enable          = {true,   Boolean},
        callSnippet     = {'Both', String},
        keywordSnippet  = {'Both', String},
    },
    plugin = {
        enable          = {false, Boolean},
        path            = {'.vscode/lua-plugin/*.lua', String},
    },
}

local OtherTemplate = {
    associations = {{}, Hash(String, String)},
    exclude =      {{}, Hash(String, Boolean)},
}

local function init()
    if m.config then
        return
    end

    m.config = {}
    for c, t in pairs(ConfigTemplate) do
        m.config[c] = {}
        for k, info in pairs(t) do
            m.config[c][k] = info[1]
        end
    end

    m.other = {}
    for k, info in pairs(OtherTemplate) do
        m.other[k] = info[1]
    end
end

function m.setConfig(config, other)
    m.version = m.version + 1
    xpcall(function ()
        for c, t in pairs(config) do
            for k, v in pairs(t) do
                local region = ConfigTemplate[c]
                if region then
                    local info = region[k]
                    local suc, v = info[2](v)
                    if suc then
                        m.config[c][k] = v
                    else
                        m.config[c][k] = info[1]
                    end
                end
            end
        end
        for k, v in pairs(other) do
            local info = OtherTemplate[k]
            local suc, v = info[2](v)
            if suc then
                m.other[k] = v
            else
                m.other[k] = info[1]
            end
        end
        log.debug('Config update: ', util.dump(m.config), util.dump(m.other))
    end, log.error)
end

init()

return m
