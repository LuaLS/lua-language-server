local _M = {}

---@class node.match.pattern
---@field next node.match.pattern?

local function deepCompare(source, pattern)
    local type1, type2 = type(source), type(pattern)
    if type1 ~= type2 then
        return false
    end

    if type1 ~= "table" then
        return source == pattern
    end

    for key2, value2 in pairs(pattern) do
        local value1 = source[key2]
        if value1 == nil or not deepCompare(value1, value2) then
            return false
        end
    end

    return true
end

---@param source parser.object
---@param pattern node.match.pattern
---@return boolean
function _M.matchPattern(source, pattern)
    if source.type == 'local' then
        if source.parent.type == 'funcargs' and source.parent.parent.type == 'function' then
            for _, ref in ipairs(source.ref) do
                if deepCompare(ref, pattern) then
                    return true
                end
            end
        end
    end
    return false
end

local vaildVarRegex = "()([a-zA-Z][a-zA-Z0-9_]*)()"
---创建类型 *.field.field形式的 pattern
---@param pattern string
---@return node.match.pattern?, string?
function _M.createFieldPattern(pattern)
    local ret = { next = nil }
    local next = ret
    local init = 1
    while true do
        local startpos, matched, endpos
        if pattern:sub(1, 1) == "*" then
            startpos, matched, endpos = init, "*", init + 1
        else
            startpos, matched, endpos = vaildVarRegex:match(pattern, init)
        end
        if not startpos then
            break
        end
        if startpos ~= init then
            return nil, "invalid pattern"
        end
        local field = matched == "*" and { next = nil }
            or { field = { type = 'field', matched }, type = 'getfield', next = nil }
        next.next = field
        next = field
        pattern = pattern:sub(endpos)
    end
    return ret
end

return _M
