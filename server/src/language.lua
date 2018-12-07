local fs = require 'bee.filesystem'

local function supportLanguage()
    local list = {}
    for path in (ROOT / 'locale'):list_directory() do
        if fs.is_directory(path) then
            list[#list+1] = path:filename():string()
        end
    end
    return list
end

local function osLanguage()
    return ''
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

local function init()
    local id = osLanguage()
    local language = getLanguage(id)
    log.info(('Os language:   %s'):format(id))
    log.info(('Used language: %s'):format(language))
    return language
end

return init()
