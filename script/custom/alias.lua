---@class Custom.Alias
local M = Class 'Custom.Alias'

---@param rt Node.Runtime
---@param name string
function M:__init(rt, name)
    self.rt = rt
    self.name  = name

    self.alias = rt.alias(name)
    self.master = ls.custom.contextMaster(self.alias)

    ---@type boolean
    self.resetOnScopeChanged = false
end

function M:__del()
    self.alias:dispose()
end

function M:__close()
    self:dispose()
end

function M:dispose()
    Delete(self)
end

--- 注册自定义 hover：当 hover 到类型为该 alias 的字符串/数字字面量时调用。
---@param callback fun(c: Custom.Context): string | { label?: string, description?: string } | nil
---@return Custom.Alias
function M:onHover(callback)
    self.alias:setCustomHover(function (_, location, source)
        local data = {}
        data.location = location
        data.source = source
        local result = self.master:call(callback, data)
        return result
    end)
    return self
end

--- 注册自定义补全：当字符串参数的期望类型为该 alias 时调用。
--- 回调返回补全项列表（label 为插入文本，detail 为简要说明，description 为 Markdown 说明，kind 可选，可用 c.kind.XXXX 指定）。
---@param callback fun(c: Custom.Context.Completion): { label: string, detail?: string, description?: string, kind?: LSP.CompletionItemKind }[] | nil
---@return Custom.Alias
function M:onCompletion(callback)
    self.alias:setCustomCompletion(function (_, location, source)
        local data = {}
        data.location = location
        data.source = source
        data.kind = ls.spec.CompletionItemKind
        local result = self.master:call(callback, data)
        return result
    end)
    return self
end

---@class Custom.Context.Define
--- 定义期上下文：注册 alias 时构造 Node 并设置 alias。
---@field type fun(name: string): Node.Type
---@field value fun(v: string | number | boolean, quo?: '"' | "'" | '[['): Node.Value
---@field table fun(fields?: table): Node.Table
---@field field fun(key: Node.Key, value?: Node, optional?: boolean): Node.Field
---@field array fun(value: Node): Node.Array
---@field generic fun(name: string, extends?: Node, default?: Node): Node.Generic
---@field union fun(nodes?: Node[], filter?: fun(node: Node): boolean): Node
---@field list fun(values?: Node[], min?: integer, max?: integer | false): Node.List
---@field call fun(head: string, args: Node[]): Node.Call
---@field setValue fun(node: Node)
---@field param fun(name: string)
---@field resetCacheOnScopeChanged fun() # 声明该 alias 的求值依赖工作区文件集合，文件增删后重新求值

--- 注册定义期回调
---@param callback fun(c: Custom.Context.Define)
---@return Custom.Alias
function M:define(callback)
    local rt    = self.rt
    local alias = self.alias
    local c     = {}
    c.type     = rt.type
    c.value    = rt.value
    c.table    = rt.table
    c.field    = rt.field
    c.array    = rt.array
    c.generic  = rt.generic
    c.union    = rt.union
    c.list     = rt.list
    c.call     = rt.call
    c.setValue = function (node) alias:setValue(node) end
    c.param    = function (name) alias:addTypeParam(rt.generic(name)) end
    c.resetCacheOnScopeChanged = function ()
        self.resetOnScopeChanged = true
    end
    callback(c)
    return self
end

--- 每当要对该类求值时调用
--- 默认情况下会将结果缓存在具体的调用点上，因此只会被调用一次
--- 当所在文件发生变化时缓存会被清除
---@param callback fun(c: Custom.Context): Node
function M:onValue(callback)
    local alias = self.alias
    self.alias:setCustomValue(function (_, args, location)
        local data = {}
        data.location = location
        if self.alias.params then
            local cargs = {}
            for i, param in ipairs(self.alias.params) do
                cargs[i] = args[i] or self.rt.NEVER
                cargs[param.name] = cargs[i]
            end
            data.args = cargs
        end
        local node = self.master:call(callback, data)
        if self.resetOnScopeChanged then
            alias.scope:addRef(alias)
        end
        return node
    end)
end

---@param rt Node.Runtime
---@param name string
---@return Custom.Alias
function ls.custom.alias(rt, name)
    return New 'Custom.Alias' (rt, name)
end
