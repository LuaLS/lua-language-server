local mt = {}
mt.__index = mt
mt.type = 'task'

function mt:remove()
    if self._removed then
        return
    end
    self._removed = true
    coroutine.close(self.task)
end

function mt:isRemoved()
    return self._removed
end

function mt:step()
    if self._removed then
        return
    end
    local suc, res = coroutine.resume(self.task)
    if not suc then
        self:remove()
        log.error(debug.traceback(self.task, res))
        return
    end
    if coroutine.status(self.task) == 'dead' then
        self:remove()
    end
    return res
end

function mt:fastForward()
    if self._removed then
        return
    end
    while true do
        local suc = coroutine.resume(self.task)
        if not suc then
            self:remove()
            break
        end
        if coroutine.status(self.task) == 'dead' then
            self:remove()
            break
        end
    end
end

function mt:set(key, value)
    self.data[key] = value
end

function mt:get(key)
    return self.data[key]
end

return function (callback)
    local self = setmetatable({
        data = {},
        task = coroutine.create(callback),
    }, mt)
    return self
end
