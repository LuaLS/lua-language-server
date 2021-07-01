local util   = require 'utility'
local define = require 'proto.define'

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
                                                "?/?.lua"
                                            },
    ['Lua.runtime.special']                 = Type.Hash(Type.String, Type.String),
    ['Lua.runtime.meta']                    = Type.String >> '${version} ${language}',
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
    ['Lua.workspace.ignoreDir']             = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.workspace.ignoreSubmodules']      = Type.Boolean >> true,
    ['Lua.workspace.useGitIgnore']          = Type.Boolean >> true,
    ['Lua.workspace.maxPreload']            = Type.Integer >> 1000,
    ['Lua.workspace.preloadFileSize']       = Type.Integer >> 100,
    ['Lua.workspace.library']               = Type.Hash(Type.String, Type.Boolean, ';'),
    ['Lua.completion.enable']               = Type.Boolean >> true,
    ['Lua.completion.callSnippet']          = Type.String  >> 'Disable',
    ['Lua.completion.keywordSnippet']       = Type.String  >> 'Replace',
    ['Lua.completion.displayContext']       = Type.Integer >> 6,
    ['Lua.completion.workspaceWord']        = Type.Boolean >> true,
    ['Lua.completion.autoRequire']          = Type.Boolean >> true,
    ['Lua.completion.showParams']           = Type.Boolean >> true,
    ['Lua.signatureHelp.enable']            = Type.Boolean >> true,
    ['Lua.hover.enable']                    = Type.Boolean >> true,
    ['Lua.hover.viewString']                = Type.Boolean >> true,
    ['Lua.hover.viewStringMax']             = Type.Integer >> 1000,
    ['Lua.hover.viewNumber']                = Type.Boolean >> true,
    ['Lua.hover.previewFields']             = Type.Integer >> 20,
    ['Lua.hover.enumsLimit']                = Type.Integer >> 5,
    ['Lua.color.mode']                      = Type.String  >> 'Semantic',
    ['Lua.hint.enable']                     = Type.Boolean >> false,
    ['Lua.hint.paramType']                  = Type.Boolean >> true,
    ['Lua.hint.setType']                    = Type.Boolean >> false,
    ['Lua.hint.paramName']                  = Type.Boolean >> true,
    ['Lua.window.statusBar']                = Type.Boolean >> true,
    ['Lua.window.progressBar']              = Type.Boolean >> true,
    ['Lua.telemetry.enable']                = Type.Or(Type.Boolean, Type.Nil),
    ['files.associations']                  = Type.Hash(Type.String, Type.String),
    ['files.exclude']                       = Type.Hash(Type.String, Type.Boolean),
    ['editor.semanticHighlighting.enabled'] = Type.Or(Type.Boolean, Type.String),
    ['editor.acceptSuggestionOnEnter']      = Type.String  >> 'on',
}

local config = {}

local m = {}

function m.set(key, value)
    local unit = Template[key]
    if not unit then
        return
    end
    if unit:checker(value) then
        config[key] = unit:loader(value)
    else
        config[key] = unit.default
    end
end

function m.get(key)
    return config[key]
end

function m.dump()
    local dump = {}

    local function expand(parent, key, value)
        local left, right = key:match '([^%.]+)%.(.+)'
        if left then
            if not parent[left] then
                parent[left] = {}
            end
            expand(parent[left], right, value)
        else
            parent[key] = value
        end
    end

    for key, value in pairs(config) do
        expand(dump, key, value)
    end

    return dump
end

function m.update(new)
    local function expand(t, left)
        for key, value in pairs(t) do
            local fullKey = key
            if left then
                fullKey = left .. '.' .. key
            end
            if Template[fullKey] then
                m.set(fullKey, value)
            elseif type(value) == 'table' then
                expand(value, fullKey)
            end
        end
    end

    expand(new)
end

for key in pairs(Template) do
    m.set(key)
end

return m
