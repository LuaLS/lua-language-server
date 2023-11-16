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
---@field public  __getter table

---@class Class.Config
---@field private name         string
---@field package extendsMap   table<string, boolean>
---@field package extendsCalls Class.Extends.CallData[]
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
        }, { __index = Config })
    end
    return M._classConfig[name]
end

-- 定义一个类
---@generic T: string
---@param name  `T`
---@param super? string
---@return T
---@return Class.Config
function M.declare(name, super)
    local config = M.getConfig(name)
    if M._classes[name] then
        return M._classes[name], config
    end
    local class  = {}
    local getter = {}
    class.__name   = name
    class.__getter = getter

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
                    self[k] = res
                end
                return res
            else
                return nil
            end
        else
            self[k] = r
            return r
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

    function class:__call(...)
        M.runInit(self, name, ...)
        return self
    end

    M._classes[name] = class

    local mt = {
        __call = function (self, ...)
            if not self.__alloc then
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

        config.superClass = superClass
        config:extends(super, function () end)
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
        M._errorHandler('can not delete undeclared class')
    end

    M.runDel(obj, name)
end

-- 获取类的名称
---@param obj table
---@return string?
function M.type(obj)
    return obj.__class__
end

-- 判断一个实例是否有效
---@param obj table
---@return boolean
function M.isValid(obj)
    return obj.__class__
       and not obj.__deleted__
end

---@param name string
---@return fun(...)
function M.super(name)
    local config = M.getConfig(name)
    return config:super(name)
end

---@alias Class.Extends.CallData { name: string, init?: fun(self: any, super: fun(...), ...) }

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

        local function collectInitCalls(cname)
            local class = M._classes[cname]
            local cdata  = M.getConfig(cname)
            local extendsCalls = cdata.extendsCalls
            if extendsCalls then
                for _, call in ipairs(extendsCalls) do
                    if call.init then
                        initCalls[#initCalls+1] = function (cobj, ...)
                            call.init(cobj, function (...)
                                M.runInit(cobj, call.name, ...)
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
    if not self.extendsMap[extendsName] then
        self.extendsMap[extendsName] = true
        for k, v in pairs(extends) do
            if not class[k] and not k:match '^__' then
                class[k] = v
            end
        end
        for k, v in pairs(extends.__getter) do
            if not class.__getter[k] then
                class.__getter[k] = v
            end
        end
    end
    table.insert(self.extendsCalls, {
        init = init,
        name = extendsName,
    })
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

return M
