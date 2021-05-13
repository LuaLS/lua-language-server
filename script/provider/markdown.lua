local mt = {}
mt.__index = mt
mt.__name = 'markdown'

mt._splitLine = false

local function checkSplitLine(self)
    if not self._splitLine then
        return
    end
    self._splitLine = nil
    if #self == 0 then
        return
    end

    self[#self+1] = '---'
end

function mt:add(language, text)
    if not text or #text == 0 then
        return
    end

    checkSplitLine(self)

    if language == 'md' then
        if self._last == 'md' then
            self[#self+1] = ''
        end
        self[#self+1] = text
    else
        if #self > 0 then
            self[#self+1] = ''
        end
        self[#self+1] = ('```%s\n%s\n```'):format(language, text)
    end

    self._last = language
end

function mt:string()
    return table.concat(self, '\n')
end

function mt:splitLine()
    self._splitLine = true
end

return function ()
    return setmetatable({}, mt)
end
