local guide = require 'parser.guide'

local function getKey(source)
    if source.type == 'local' then
        return ('l%d%s'):format(source.start, source[1])
    end
end

---创建source的链接信息
local function createLink(source)
    local idList = {}
    if getKey then
        idList[#idList+1] = getKey(source)
    end
    local id = table.concat(idList, '|')
    return {
        id = id,
    }
end

local m = {}

---获取source的链接信息
function m.getLink(source)
    if not source._link then
        source._link = createLink(source)
    end
    return source._link
end

return m
