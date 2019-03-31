local fs = require 'bee.filesystem'
local lni = require 'lni'

local function supportLanguage()
    local list = {}
    for path in (ROOT / 'locale'):list_directory() do
        if fs.is_directory(path) then
            list[#list+1] = path:filename():string():lower()
        end
    end
    return list
end

local function osLanguage()
    return LANG:lower()
end

local function getLanguage(id)
    local support = supportLanguage()
    -- 检查是否支持语言
    if support[id] then
        return id
    end
    -- 根据语言的前2个字母来找近似语言
    for _, lang in ipairs(support) do
        if lang:sub(1, 2) == id:sub(1, 2) then
            return lang
        end
    end
    -- 使用英文
    return 'enUS'
end

local function loadFileByLanguage(name, language)
    local path = ROOT / 'locale' / language / (name .. '.lni')
    local buf = io.load(path)
    if not buf then
        return {}
    end
    local suc, tbl = xpcall(lni, log.error, buf, path:string())
    if not suc then
        return {}
    end
    return tbl
end

local function formatAsArray(str, ...)
    local index = 0
    local args = {...}
    return str:gsub('%{(.-)%}', function (pat)
        local id, fmt
        local pos = pat:find(':', 1, true)
        if pos then
            id = pat:sub(1, pos-1)
            fmt = pat:sub(pos+1)
        else
            id = pat
            fmt = 's'
        end
        id = tonumber(id)
        if not id then
            index = index + 1
            id = index
        end
        return ('%'..fmt):format(args[id])
    end)
end

local function formatAsTable(str, ...)
    local args = ...
    return str:gsub('%{(.-)%}', function (pat)
        local id, fmt
        local pos = pat:find(':', 1, true)
        if pos then
            id = pat:sub(1, pos-1)
            fmt = pat:sub(pos+1)
        else
            id = pat
            fmt = 's'
        end
        if not id then
            return
        end
        return ('%'..fmt):format(args[id])
    end)
end

local function loadLang(name, language)
    local tbl = loadFileByLanguage(name, 'en-US')
    if language ~= 'en-US' then
        local other = loadFileByLanguage(name, language)
        for k, v in pairs(other) do
            tbl[k] = v
        end
    end
    return setmetatable(tbl, {
        __index = function (self, key)
            self[key] = key
            return key
        end,
        __call = function (self, key, ...)
            local str = self[key]
            local suc, res
            if type(...) == 'table' then
                suc, res = pcall(formatAsTable, str, ...)
            else
                suc, res = pcall(formatAsArray, str, ...)
            end
            if suc then
                return res
            else
                -- 这里不能使用翻译，以免死循环
                log.warn(('[%s][%s-%s] formated error: %s'):format(
                    language, name, key, str
                ))
                return str
            end
        end,
    })
end

local function init()
    local id = osLanguage()
    local language = getLanguage(id)
    log.info(('VSC language: %s'):format(id))
    log.info(('LS  language: %s'):format(language))
    return setmetatable({ id = language }, {
        __index = function (self, name)
            local tbl = loadLang(name, language)
            self[name] = tbl
            return tbl
        end,
    })
end

return init()
