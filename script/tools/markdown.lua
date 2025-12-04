---@class Markdown: Class.Base
local M = Class 'Markdown'

function M:__init()
    self.contents = {}
end

function M:__tostring()
    return self:string()
end

---@param language string
---@param value string
---@return Markdown
function M:append(language, value)
    table.insert(self.contents, {
        language = language,
        value    = value,
    })
    self.value = nil
    return self
end

---@param value string
---@return Markdown
function M:appendPaintext(value)
    table.insert(self.contents, {
        value = value,
    })
    self.value = nil
    return self
end

---@param mk Markdown
---@return Markdown
function M:appendMarkdown(mk)
    ls.util.arrayMerge(self.contents, mk.contents)
    self.value = nil
    return self
end

function M:string()
    return self.value
end

---@type string
M.value = nil

---@param self Markdown
---@return string
---@return true
M.__getter.value = function (self)
    local lines = {}
    local lastLanguage = nil
    for _, content in ipairs(self.contents) do
        if lastLanguage == content.language then
            lines[#lines+1] = content.value
            goto continue
        end
        if lastLanguage then
            lines[#lines+1] = '```'
            lastLanguage = nil
        end
        if content.language then
            lines[#lines+1] = '```' .. content.language
            lines[#lines+1] = content.value
            lastLanguage = content.language
        end
        ::continue::
    end
    if lastLanguage then
        lines[#lines+1] = '```'
    end
    return table.concat(lines, '\n'), true
end

return {
    create = function ()
        return New 'Markdown' ()
    end
}
