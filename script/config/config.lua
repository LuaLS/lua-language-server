---@class Config
local M = Class 'Config'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type table<string, table<string, any>?>
    self.configMap = ls.runtime.args.IGNORE_CASE
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
    
end

---@param uri Uri
---@param key string
---@param value any
function M:set(uri, key, value)
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

---@class Config.API
ls.config = {}

---@param scope Scope
---@return Config
function ls.config.create(scope)
    return New 'Config' (scope)
end
