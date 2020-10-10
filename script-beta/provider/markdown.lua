local mt = {}
mt.__index = mt
mt.__name = 'markdown'

function mt:add(language, text)
    if not text or #text == 0 then
        return
    end
    if language == 'md' then
        if self._last == 'md' then
            self[#self+1] = ''
        end
        self[#self+1] = text
    else
        self[#self+1] = ('```%s\n%s\n```'):format(language, text)
    end
    self._last = language
end

function mt:string()
    return table.concat(self, '\n')
end

return function ()
    return setmetatable({}, mt)
end
