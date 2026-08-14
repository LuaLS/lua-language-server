---@class Custom.Alias
local M = Class 'Custom.Alias'

---@param rt Node.Runtime
---@param name string
function M:__init(rt, name)
    self.rt = rt
    self.name  = name

    self.alias = rt.alias(name)
    self.master = ls.custom.contextMaster(self.alias)
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

---@param name string
---@return Custom.Alias
function M:param(name)
    local p = self.rt.generic(name)
    self.alias:addTypeParam(p)
    return self
end

---@param value Node
---@return Custom.Alias
function M:setValue(value)
    self.alias:setValue(value)
    return self
end

--- 注册自定义 hover：当 hover 到类型为该 alias 的字符串/数字字面量时调用。
--- 回调返回单个字符串或字符串数组，作为额外的 hover 内容追加显示。
---@param callback fun(c: Custom.Context): string | string[] | nil
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

---@param callback fun(c: Custom.Context): Node
function M:onValue(callback)
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
        return node
    end)
end

---@param rt Node.Runtime
---@param name string
---@return Custom.Alias
function ls.custom.alias(rt, name)
    return New 'Custom.Alias' (rt, name)
end
