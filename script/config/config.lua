local util   = require 'utility'
local define = require 'proto.define'
local timer  = require 'timer'
local scope  = require 'workspace.scope'

---@alias config.source '"client"'|'"path"'|'"local"'

---@class config.unit
---@field caller function
local mt = {}
mt.__index = mt

function mt:__call(...)
    self:caller(...)
    return self
end

function mt:__shr(default)
    self.default = default
    return self
end

local units = {}

local function register(name, default, checker, loader, caller)
    units[name] = {
        default = default,
        checker = checker,
        loader  = loader,
        caller  = caller,
    }
end

local Type = setmetatable({}, { __index = function (_, name)
    local unit = {}
    for k, v in pairs(units[name]) do
        unit[k] = v
    end
    return setmetatable(unit, mt)
end })

register('Boolean', false, function (self, v)
    return type(v) == 'boolean'
end, function (self, v)
    return v
end)

register('Integer', 0, function (self, v)
    return type(v) == 'number'
end,function (self, v)
    return math.floor(v)
end)

register('String', '', function (self, v)
    return type(v) == 'string'
end, function (self, v)
    return tostring(v)
end)

register('Nil', nil, function (self, v)
    return type(v) == 'nil'
end, function (self, v)
    return nil
end)

register('Array', {}, function (self, value)
    return type(value) == 'table'
end, function (self, value)
    local t = {}
    for _, v in ipairs(value) do
        if self.sub:checker(v) then
            t[#t+1] = self.sub:loader(v)
        end
    end
    return t
end, function (self, sub)
    self.sub = sub
end)

register('Hash', {}, function (self, value)
    if type(value) == 'table' then
        if #value == 0 then
            for k, v in pairs(value) do
                if not self.subkey:checker(k)
                or not self.subvalue:checker(v) then
                    return false
                end
            end
        else
            if not self.subvalue:checker(true) then
                return false
            end
            for _, v in ipairs(value) do
                if not self.subkey:checker(v) then
                    return false
                end
            end
        end
        return true
    end
    if type(value) == 'string' then
        return  self.subkey:checker('')
            and self.subvalue:checker(true)
    end
end, function (self, value)
    if type(value) == 'table' then
        local t = {}
        if #value == 0 then
            for k, v in pairs(value) do
                t[k] = v
            end
        else
            for _, k in pairs(value) do
                t[k] = true
            end
        end
        return t
    end
    if type(value) == 'string' then
        local t = {}
        for s in value:gmatch('[^'..self.sep..']+') do
            t[s] = true
        end
        return t
    end
end, function (self, subkey, subvalue, sep)
    self.subkey   = subkey
    self.subvalue = subvalue
    self.sep      = sep
end)

register('Or', {}, function (self, value)
    for _, sub in ipairs(self.subs) do
        if sub:checker(value) then
            return true
        end
    end
    return false
end, function (self, value)
    for _, sub in ipairs(self.subs) do
        if sub:checker(value) then
            return sub:loader(value)
        end
    end
end, function (self, ...)
    self.subs = {...}
end)

local Template = {
    ['Lua.runtime.version']                 = Type.String >> 'Lua 5.4',
    ['Lua.runtime.path']                    = Type.Array(Type.String) >> {
                                                "?.lua",
                                                "?/init.lua",
                                            },
    ['Lua.runtime.pathStrict']              = Type.Boolean >> false,
    ['Lua.runtime.special']                 = Type.Hash(Type.String, Type.String),
    ['Lua.runtime.meta']                    = Type.String >> '${version} ${language} ${encoding}',
    ['Lua.runtime.unicodeName']             = Type.Boolean,
    ['Lua.runtime.nonstandardSymbol']       = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.runtime.plugin']                  = Type.String,
    ['Lua.runtime.fileEncoding']            = Type.String >> 'utf8',
    ['Lua.runtime.builtin']                 = Type.Hash(Type.String, Type.String),
    ['Lua.diagnostics.enable']              = Type.Boolean >> true,
    ['Lua.diagnostics.globals']             = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.diagnostics.disable']             = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.diagnostics.severity']            = Type.Hash(Type.String, Type.String)
                                            >> util.deepCopy(define.DiagnosticDefaultSeverity),
    ['Lua.diagnostics.neededFileStatus']    = Type.Hash(Type.String, Type.String)
                                            >> util.deepCopy(define.DiagnosticDefaultNeededFileStatus),
    ['Lua.diagnostics.workspaceDelay']      = Type.Integer >> 0,
    ['Lua.diagnostics.workspaceRate']       = Type.Integer >> 100,
    ['Lua.diagnostics.libraryFiles']        = Type.String  >> 'Opened',
    ['Lua.diagnostics.ignoredFiles']        = Type.String  >> 'Opened',
    ['Lua.workspace.ignoreDir']             = Type.Array(Type.String),
    ['Lua.workspace.ignoreSubmodules']      = Type.Boolean >> true,
    ['Lua.workspace.useGitIgnore']          = Type.Boolean >> true,
    ['Lua.workspace.maxPreload']            = Type.Integer >> 1000,
    ['Lua.workspace.preloadFileSize']       = Type.Integer >> 100,
    ['Lua.workspace.library']               = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.workspace.checkThirdParty']       = Type.Boolean >> true,
    ['Lua.workspace.userThirdParty']        = Type.Array(Type.String),
    ['Lua.completion.enable']               = Type.Boolean >> true,
    ['Lua.completion.callSnippet']          = Type.String  >> 'Disable',
    ['Lua.completion.keywordSnippet']       = Type.String  >> 'Replace',
    ['Lua.completion.displayContext']       = Type.Integer >> 0,
    ['Lua.completion.workspaceWord']        = Type.Boolean >> true,
    ['Lua.completion.showWord']             = Type.String  >> 'Fallback',
    ['Lua.completion.autoRequire']          = Type.Boolean >> true,
    ['Lua.completion.showParams']           = Type.Boolean >> true,
    ['Lua.completion.requireSeparator']     = Type.String  >> '.',
    ['Lua.completion.postfix']              = Type.String  >> '@',
    ['Lua.signatureHelp.enable']            = Type.Boolean >> true,
    ['Lua.hover.enable']                    = Type.Boolean >> true,
    ['Lua.hover.viewString']                = Type.Boolean >> true,
    ['Lua.hover.viewStringMax']             = Type.Integer >> 1000,
    ['Lua.hover.viewNumber']                = Type.Boolean >> true,
    ['Lua.hover.previewFields']             = Type.Integer >> 20,
    ['Lua.hover.enumsLimit']                = Type.Integer >> 5,
    ['Lua.semantic.enable']                 = Type.Boolean >> true,
    ['Lua.semantic.variable']               = Type.Boolean >> true,
    ['Lua.semantic.annotation']             = Type.Boolean >> true,
    ['Lua.semantic.keyword']                = Type.Boolean >> false,
    ['Lua.hint.enable']                     = Type.Boolean >> false,
    ['Lua.hint.paramType']                  = Type.Boolean >> true,
    ['Lua.hint.setType']                    = Type.Boolean >> false,
    ['Lua.hint.paramName']                  = Type.String  >> 'All',
    ['Lua.hint.await']                      = Type.Boolean >> true,
    ['Lua.hint.arrayIndex']                 = Type.Boolean >> 'Auto',
    ['Lua.window.statusBar']                = Type.Boolean >> true,
    ['Lua.window.progressBar']              = Type.Boolean >> true,
    ['Lua.IntelliSense.traceLocalSet']      = Type.Boolean >> false,
    ['Lua.IntelliSense.traceReturn']        = Type.Boolean >> false,
    ['Lua.IntelliSense.traceBeSetted']      = Type.Boolean >> false,
    ['Lua.IntelliSense.traceFieldInject']   = Type.Boolean >> false,
    ['Lua.telemetry.enable']                = Type.Or(Type.Boolean >> false, Type.Nil),
    ['files.associations']                  = Type.Hash(Type.String, Type.String),
    ['files.exclude']                       = Type.Hash(Type.String, Type.Boolean),
    ['editor.semanticHighlighting.enabled'] = Type.Or(Type.Boolean, Type.String),
    ['editor.acceptSuggestionOnEnter']      = Type.String  >> 'on',
}

