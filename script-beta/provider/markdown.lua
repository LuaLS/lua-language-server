local mt = {}
mt.__index = mt
mt.__name = 'markdown'

function mt:add(language, text)
    if not text then
        return
    end
    if language == 'lua' then
        self[#self+1] = ('```lua\n%s\n```'):format(text)
    else
        self[#self+1] = text
    end
end

function mt:string()
    return table.concat(self, '\n')
end

return function ()
    return setmetatable({}, mt)
end
