local function getDefaultSource()
    return {
        start = 0,
        finish = 0,
        uri = '',
    }
end

local mt = {}
mt.__index = mt
mt.type = 'local'
mt._close = math.maxinteger

function mt:setValue(value)
    if self.value then
        self.value:mergeValue(value)
    else
        self.value = value
    end
end

function mt:getValue()
    return self.value
end

function mt:addInfo(tp, source)
    self[#self+1] = {
        type = tp,
        source = source,
    }
end

function mt:eachInfo(callback)
    for _, info in ipairs(self) do
        local res = callback(info)
        if res ~= nil then
            return res
        end
    end
end

function mt:set(name, v)
    if not self._flag then
        self._flag = {}
    end
    self._flag[name] = v
end

function mt:get(name)
    if not self._flag then
        return nil
    end
    return self._flag[name]
end

function mt:getName()
    return self.name
end

function mt:shadow(old)
    if not old then
        return self._shadow
    end
    local group = old._shadow
    if not group then
        group = {}
        group[#group+1] = old
    end
    group[#group+1] = self
    self._shadow = group
    old:close(self.source.start - 1)
end

function mt:close(pos)
    if pos then
        self._close = pos
    else
        return self._close
    end
end

return function (name, source, value)
    if not value then
        error('Local must has a value')
    end
    local self = setmetatable({
        name = name,
        source = source or getDefaultSource(),
        value = value,
    }, mt)
    return self
end
