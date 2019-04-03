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

local Template = {
    runtime = {
        version         = {'Lua 5.3', String},
    },
    diagnostics = {
        globals         = {{},   Str2Hash ';'},
        disable         = {{},   Str2Hash ';'},
    },
    workspace = {
        ignoreDir       = {{},   Str2Hash ';'},
        ignoreSubmodules= {true, Boolean},
        useGitIgnore    = {true, Boolean},
        maxPreload      = {300,  Integer},
    }
}

local Config

local function init()
    if Config then
        return
    end
    Config = {}
    for c, t in pairs(Template) do
        Config[c] = {}
        for k, info in pairs(t) do
            Config[c][k] = info[1]
        end
    end
end

local function setConfig(self, config)
    pcall(function ()
        for c, t in pairs(config) do
            for k, v in pairs(t) do
                local info = Template[c][k]
                local suc, v = info[2](v)
                if suc then
                    Config[c][k] = v
                end
            end
        end
        log.debug('Config update: ', table.dump(Config))
    end)
end

init()

return {
    setConfig = setConfig,
    config = Config,
}
