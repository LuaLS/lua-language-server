local support = {
    'enUS',
}

local function osLanguage()
    return ''
end

local function init()
    local id = osLanguage()
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
    -- 使用第一个语言
    return support[1]
end

return init()
