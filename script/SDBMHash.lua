local byte = string.byte
local max = 0x7fffffff

---@class SDBMHash
local mt = {}
mt.__index = mt

mt.cache = nil

---@param str string
---@return integer
function mt:rawHash(str)
    local id = 0
    for i = 1, #str do
        local b = byte(str, i, i)
        id = id * 65599 + b
    end
    return id & max
end

---@param str string
---@return integer
function mt:hash(str)
    local id = self:rawHash(str)
    local other = self.cache[id]
    if other == nil or str == other then
        self.cache[id] = str
        self.cache[str] = id
        return id
    else
        log.warn(('哈希碰撞：[%s] -> [%s]: [%d]'):format(str, other, id))
        for i = 1, max do
            local newId = (id + i) % max
            if not self.cache[newId] then
                self.cache[newId] = str
                self.cache[str] = newId
                return newId
            end
        end
        error(('哈希碰撞解决失败：[%s] -> [%s]: [%d]'):format(str, other, id))
    end
end

function mt:setCache(t)
    self.cache = t
end

function mt:getCache()
    return self.cache
end

mt.__call = mt.hash

---@return SDBMHash
return function ()
    local self = setmetatable({
        cache = {}
    }, mt)
    return self
end
