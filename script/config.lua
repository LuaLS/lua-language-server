local DiagnosticDefaultSeverity = require 'constant.DiagnosticDefaultSeverity'

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
            table.deepCopy(DiagnosticDefaultSeverity),
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

local Config, Other

local function init()
    if Config then
        return
    end

    Config = {}
    for c, t in pairs(ConfigTemplate) do
        Config[c] = {}
        for k, info in pairs(t) do
            Config[c][k] = info[1]
        end
    end

    Other = {}
    for k, info in pairs(OtherTemplate) do
        Other[k] = info[1]
    end
end

local function setConfig(self, config, other)
    xpcall(function ()
        for c, t in pairs(config) do
            for k, v in pairs(t) do
                local region = ConfigTemplate[c]
                if region then
                    local info = region[k]
                    local suc, v = info[2](v)
                    if suc then
                        Config[c][k] = v
                    else
                        Config[c][k] = info[1]
                    end
                end
            end
        end
        for k, v in pairs(other) do
            local info = OtherTemplate[k]
            local suc, v = info[2](v)
            if suc then
                Other[k] = v
            else
                Other[k] = info[1]
            end
        end
        log.debug('Config update: ', table.dump(Config), table.dump(Other))
    end, log.error)
end

init()

return {
    setConfig = setConfig,
    config = Config,
    other = Other,
}
