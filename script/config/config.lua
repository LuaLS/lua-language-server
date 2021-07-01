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

local function push(name, default, checker, loader, caller)
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

push('Boolean', false, function (self, v)
    return type(v) == 'boolean'
end, function (self, v)
    return v
end)

push('Integer', 0, function (self, v)
    return type(v) == 'number'
end,function (self, v)
    return math.floor(v)
end)

push('String', '', function (self, v)
    return type(v) == 'string'
end, function (self, v)
    return tostring(v)
end)

push('Nil', nil, function (self, v)
    return type(v) == 'nil'
end, function (self, v)
    return nil
end)

push('Array', {}, function (self, value)
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

push('Hash', {}, function (self, value)
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

push('Or', {}, function (self, value)
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
    ['Lua.runtime.verion']                  = Type.String >> 'Lua 5.4',
    ['Lua.runtime.path']                    = Type.String >> {
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
    ['editor.semanticHighlighting']         = Type.Or(Type.Boolean, Type.String),
    ['editor.acceptSuggestionOnEnter']      = Type.String  >> 'on',
}

local m = {}

local function updateConfig(key, value)
    local current = m
    local strs = {}
    for str in key:gmatch('[^%.]+') do
        strs[#strs+1] = str
    end
    for i = 1, #strs - 1 do
        local str = strs[i]
        if not current[str] then
            current[str] = {}
        end
        current = current[str]
    end
    local lastStr = strs[#strs]
    current[lastStr] = value
end

local function pushConfig(key, value)
    local config = Template[key]
    if not config then
        return
    end
    if config:checker(value) then
        updateConfig(key, config:loader(value))
    else
        updateConfig(key, config.default)
    end
end

for key in pairs(Template) do
    pushConfig(key)
end

return m
