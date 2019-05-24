local mt = {}
mt.__index = mt
mt.type = 'multi'
mt.len = 0

function mt:push(value, isLast)
    if value and value.type == 'list' then
        if isLast then
            for _, v in ipairs(value) do
                self.len = self.len + 1
                self[self.len] = v
            end
        else
            self.len = self.len + 1
            self[self.len] = value[1]
        end
    else
        self.len = self.len + 1
        self[self.len] = value
    end
end

function mt:get(index)
    return self[index]
end

function mt:set(index, value)
    if index > self.len then
        self.len = index
    end
    self[index] = value
end

function mt:first()
    local value = self[1]
    if not value then
        return nil
    end
    if value.type == 'multi' then
        return value:first()
    else
        return value
    end
end

function mt:eachValue(callback)
    local i = 0
    for n, value in ipairs(self) do
        if value.type == 'multi' then
            if n == self.len then
                value:eachValue(function (_, nvalue)
                    i = i + 1
                    callback(i, nvalue)
                end)
            else
                i = i + 1
                value:first()
            end
        else
            i = i + 1
            callback(i, value)
        end
    end
end

function mt:merge(other)
    other:eachValue(function (_, value)
        self:push(value)
    end)
end

function mt:setEmmy(emmy)
    self._emmy = emmy
end

function mt:getEmmy()
    return self._emmy
end

return function ()
    local self = setmetatable({}, mt)
    return self
end