---@class config.api
local m = {}
m.watchList = {}

m.NULL = {}

m.nullSymbols = {
    [m.NULL] = true,
}

---@param scp      scope
---@param key      string
---@param nowValue any
---@param rawValue any
local function update(scp, key, nowValue, rawValue)
    local now = scp:get 'config.now'
    local raw = scp:get 'config.raw'

    now[key] = nowValue
    raw[key] = rawValue
end

---@param uri uri
---@param key? string
---@return scope
local function getScope(uri, key)
    local raw = scope.override:get 'config.raw'
    if raw then
        if not key or raw[key] ~= nil then
            return scope.override
        end
    end
    if uri then
        ---@type scope
        local scp = scope.getFolder(uri) or scope.getLinkedScope(uri)
        if scp then
            if not key
            or (scp:get 'config.raw' and scp:get 'config.raw' [key] ~= nil) then
                return scp
            end
        end
    end
    return scope.fallback
end

---@param scp   scope
---@param key   string
---@param value any
function m.setByScope(scp, key, value)
    local unit = Template[key]
    if not unit then
        return false
    end
    local raw = scp:get 'config.raw'
    if util.equal(raw[key], value) then
        return false
    end
    if unit:checker(value) then
        update(scp, key, unit:loader(value), value)
    else
        update(scp, key, unit.default, unit.default)
    end
    return true
