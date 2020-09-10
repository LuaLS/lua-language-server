local m = {}

m.cache = {}

--- `aaa/bbb/ccc.lua` 与 `?.lua` 将返回 `aaa.bbb.cccc`
local function getOnePath(path, searcher)
    local stemPath     = path
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\]+', '.')
    local stemSearcher = searcher
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\]+', '.')
    local start        = stemSearcher:match '()%?' or 1
    for pos = start, #stemPath do
        local word = stemPath:sub(start, pos)
        local newSearcher = stemSearcher:gsub('%?', word)
        if newSearcher == stemPath then
            return word
        end
    end
    return nil
end

function m.getVisiblePath(path, searchers)
    if not m.cache[path] then
        local result = {}
        m.cache[path] = result
        for _, searcher in ipairs(searchers) do
        end
    end
    return m.cache[path]
end

function m.flush()
    m.cache = {}
end

return m
