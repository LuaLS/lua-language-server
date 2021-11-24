---@class markdown
local mt = {}
mt.__index = mt
mt.__name = 'markdown'

mt._splitLine = false

function mt:__tostring()
    return self:string()
end

---@param language string
---@param text string|markdown
function mt:add(language, text)
    if not text then
        return self
    end
    self._cacheResult = nil
    if type(text) == 'table' then
        self[#self+1] = {
            type     = 'markdown',
            markdown = text,
        }
    else
        text = tostring(text)
        self[#self+1] = {
            type     = 'text',
            language = language,
            text     = text,
        }
    end
    return self
end

function mt:splitLine()
    self._cacheResult = nil
    self[#self+1] = {
        type = 'splitline',
    }
    return self
end

function mt:string()
    if self._cacheResult then
        return self._cacheResult
    end
    local lines = {}
    local language = 'md'

    local function concat(markdown)
        for _, obj in ipairs(markdown) do
            if obj.type == 'splitline' then
                if language ~= 'md' then
                    lines[#lines+1] = '```'
                    language = 'md'
                end
                if #lines > 0
                and lines[#lines] ~= '---' then
                    lines[#lines+1] = ''
                    lines[#lines+1] = '---'
                end
            elseif obj.type == 'markdown' then
                concat(obj.markdown)
            else
                if obj.language ~= language then
                    if language ~= 'md' then
                        lines[#lines+1] = '```'
                    end
                    if #lines > 0 then
                        lines[#lines+1] = ''
                    end
                    if obj.language ~= 'md' then
                        lines[#lines+1] = '```' .. obj.language
                    end
                end
                if obj.language == 'md' and #lines > 0 then
                    local last = lines[#lines]
                    if obj.text:sub(1, 1) == '@'
                    or last:sub(1, 1) == '@' then
                        if lines[#lines] ~= '' then
                            lines[#lines+1] = ''
                        end
                    end
                end
                lines[#lines+1] = obj.text
                language = obj.language
            end
        end
    end

    concat(self)
    if language ~= 'md' then
        lines[#lines+1] = '```'
    end
    while true do
        if lines[#lines] == '---'
        or lines[#lines] == '' then
            lines[#lines] = nil
        else
            break
        end
    end

    local result = table.concat(lines, '\n')
    self._cacheResult = result
    return result
end

return function ()
    return setmetatable({}, mt)
end
