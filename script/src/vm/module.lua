local mt = require 'vm.manager'
local createMulti = require 'vm.multi'

--[[
function module(name, ...)
    local env = {}
    for _, opt in ipairs {...} do
        opt(env)
    end
    @ENV = env
end
--]]
function mt:callModuel(func, values)
    local envLoc = self:loadLocal('@ENV')
    if not envLoc then
        return
    end
    local source = self:getDefaultSource()
    local newEnvValue = self:createValue('table', source)
    local args = createMulti()

    args:push(newEnvValue)

    for i = 2, #values do
        local value = values[i]
        -- opt(env)
        self:call(value, args, source)
    end

    -- @ENV = env
    envLoc:setValue(newEnvValue)
end

--[[
function package.seeall(env)
    setmetatable(env, { __index = @ENV })
end
--]]
function mt:callSeeAll(func, values)
    local newEnv = values[1]
    if not newEnv then
        return
    end
    local envLoc = self:loadLocal('@ENV')
    if not envLoc then
        return
    end
    local oldEnv = envLoc:getValue()
    if not oldEnv then
        return
    end
    local source = self:getDefaultSource()
    local meta = self:createValue('table', source)
    meta:setChild('__index', oldEnv, source)
    newEnv:setMetaTable(meta)
end
