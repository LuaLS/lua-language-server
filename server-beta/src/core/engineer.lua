local guide = require 'parser.guide'

---@class engineer
local mt = {}
mt.__index = mt
mt.type = 'engineer'

--- 遍历全局变量
function mt:eachGloabl(root, callback)
    guide.eachSourceOf(root, {'setglobal', 'getglobal', 'setfield', 'getfield'}, function (src)
        if src.type == 'setglobal' or src.type == 'getglobal' then
            callback(src, src[1])
        elseif src.type == 'setfield' or src.type == 'getfield' then
            local node = root[src.node]
            if self.isGlobal(root, node) then
                callback(src, src.field[1])
            end
        end
    end)
end

--- 判断全局变量
function mt:isGlobal(root, obj)
    if obj.type == 'getglobal' then
        if obj[1] == '_G' or obj[1] == '_ENV' then
            return true
        end
    end
    return false
end

--- 遍历局部变量引用
function mt:eachLocalRef(obj, callback)
    if not obj then
        return
    end
    local src
    if obj.type == 'local' then
        src = obj
    elseif obj.type == 'getlocal' or obj.type == 'setlocal' then
        src = self.ast.root[obj.loc]
    else
        return
    end
    callback(src)
    if src.ref then
        for i = 1, #src.ref do
            local ref = src.ref[i]
            callback(self.ast.root[ref])
        end
    end
end

return function (ast)
    local self = setmetatable({
        step = 0,
        ast  = ast,
    }, mt)
    return self
end
