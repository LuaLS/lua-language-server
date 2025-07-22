---@class Config
local M = Class 'Config'

---@param root Uri
function M:__init(root)
    self.root = root
    ---@type table<string, table<string, any>?>
    self.configMap = ls.runtime.env.IGNORE_CASE
                 and ls.caselessTable.create()
                  or {}
end

---@param uri Uri
function M:loadRC(uri)
    local content = ls.fs.read(uri)
    if not content then
        return
    end
    local suc, res = pcall(ls.json.decode_jsonc, content)
    if not suc then
        log.warn('Failed to parse `.luarc.json`: %s', res)
    end
    if type(res) ~= 'table' then
        return
    end
    self:applyRC(uri, res)
end

---@param uri Uri
---@param data table
function M:applyRC(uri, data)
    local dirUri = ls.fs.parent(uri)
    local keys = {}

    local function lookInto(field)
        local key = table.concat(keys, '.')
        if not ls.util.stringStartWith(key, 'Lua.') then
            key = 'Lua.' .. key
        end
        if type(field) ~= 'table' then
            self:set(dirUri, key, field)
            return
        end
        -- TODO 以后改成校验template
        local _, dotCount = key:gsub('%.', '')
        if dotCount >= 2 then
            self:set(dirUri, key, field)
            return
        end
        for k, v in pairs(field) do
            keys[#keys+1] = k
            lookInto(v)
            keys[#keys] = nil
        end
    end

    lookInto(data)
end

---@param uri Uri
---@param key string
---@param value any
function M:set(uri, key, value)
    if not ls.util.stringStartWith(key, 'Lua.') then
        key = 'Lua.' .. key
    end
    local pack = self.configMap[uri]
    if not pack then
        pack = {}
        self.configMap[uri] = pack
    end
    if ls.util.equal(pack[key], value) then
        return
    end
    pack[key] = value
end

---@param uri Uri
---@param key string
---@return any
function M:getRaw(uri, key)
    local pack = self.configMap[uri]
    if not pack then
        return nil
    end
    return pack[key]
end

---@param uri Uri
---@param key string
---@return any
function M:get(uri, key)
    local ignoreCase = ls.runtime.env.IGNORE_CASE
    if not ls.util.stringStartWith(uri, self.root, ignoreCase) then
        return nil
    end
    local currentUri = uri
    while #currentUri >= #self.root do
        local value = self:getRaw(currentUri, key)
        if value ~= nil then
            return value
        end
        currentUri = ls.fs.parent(currentUri)
    end
    return nil
end

---@class Config.API
ls.config = {}

---@param root Uri
---@return Config
function ls.config.create(root)
    return New 'Config' (root)
end
