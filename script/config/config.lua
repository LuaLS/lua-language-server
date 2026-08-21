local template = require 'config.template'

---@class Config
local M = Class 'Config'

---@param root Uri
function M:__init(root)
    self.root = root
    ---@type table<string, table<string, any>?>
    self.configMap = ls.fs.newMap()
    ---@type table<string, any>
    self.clientMap = {}
end

---@param uri Uri
---@return boolean changed
function M:loadRC(uri)
    local content = ls.fs.read(uri)
    if not content then
        return false
    end
    local suc, res = pcall(ls.json.decode_jsonc, content)
    if not suc then
        log.warn('Failed to parse `.luarc.json`: %s', res)
    end
    if type(res) ~= 'table' then
        return false
    end
    return self:applyRC(uri, res)
end

local function makeLookInto(setter)
    local keys = {}

    ---@param field any
    local function lookInto(field)
        local key = table.concat(keys, '.')
        if not ls.util.stringStartWith(key, 'Lua.') then
            key = 'Lua.' .. key
        end
        if type(field) ~= 'table' then
            setter(key, field)
            return
        end
        local _, dotCount = key:gsub('%.', '')
        if dotCount >= 2 then
            setter(key, field)
            return
        end
        for k, v in pairs(field) do
            keys[#keys+1] = k
            lookInto(v)
            keys[#keys] = nil
        end
    end

    return lookInto
end

---@param uri Uri
---@param data table
---@return boolean changed
function M:applyRC(uri, data)
    local dirUri = ls.fs.parent(uri)
    local oldPack = self.configMap[dirUri]
    local newPack = {}
    self.configMap[dirUri] = newPack
    makeLookInto(function (key, value)
        self:set(dirUri, key, value)
    end)(data)
    if next(newPack) == nil then
        self.configMap[dirUri] = nil
    end
    return not ls.util.equal(oldPack, newPack)
end

---@param uri Uri
---@return boolean changed
function M:removeRC(uri)
    local dirUri = ls.fs.parent(uri)
    local oldPack = self.configMap[dirUri]
    if not oldPack then
        return false
    end
    self.configMap[dirUri] = nil
    return next(oldPack) ~= nil
end

---@param data table
function M:applyClientConfig(data)
    self.clientMap = {}
    makeLookInto(function (key, value)
        self:setClient(key, value)
    end)(data)
end

---@param key string
---@param value any
---@return any
local function normalize(key, value)
    local unit = template[key]
    if not unit then
        return value
    end
    if unit:checker(value) then
        return unit:loader(value)
    end
    return unit.default
end

---@param uri Uri
---@param key string
---@param value any
function M:set(uri, key, value)
    if not ls.util.stringStartWith(key, 'Lua.') then
        key = 'Lua.' .. key
    end
    if value == nil then
        local pack = self.configMap[uri]
        if pack then
            pack[key] = nil
        end
        return
    end
    value = normalize(key, value)
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

---@param key string
---@param value any
function M:setClient(key, value)
    if not ls.util.stringStartWith(key, 'Lua.') then
        key = 'Lua.' .. key
    end
    self.clientMap[key] = normalize(key, value)
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

---@param uri Uri?
---@param key string
---@return any
function M:get(uri, key)
    if uri and uri ~= '' then
        if not ls.util.stringStartWith(uri, self.root, ls.env.IGNORE_CASE) then
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
    end
    local clientValue = self.clientMap[key]
    if clientValue ~= nil then
        return clientValue
    end
    local unit = template[key]
    if unit then
        return unit.default
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
