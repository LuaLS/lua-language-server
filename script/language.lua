local fs      = require 'bee.filesystem'
local util    = require 'utility'
local lloader = require 'locale-loader'

local function supportLanguage()
    local list = {}
    for path in fs.pairs(ROOT / 'locale') do
        if fs.is_directory(path) then
            local id = path:filename():string():lower()
            list[#list+1] = id
            list[id] = true
        end
    end
    return list
end

local function getLanguage(id)
    local support = supportLanguage()
    -- 检查是否支持语言
    if support[id] then
        return id
    end
    if not id then
        return 'en-us'
    end
    -- 根据语言的前2个字母来找近似语言
    for _, lang in ipairs(support) do
        if lang:sub(1, 2) == id:sub(1, 2) then
            return lang
        end
    end
    -- 使用英文
    return 'en-us'
end

local function loadFileByLanguage(name, language)
    local path = ROOT / 'locale' / language / (name .. '.lua')
    local buf = util.loadFile(path:string())
    if not buf then
        return {}
    end
    local suc, tbl = xpcall(lloader, log.error, buf, path:string())
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
    local tbl = loadFileByLanguage(name, 'en-us')
    if language ~= 'en-us' then
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
            if not ... then
                return str
            end
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

return setmetatable({
    id = 'en-us',
}, {
    __index = function (self, name)
        local tbl = loadLang(name, self.id)
        self[name] = tbl
        return tbl
    end,
    __call = function (self, id)
        local language = getLanguage(id)
        log.info(('VSC language: %s'):format(id))
        log.info(('LS  language: %s'):format(language))
        for k in pairs(self) do
            self[k] = nil
        end
        self.id = language
    end,
})
