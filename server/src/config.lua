local function Boolean(v)
    if type(v) == 'boolean' then
        return true, v
    end
    return false
end

local function Str2Hash(sep)
    return function (v)
        if type(v) ~= 'string' then
            return false
        end
        local t = {}
        for s in v:gmatch('[^'..sep..']+') do
            t[s] = true
        end
        return t
    end
end

local Template = {
    diagnostics = {
        postSpcae     = {true, Boolean},
        spaceOnlyLine = {true, Boolean},
        globals       = {{},   Str2Hash ';'},
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

local function setConfig(config)
    pcall(function ()
        for c, t in pairs(config) do
            for k, v in pairs(t) do
                local f = Template[c][k]
                local suc, v = f(v)
                if suc then
                    Config[c][k] = v
                end
            end
        end
    end)
end

init()

return {
    setConfig = setConfig,
    config = Config,
}