end

---@param uri   uri
---@param key   string
---@param value any
function m.set(uri, key, value)
    local scp = getScope(uri)
    local oldValue = m.get(uri, key)
    m.setByScope(scp, key, value)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

function m.add(uri, key, value)
    local unit = Template[key]
    if not unit then
        return false
    end
    local list = m.getRaw(uri, key)
    if type(list) ~= 'table' then
        return false
    end
    local copyed = {}
    for i, v in ipairs(list) do
        if util.equal(v, value) then
            return false
        end
        copyed[i] = v
    end
    copyed[#copyed+1] = value
    local oldValue = m.get(uri, key)
    m.set(uri, key, copyed)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

function m.prop(uri, key, prop, value)
    local unit = Template[key]
    if not unit then
        return false
    end
    local map = m.getRaw(uri, key)
    if type(map) ~= 'table' then
        return false
    end
    if util.equal(map[prop], value) then
        return false
    end
    local copyed = {}
    for k, v in pairs(map) do
        copyed[k] = v
    end
    copyed[prop] = value
    local oldValue = m.get(uri, key)
    m.set(uri, key, copyed)
    local newValue = m.get(uri, key)
    if not util.equal(oldValue, newValue) then
        m.event(uri, key, newValue, oldValue)
        return true
    end
    return false
end

---@param uri uri
---@param key string
---@return any
function m.get(uri, key)
    local scp = getScope(uri, key)
    local value = scp:get 'config.now' [key]
    if value == nil then
        value = Template[key].default
    end
    if value == m.NULL then
        value = nil
    end
    return value
end

---@param uri uri
---@param key string
---@return any
function m.getRaw(uri, key)
    local scp = getScope(uri, key)
    local value = scp:get 'config.raw' [key]
    if value == nil then
        value = Template[key].default
    end
    if value == m.NULL then
        value = nil
    end
    return value
end

---@param scp  scope
---@param ...  table
function m.update(scp, ...)
    local oldConfig = scp:get 'config.now'
    local newConfig = {}
    scp:set('config.now', newConfig)
    scp:set('config.raw', {})

    local function expand(t, left)
        for key, value in pairs(t) do
            local fullKey = key
            if left then
                fullKey = left .. '.' .. key
            end
            if m.nullSymbols[value] then
                value = m.NULL
            end
            if Template[fullKey] then
                m.setByScope(scp, fullKey, value)
            elseif Template['Lua.' .. fullKey] then
                m.setByScope(scp, 'Lua.' .. fullKey, value)
            elseif type(value) == 'table' then
                expand(value, fullKey)
            end
        end
    end

    local news = table.pack(...)
    for i = 1, news.n do
        if news[i] then
            expand(news[i])
        end
    end

    -- compare then fire event
    if oldConfig then
        for key, oldValue in pairs(oldConfig) do
            local newValue = newConfig[key]
            if not util.equal(oldValue, newValue) then
                m.event(scp.uri, key, newValue, oldValue)
            end
        end
    end

    m.event(scp.uri, '')
end

---@param callback fun(uri: uri, key: string, value: any, oldValue: any)
function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.event(uri, key, value, oldValue)
    if not m.changes then
        m.changes = {}
        timer.wait(0, function ()
            local delay = m.changes
            m.changes = nil
            for _, info in ipairs(delay) do
                for _, callback in ipairs(m.watchList) do
                    callback(info.uri, info.key, info.value, info.oldValue)
                end
            end
        end)
    end
    m.changes[#m.changes+1] = {
        uri      = uri,
        key      = key,
        value    = value,
        oldValue = oldValue,
    }
end

function m.addNullSymbol(null)
    m.nullSymbols[null] = true
end

m.update(scope.fallback, {})

return m
