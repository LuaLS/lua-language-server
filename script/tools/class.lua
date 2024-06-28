---@class Class
local M = {}

---@private
---@type table<string, Class.Base>
M._classes = {}

---@private
---@type table<string, Class.Config>
M._classConfig = {}

---@private
M._errorHandler = error

---@class Class.Base
---@field public  __init?  fun(self: any, ...)
---@field public  __del?   fun(self: any)
---@field public  __alloc? fun(self: any)
---@field package __call   fun(self: any, ...)
---@field package __name string
---@field public  __getter table
---@field public  __setter table
---@field public  __super  Class.Base

---@class Class.Config
---@field private name         string
---@field package extendsMap   table<string, boolean>
---@field package extendsCalls Class.Extends.CallData[]
---@field package extendsKeys  table<string, boolean>
---@field private superCache   table<string, fun(...)>
---@field package superClass?  Class.Base
---@field public  getter       table<any, fun(obj: any)>
---@field package initCalls?   false|fun(...)[]
local Config = {}

---@param name string
---@return Class.Config
function M.getConfig(name)
    if not M._classConfig[name] then
        M._classConfig[name] = setmetatable({
            name         = name,
            extendsMap   = {},
            superCache   = {},
            extendsCalls = {},
            extendsKeys  = {},
        }, { __index = Config })
    end
    return M._classConfig[name]
end

-- 定义一个类
---@generic T: string
---@generic Super: string
---@param name  `T`
---@param super? `Super`
---@param superInit? fun(self: Class, super: Super, ...)
---@return T
---@return Class.Config
function M.declare(name, super, superInit)
    local config = M.getConfig(name)
    if M._classes[name] then
        return M._classes[name], config
    end
    local class  = {}
    local getter = {}
    local setter = {}
    class.__name   = name
    class.__getter = getter
    class.__setter = setter

    ---@param self any
    ---@param k any
    ---@return any
    local function getterFunc(self, k)
        local r = class[k]
        if r == nil then
            local f = getter[k]
            if f then
                local res, needCache = f(self)
                if needCache then
                    rawset(self, k, res)
                end
                return res
            else
                return nil
            end
        else
            rawset(self, k, r)
            return r
        end
    end

    ---@param self any
    ---@param k any
    ---@param v any
    ---@return any
    local function setterFunc(self, k, v)
        local f = setter[k]
        if f then
            local res = f(self, v)
            if res ~= nil then
                rawset(self, k, res)
            end
        else
            rawset(self, k, v)
        end
    end

    function class:__index(k)
        if next(class.__getter) then
            class.__index = getterFunc
            return getterFunc(self, k)
        else
            class.__index = class
            return class[k]
        end
    end

    function class:__newindex(k, v)
        if next(class.__setter) then
            class.__newindex = setterFunc
            setterFunc(self, k, v)
        else
            class.__newindex = nil
            rawset(self, k, v)
        end
    end

    function class:__call(...)
        M.runInit(self, name, ...)
        return self
    end

    M._classes[name] = class

    local mt = {
        __call = function (self, ...)
            if not self.__alloc then
                error(('class %q can not be instantiated'):format(name))
                return self
            end
            return self:__alloc(...)
        end,
    }
    setmetatable(class, mt)

    local superClass = M._classes[super]
    if superClass then
        if class == superClass then
            M._errorHandler(('class %q can not inherit itself'):format(name))
        end

        class.__super = superClass
        config.superClass = superClass
        if superInit then
            config:extends(super, superInit)
        else
            config:extends(super, function () end)
        end
    end

    return class, config
end

-- 获取一个类
---@generic T: string
---@param name `T`
---@return T
function M.get(name)
    return M._classes[name]
end

-- 实例化一个类
---@generic T: string
---@param name `T`
---@param tbl? table
---@return T
function M.new(name, tbl)
    local class = M._classes[name]
    if not class then
        M._errorHandler(('class %q not found'):format(name))
    end

    if not tbl then
        tbl = {}
    end
    tbl.__class__ = name

    local instance = setmetatable(tbl, class)

    return instance
end

-- 析构一个实例
---@param obj table
function M.delete(obj)
    if obj.__deleted__ then
        return
    end
    obj.__deleted__ = true
    local name = obj.__class__
    if not name then
        M._errorHandler('can not delete undeclared class : ' .. tostring(obj))
    end

    M.runDel(obj, name)
end

-- 获取类的名称
---@param obj any
---@return string?
function M.type(obj)
    if type(obj) ~= 'table' then
        return nil
    end
    return obj.__class__
end

-- 判断一个实例是否有效
---@param obj table
---@return boolean
function M.isValid(obj)
    return obj.__class__
       and not obj.__deleted__
end

--推荐使用“扩展语义”而不是“继承”语义 。
--因此不适合使用`super`了。
---@deprecated
---@param name string
---@return fun(...)
function M.super(name)
    local config = M.getConfig(name)
    return config:super(name)
end

---@alias Class.Extends.CallData { name: string, init?: fun(self: any, super: (fun(...): Class.Base), ...) }

---@generic Class: string
---@generic Extends: string
---@param name `Class`
---@param extendsName `Extends`
---@param init? fun(self: Class, super: Extends, ...)
function M.extends(name, extendsName, init)
    local config = M.getConfig(name)
    config:extends(extendsName, init)
