local progress = require 'progress'
local lang     = require 'language'
local await    = require 'await'

---@class workspace.loading
---@field _bar progress
---@field _stash function[]
local mt = {}
mt.__index = mt

mt._loadLock = false
mt.read      = 0
mt.max       = 0
mt.preload   = 0

function mt:update()
    self._bar:setMessage(('%d/%d'):format(self.read, self.max))
    self._bar:setPercentage(self.read / self.max * 100.0)
end

function mt:load()
    self:update()
    if self._loadLock then
        return
    end
    self._loadLock = true
    ---@async
    await.call(function ()
        while true do
            local loader = table.remove(self._stash)
            if not loader then
                break
            end
            loader()
            await.delay()
        end
        self._loadLock = false
    end)
end

---@async
function mt:loadAll(callback)
    while true do
        callback()
        self:update()
        if self.read >= self.max then
            break
        end
        await.sleep(0.1)
    end
end

function mt:isFinished()
    return self.read >= self.max
end

function mt:remove()
    self._bar:remove()
end

function mt:__close()
    self:remove()
end

---@class workspace.loading.manager
local m = {}

---@return workspace.loading
function m.create(scp)
    local loading = setmetatable({
        _bar   = progress.create(lang.script('WORKSPACE_LOADING', scp.uri)),
        _stash = {},
    }, mt)
    return loading
end

return m
