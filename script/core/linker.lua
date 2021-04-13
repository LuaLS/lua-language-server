local guide = require 'parser.guide'
local glob = require "glob.glob"

local function getKey(source)
    if     source.type == 'local' then
        return tostring(source.start)
    elseif source.type == 'setlocal'
    or     source.type == 'getlocal' then
        return tostring(source.node.start)
    elseif source.type == 'setglobal'
    or     source.type == 'getglobal'
    or     source.type == 'field'
    or     source.type == 'method' then
        return ('%q'):format(source[1])
    end
end

local function isGlobal(source)
    if source.type == 'setglobal'
    or source.type == 'getglobal' then
        return true
    end
    return nil
end

---创建source的链接信息
local function createLink(source)
    local current = source
    local idList = {}
    while true do
        local id = getKey(current)
        if not id then
            break
        end
        idList[#idList+1] = id
        source = current
        current = current.parent
    end
    local id = table.concat(idList, '|')
    local global = isGlobal(source)
    return {
        id     = id,
        global = global,
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