end

---@private
---@param obj table
---@param name string
---@param ... any
function M.runInit(obj, name, ...)
    local data  = M.getConfig(name)
    if data.initCalls == false then
        return
    end
    if not data.initCalls then
        local initCalls = {}
        local collected = {}

        local function collectInitCalls(cname)
            if collected[cname] then
                error(('class %q has circular inheritance'):format(cname))
            end
            collected[cname] = true
            local class = M._classes[cname]
            local cdata  = M.getConfig(cname)
            local extendsCalls = cdata.extendsCalls
            if extendsCalls then
                for _, call in ipairs(extendsCalls) do
                    if call.init then
                        initCalls[#initCalls+1] = function (cobj, ...)
                            local firstCall = true
                            call.init(cobj, function (...)
                                if firstCall then
                                    firstCall = false
                                    M.runInit(cobj, call.name, ...)
                                end
                                return M._classes[call.name]
                            end, ...)
                        end
                    else
                        collectInitCalls(call.name)
                    end
                end
            end
            if class.__init then
                initCalls[#initCalls+1] = class.__init
            end
        end

        collectInitCalls(name)

        if #initCalls == 0 then
            data.initCalls = false
            return
        else
            data.initCalls = initCalls
        end
    end

    for i = 1, #data.initCalls do
        data.initCalls[i](obj, ...)
    end
end

---@private
---@param obj table
---@param name string
function M.runDel(obj, name)
    local class = M._classes[name]
    local data  = M.getConfig(name)
    local extendsCalls = data.extendsCalls
    if extendsCalls then
        for _, call in ipairs(extendsCalls) do
            M.runDel(obj, call.name)
        end
    end
    if class.__del then
        class.__del(obj)
    end
end

---@param errorHandler fun(msg: string)
function M.setErrorHandler(errorHandler)
    M._errorHandler = errorHandler
end

---@param name string
---@return fun(...)
function Config:super(name)
    if not self.superCache[name] then
        local class = M._classes[name]
        if not class then
            M._errorHandler(('class %q not found'):format(name))
        end
        local super = self.superClass
        if not super then
            M._errorHandler(('class %q not inherit from any class'):format(name))
        end
        ---@cast super -?
        self.superCache[name] = function (...)
            local k, obj = debug.getlocal(2, 1)
            if k ~= 'self' then
                M._errorHandler(('`%s()` must be called by the class'):format(name))
            end
            super.__call(obj,...)
        end
    end
    return self.superCache[name]
end

---@generic Extends: string
---@param extendsName `Extends`
---@param init? fun(self: self, super: Extends)
function Config:extends(extendsName, init)
    local class   = M._classes[self.name]
    local extends = M._classes[extendsName]
    if not extends then
        M._errorHandler(('class %q not found'):format(extendsName))
    end
    if type(init) ~= 'nil' and type(init) ~= 'function' then
        M._errorHandler(('init must be nil or function'))
    end
    self.extendsMap[extendsName] = true

    do --复制父类的字段与 getter 和 setter
        for k, v in pairs(extends) do
            if (not class[k] or self.extendsKeys[k])
            and not k:match '^__' then
                self.extendsKeys[k] = true
                class[k] = v
            end
        end
        for k, v in pairs(extends.__getter) do
            if not class.__getter[k]
            or self.extendsKeys[k] then
                self.extendsKeys[k] = true
                class.__getter[k] = v
            end
        end
        for k, v in pairs(extends.__setter) do
            if not class.__setter[k]
            or self.extendsKeys[k] then
                self.extendsKeys[k] = true
                class.__setter[k] = v
            end
        end
    end

    do --记录父类的init方法
        local rewrite
        for i = 1, #self.extendsCalls do
            local call = self.extendsCalls[i]
            if call.name == extendsName then
                call.init = init
                rewrite = true
                break
            end
        end
        if not rewrite then
            table.insert(self.extendsCalls, {
                init = init,
                name = extendsName,
            })
        end
    end

    -- 检查是否需要显性初始化
    if not init then
        if not extends.__init then
            return
        end
        local info = debug.getinfo(extends.__init, 'u')
        if info.nparams <= 1 then
            return
        end
        M._errorHandler(('must call super for extends "%s"'):format(extendsName))
    end
end

local isInstanceMap = setmetatable({}, { __index = function (isInstanceMap, myName)
    local map = {
        [myName] = true,
    }
    isInstanceMap[myName] = map

    local config = M.getConfig(myName)
    setmetatable(map, { __index = function (_, targetName)
        local superName = config.superClass and config.superClass.__name
        if superName then
            if isInstanceMap[superName][targetName] then
                map[targetName] = true
                return true
            end
        end
        for parentName in pairs(config.extendsMap) do
            if isInstanceMap[parentName][targetName] then
                map[targetName] = true
                return true
            end
        end
        map[targetName] = false
        return false
    end })
    return map
end })

---检查一个对象是否是某个类的实例
---@param obj any
---@param targetName string
---@return boolean
function M.isInstanceOf(obj, targetName)
    local myName = M.type(obj)
    if not myName then
        return false
    end

    return isInstanceMap[myName][targetName]
end

return M
