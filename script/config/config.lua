local util   = require 'utility'
local define = require 'proto.define'
local keyword = require "core.keyword"

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
    return true
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
    Lua = {
        runtime = {
            version             = Type.String >> 'Lua 5.4',
            path                = Type.Array(Type.String) >> {
                "?.lua",
                "?/init.lua",
                "?/?.lua"
            },
            special             = Type.Hash(Type.String, Type.String),
            meta                = Type.String >> '${version} ${language}',
            unicodeName         = Type.Boolean,
            nonstandardSymbol   = Type.Hash(Type.String, Type.Boolean, ';'),
            plugin              = Type.String,
            fileEncoding        = Type.String >> 'utf8',
            builtin             = Type.Hash(Type.String, Type.String),
        },
        diagnostics = {
            enable              = Type.Boolean >> true,
            globals             = Type.Hash(Type.String, Type.Boolean, ';'),
            disable             = Type.Hash(Type.String, Type.Boolean, ';'),
            severity            = Type.Hash(Type.String, Type.String) >> util.deepCopy(define.DiagnosticDefaultSeverity),
            neededFileStatus    = Type.Hash(Type.String, Type.String) >> util.deepCopy(define.DiagnosticDefaultNeededFileStatus),
            workspaceDelay      = Type.Integer >> 0,
            workspaceRate       = Type.Integer >> 100,
        },
        workspace = {
            ignoreDir           = Type.Hash(Type.String, Type.Boolean, ';'),
            ignoreSubmodules    = Type.Boolean >> true,
            useGitIgnore        = Type.Boolean >> true,
            maxPreload          = Type.Integer >> 1000,
            preloadFileSize     = Type.Integer >> 100,
            library             = Type.Hash(Type.String, Type.Boolean, ';'),
        },
        completion = {
            enable              = Type.Boolean >> true,
            callSnippet         = Type.String  >> 'Disable',
            keywordSnippet      = Type.String  >> 'Replace',
            displayContext      = Type.Integer >> 6,
            workspaceWord       = Type.Boolean >> true,
            autoRequire         = Type.Boolean >> true,
            showParams          = Type.Boolean >> true,
        },
        signatureHelp = {
            enable              = Type.Boolean >> true,
        },
        hover = {
            enable              = Type.Boolean >> true,
            viewString          = Type.Boolean >> true,
            viewStringMax       = Type.Integer >> 1000,
            viewNumber          = Type.Boolean >> true,
            previewFields       = Type.Integer >> 20,
            enumsLimit          = Type.Integer >> 5,
        },
        color = {
            mode                = Type.String  >> 'Semantic',
        },
        hint = {
            enable              = Type.Boolean >> false,
            paramType           = Type.Boolean >> true,
            setType             = Type.Boolean >> false,
            paramName           = Type.Boolean >> true,
        },
        window = {
            statusBar           = Type.Boolean >> true,
            progressBar         = Type.Boolean >> true,
        },
        telemetry = {
            enable              = Type.Or(Type.Boolean, Type.Nil)
        },
    },
    files = {
        associations            = Type.Hash(Type.String, Type.String),
        exclude                 = Type.Hash(Type.String, Type.Boolean),
    },
    editor = {
        semanticHighlighting    = Type.Or(Type.Boolean, Type.String),
        acceptSuggestionOnEnter = Type.String  >> 'on',
    },
}

local m = {}

return m
