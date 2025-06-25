local util   = require 'utility'
local define = require 'proto.define'
local diag   = require 'proto.diagnostic'

---@class config.unit
---@field caller function
---@field loader function
---@field _checker fun(self: config.unit, value: any): boolean
---@field name     string
---@operator shl:  config.unit
---@operator shr:  config.unit
---@operator call: config.unit
local mt = {}
mt.__index = mt

function mt:__call(...)
    self:caller(...)
    return self
end

function mt:__shr(default)
    self.default = default
    self.hasDefault = true
    return self
end

function mt:__shl(enums)
    self.enums = enums
    return self
end

function mt:checker(v)
    if self.enums then
        local ok
        for _, enum in ipairs(self.enums) do
            if util.equal(enum, v) then
                ok = true
                break
            end
        end
        if not ok then
            return false
        end
    end
    return self:_checker(v)
end

local units = {}

local function register(name, default, checker, loader, caller)
    units[name] = {
        name     = name,
        default  = default,
        _checker = checker,
        loader   = loader,
        caller   = caller,
    }
end

---@class config.master
---@field [string] config.unit
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
end, function (self, v)
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
    if #value == 0 then
        for k in pairs(value) do
            if self.sub:checker(k) then
                t[#t+1] = self.sub:loader(k)
            end
        end
    else
        for _, v in ipairs(value) do
            if self.sub:checker(v) then
                t[#t+1] = self.sub:loader(v)
            end
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
        for s in value:gmatch('[^' .. self.sep .. ']+') do
            t[s] = true
        end
        return t
    end
end, function (self, subkey, subvalue, sep)
    self.subkey   = subkey
    self.subvalue = subvalue
    self.sep      = sep
end)

register('Or', nil, function (self, value)
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
    self.subs = { ... }
end)

---@format disable-next
local template = {
    ['Lua.runtime.version']                 = Type.String >> 'Lua 5.4' << {
                                                'Lua 5.1',
                                                'Lua 5.2',
                                                'Lua 5.3',
                                                'Lua 5.4',
                                                'LuaJIT',
                                            },
    ['Lua.runtime.path']                    = Type.Array(Type.String) >> {
                                                "?.lua",
                                                "?/init.lua",
                                            },
    ['Lua.runtime.pathStrict']              = Type.Boolean >> false,
    ['Lua.runtime.special']                 = Type.Hash(
                                                Type.String,
                                                Type.String >> 'require' << {
                                                    '_G',
                                                    'rawset',
                                                    'rawget',
                                                    'setmetatable',
                                                    'require',
                                                    'dofile',
                                                    'loadfile',
                                                    'pcall',
                                                    'xpcall',
                                                    'assert',
                                                    'error',
                                                    'type',
                                                    'os.exit',
                                                }
                                            ),
    ['Lua.runtime.meta']                    = Type.String >> '${version} ${language} ${encoding}',
    ['Lua.runtime.unicodeName']             = Type.Boolean,
    ['Lua.runtime.nonstandardSymbol']       = Type.Array(Type.String << {
                                                '//', '/**/',
                                                '`',
                                                '+=', '-=', '*=', '/=', '%=', '^=', '//=',
                                                '|=', '&=', '<<=', '>>=',
                                                '||', '&&', '!', '!=',
                                                'continue',
                                            }),
    ['Lua.runtime.plugin']                  = Type.Or(Type.String, Type.Array(Type.String)) ,
    ['Lua.runtime.pluginArgs']              = Type.Or(Type.Array(Type.String), Type.Hash(Type.String, Type.String)),
    ['Lua.runtime.fileEncoding']            = Type.String >> 'utf8' << {
                                                'utf8',
                                                'ansi',
                                                'utf16le',
                                                'utf16be',
                                            },
    ['Lua.runtime.builtin']                 = Type.Hash(
                                                Type.String << util.getTableKeys(define.BuiltIn, true),
                                                Type.String >> 'default' << {
                                                    'default',
                                                    'enable',
                                                    'disable',
                                                }
                                            )
                                            >> util.deepCopy(define.BuiltIn),
    ['Lua.diagnostics.enable']              = Type.Boolean >> true,
    ['Lua.diagnostics.globals']             = Type.Array(Type.String),
    ['Lua.diagnostics.globalsRegex']        = Type.Array(Type.String),
    ['Lua.diagnostics.disable']             = Type.Array(Type.String << util.getTableKeys(diag.getDiagAndErrNameMap(), true)),
    ['Lua.diagnostics.severity']            = Type.Hash(
                                                Type.String << util.getTableKeys(define.DiagnosticDefaultNeededFileStatus, true),
                                                Type.String << {
                                                    'Error',
                                                    'Warning',
                                                    'Information',
                                                    'Hint',
                                                    'Error!',
                                                    'Warning!',
                                                    'Information!',
                                                    'Hint!',
                                                }
                                            )
                                            >> util.deepCopy(define.DiagnosticDefaultSeverity),
    ['Lua.diagnostics.neededFileStatus']    = Type.Hash(
                                                Type.String << util.getTableKeys(define.DiagnosticDefaultNeededFileStatus, true),
                                                Type.String << {
                                                    'Any',
                                                    'Opened',
                                                    'None',
                                                    'Any!',
                                                    'Opened!',
                                                    'None!',
                                                }
                                            )
                                            >> util.deepCopy(define.DiagnosticDefaultNeededFileStatus),
    ['Lua.diagnostics.groupSeverity']       = Type.Hash(
                                                Type.String << util.getTableKeys(define.DiagnosticDefaultGroupSeverity, true),
                                                Type.String << {
                                                    'Error',
                                                    'Warning',
                                                    'Information',
                                                    'Hint',
                                                    'Fallback',
                                                }
                                            )
                                            >> util.deepCopy(define.DiagnosticDefaultGroupSeverity),
    ['Lua.diagnostics.groupFileStatus']     = Type.Hash(
                                                Type.String << util.getTableKeys(define.DiagnosticDefaultGroupFileStatus, true),
                                                Type.String << {
                                                    'Any',
                                                    'Opened',
                                                    'None',
                                                    'Fallback',
                                                }
                                            )
                                            >> util.deepCopy(define.DiagnosticDefaultGroupFileStatus),
    ['Lua.diagnostics.disableScheme']       = Type.Array(Type.String) >> { 'git' },
    ['Lua.diagnostics.workspaceEvent']      = Type.String >> 'OnSave' << {
                                                'OnChange',
                                                'OnSave',
                                                'None',
                                            },
    ['Lua.diagnostics.workspaceDelay']      = Type.Integer >> 3000,
    ['Lua.diagnostics.workspaceRate']       = Type.Integer >> 100,
    ['Lua.diagnostics.libraryFiles']        = Type.String  >> 'Opened' << {
                                                'Enable',
                                                'Opened',
                                                'Disable',
                                            },
    ['Lua.diagnostics.ignoredFiles']        = Type.String  >> 'Opened' << {
                                                'Enable',
                                                'Opened',
                                                'Disable',
                                            },
    ['Lua.diagnostics.unusedLocalExclude']  = Type.Array(Type.String),
    ['Lua.workspace.ignoreDir']             = Type.Array(Type.String) >> {
                                                '.vscode',
                                            },
    ['Lua.workspace.ignoreSubmodules']      = Type.Boolean >> true,
    ['Lua.workspace.useGitIgnore']          = Type.Boolean >> true,
    ['Lua.workspace.maxPreload']            = Type.Integer >> 5000,
    ['Lua.workspace.preloadFileSize']       = Type.Integer >> 500,
    ['Lua.workspace.library']               = Type.Array(Type.String),
    ['Lua.workspace.checkThirdParty']       = Type.Or(Type.String >> 'Ask' << {
                                                'Ask',
                                                'Apply',
                                                'ApplyInMemory',
                                                'Disable',
                                            }, Type.Boolean),
    ['Lua.workspace.userThirdParty']        = Type.Array(Type.String),
    ['Lua.completion.enable']               = Type.Boolean >> true,
    ['Lua.completion.callSnippet']          = Type.String  >> 'Disable' << {
                                                'Disable',
                                                'Both',
                                                'Replace',
                                            },
    ['Lua.completion.keywordSnippet']       = Type.String  >> 'Replace' << {
                                                'Disable',
                                                'Both',
                                                'Replace',
                                            },
    ['Lua.completion.displayContext']       = Type.Integer >> 0,
    ['Lua.completion.workspaceWord']        = Type.Boolean >> true,
    ['Lua.completion.showWord']             = Type.String  >> 'Fallback' << {
                                                'Enable',
                                                'Fallback',
                                                'Disable',
                                            },
    ['Lua.completion.autoRequire']          = Type.Boolean >> true,
    ['Lua.completion.showParams']           = Type.Boolean >> true,
    ['Lua.completion.requireSeparator']     = Type.String  >> '.',
    ['Lua.completion.postfix']              = Type.String  >> '@',
    ['Lua.signatureHelp.enable']            = Type.Boolean >> true,
    ['Lua.hover.enable']                    = Type.Boolean >> true,
    ['Lua.hover.viewString']                = Type.Boolean >> true,
    ['Lua.hover.viewStringMax']             = Type.Integer >> 1000,
    ['Lua.hover.viewNumber']                = Type.Boolean >> true,
    ['Lua.hover.previewFields']             = Type.Integer >> 10,
    ['Lua.hover.enumsLimit']                = Type.Integer >> 5,
    ['Lua.hover.expandAlias']               = Type.Boolean >> true,
    ['Lua.semantic.enable']                 = Type.Boolean >> true,
    ['Lua.semantic.variable']               = Type.Boolean >> true,
    ['Lua.semantic.annotation']             = Type.Boolean >> true,
    ['Lua.semantic.keyword']                = Type.Boolean >> false,
    ['Lua.hint.enable']                     = Type.Boolean >> false,
    ['Lua.hint.paramType']                  = Type.Boolean >> true,
    ['Lua.hint.setType']                    = Type.Boolean >> false,
    ['Lua.hint.paramName']                  = Type.String  >> 'All' << {
                                                'All',
                                                'Literal',
                                                'Disable',
                                            },
    ['Lua.hint.await']                      = Type.Boolean >> true,
    ['Lua.hint.awaitPropagate']             = Type.Boolean >> false,
    ['Lua.hint.arrayIndex']                 = Type.String >> 'Auto' << {
                                                'Enable',
                                                'Auto',
                                                'Disable',
                                            },
    ['Lua.hint.semicolon']                  = Type.String >> 'SameLine' << {
                                                'All',
                                                'SameLine',
                                                'Disable',
                                            },
    ['Lua.window.statusBar']                = Type.Boolean >> true,
    ['Lua.window.progressBar']              = Type.Boolean >> true,
    ['Lua.codeLens.enable']                 = Type.Boolean >> false,
    ['Lua.format.enable']                   = Type.Boolean >> true,
    ['Lua.format.defaultConfig']            = Type.Hash(Type.String, Type.String)
                                            >> {},
    ['Lua.typeFormat.config']               = Type.Hash(Type.String, Type.String)
                                            >> {
                                                format_line = "true",
                                                auto_complete_end = "true",
                                                auto_complete_table_sep = "true"
                                            },
    ['Lua.spell.dict']                      = Type.Array(Type.String),
    ['Lua.nameStyle.config']                = Type.Hash(Type.String, Type.Or(Type.String, Type.Array(Type.Hash(Type.String, Type.String))))
                                            >> {},
    ['Lua.misc.parameters']                 = Type.Array(Type.String),
    ['Lua.misc.executablePath']             = Type.String,
    ['Lua.language.fixIndent']              = Type.Boolean >> true,
    ['Lua.language.completeAnnotation']     = Type.Boolean >> true,
    ['Lua.type.castNumberToInteger']        = Type.Boolean >> true,
    ['Lua.type.weakUnionCheck']             = Type.Boolean >> false,
    ['Lua.type.maxUnionVariants']           = Type.Integer >> 0,
    ['Lua.type.weakNilCheck']               = Type.Boolean >> false,
    ['Lua.type.inferParamType']             = Type.Boolean >> false,
    ['Lua.type.checkTableShape']            = Type.Boolean >> false,
    ['Lua.type.inferTableSize']             = Type.Integer >> 10,
    ['Lua.doc.privateName']                 = Type.Array(Type.String),
    ['Lua.doc.protectedName']               = Type.Array(Type.String),
    ['Lua.doc.packageName']                 = Type.Array(Type.String),
    ['Lua.doc.regengine']                   = Type.String >> 'glob' << {
                                                'glob',
                                                'lua',
                                            },
    --testma
    ["Lua.docScriptPath"]                   = Type.String,
    ["Lua.addonRepositoryPath"]             = Type.String,
    -- VSCode
    ["Lua.addonManager.enable"]             = Type.Boolean >> true,
    ["Lua.addonManager.repositoryPath"]     = Type.String,
    ["Lua.addonManager.repositoryBranch"]   = Type.String,
    ['files.associations']                  = Type.Hash(Type.String, Type.String),
                                            -- copy from VSCode default
    ['files.exclude']                       = Type.Hash(Type.String, Type.Boolean) >> {
                                                ["**/.DS_Store"] = true,
                                                ["**/.git"]      = true,
                                                ["**/.hg"]       = true,
                                                ["**/.svn"]      = true,
                                                ["**/CVS"]       = true,
                                                ["**/Thumbs.db"] = true,
                                            },
    ['editor.semanticHighlighting.enabled'] = Type.Or(Type.Boolean, Type.String),
    ['editor.acceptSuggestionOnEnter']      = Type.String  >> 'on',
}

return template
