---@class Class
local m = {}

m._classes = {}

-- 创建一个类
---@generic T: string
---@param name  `T`
---@param super? string
---@return T
function m.class(name, super)
    if m._classes[name] then
        return m._classes[name]
    end
    local class = {}
    class.__index = class
    class.__name  = name
    class.__call  = function () end
    m._classes[name] = class

    local superClass = m._classes[super]
    if superClass then
        assert(class ~= superClass, ('class %q can not inherit itself'):format(name))
        setmetatable(class, superClass)
    end

    return class
end

-- 获取一个类
---@generic T: string
---@param name `T`
---@return T
function m.get(name)
    return m._classes[name]
end

---@generic T: string
---@param name `T`
---@return T
function m.new(name)
    local class = m._classes[name]
    assert(class, ('class %q not found'):format(name))

    local instance = setmetatable({}, class)

    return instance
end

---@param obj any
---@return string?
function m.type(obj)
    if type(obj) ~= 'table' then
        return nil
    end
    return obj.__name
end

return m
