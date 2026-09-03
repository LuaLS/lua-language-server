local define  = require 'feature.diagnostic.define'
local disable = require 'feature.diagnostic.disable'

---@class Feature.Diagnostic.Related
---@field uri Uri
---@field start integer
---@field finish integer
---@field message string

---@class Feature.Diagnostic
---@field code string
---@field level integer
---@field start integer
---@field finish integer
---@field message string
---@field data? string
---@field tags? integer[]
---@field related? Feature.Diagnostic.Related[]

---@class Feature.Diagnostic.Param
---@field uri Uri
---@field scope Scope
---@field document Document
---@field ast LuaParser.Ast
---@field errors table[]
---@field vfile VM.Vfile?

---@alias Feature.Diagnostic.Provider async fun(param: Feature.Diagnostic.Param, callback: fun(diag: Feature.Diagnostic))

---@type Feature.Diagnostic.Provider[]
local providers = {}

---@param callback async Feature.Diagnostic.Provider
function ls.feature.provider.diagnostic(callback)
    providers[#providers+1] = callback
end

---@param scope Scope
---@param uri Uri
---@param diag Feature.Diagnostic
---@param opened boolean
---@return boolean
local function acceptSemantic(scope, uri, diag, opened)
    local status = define.getFileStatus(scope, uri, diag.code)
    if status == 'None' then
        return false
    end
    if status == 'Opened' and not opened then
        return false
    end
    diag.level = define.getSeverity(scope, uri, diag.code)
    return true
end

---@async
---@param uri Uri
---@param partialPush? fun(item: Feature.Diagnostic)
---@return Feature.Diagnostic[]
function ls.feature.diagnostic(uri, partialPush)
    local document, scope = ls.scope.findDocument(uri)
    if not document or not scope then
        return {}
    end
    if not scope.config:get(uri, 'Lua.diagnostics.enable') then
        return {}
    end
    local scheme = ls.uri.split(uri)
    local enableScheme = scope.config:get(uri, 'Lua.diagnostics.enableScheme')
    if not ls.util.arrayHas(enableScheme, scheme) then
        return {}
    end

    local vfile = scope.vm:getFile(uri)
    local syntaxErrors = vfile?.coder?.errors or {}

    local ast = document.ast
    if not ast then
        return {}
    end

    local disableRanges = disable.buildRanges(ast)

    local disables = ls.util.arrayToHash(scope.config:get(uri, 'Lua.diagnostics.disable') or {})
    local opened = document.file:isOpenedByClient()
    local positionConverter = document.positionConverter

    ---@type Feature.Diagnostic.Param
    local param = {
        uri      = uri,
        scope    = scope,
        document = document,
        ast      = ast,
        errors   = syntaxErrors,
        vfile    = vfile,
    }

    local function isDisabled(diag, isSyntax)
        if disables[diag.code] then
            return true
        end
        local row = positionConverter:offsetToPosition(diag.start)
        return disable.isDisabled(disableRanges, row, diag.code, isSyntax)
    end

    local results = {}
    local function accept(diag)
        local isSyntax = diag.data == 'syntax'
        if isDisabled(diag, isSyntax) then
            return
        end
        if not isSyntax then
            if not acceptSemantic(scope, uri, diag, opened) then
                return
            end
        end
        results[#results+1] = diag
        partialPush?(diag)
    end

    for _, provider in ipairs(providers) do
        provider(param, accept)
    end

    return results
end

ls.file.onDidChange:on(function (uri)
    local scope = ls.scope.find(uri)
    if scope?.ready then
        ---@cast scope -?
        ls.scope.findVfile(uri)?.diagnostic:refreshNow()
        scope.diagnostic:refreshAfter(1)
    end
end)

---@param scope Scope
ls.scope.onDidLoad:on(function (scope)
    scope.diagnostic:refreshNow()
end)


require 'feature.diagnostic.file'
require 'feature.diagnostic.scope'

require 'feature.diagnostic.providers.syntax'
require 'feature.diagnostic.providers.empty-block'
require 'feature.diagnostic.providers.unused-local'
require 'feature.diagnostic.providers.unused-function'
require 'feature.diagnostic.providers.unused-label'
require 'feature.diagnostic.providers.unused-vararg'
require 'feature.diagnostic.providers.redefined-local'
require 'feature.diagnostic.providers.trailing-space'
require 'feature.diagnostic.providers.redundant-return'
require 'feature.diagnostic.providers.code-after-break'
require 'feature.diagnostic.providers.duplicate-index'
require 'feature.diagnostic.providers.duplicate-doc-param'
require 'feature.diagnostic.providers.duplicate-doc-alias'
require 'feature.diagnostic.providers.unknown-cast-variable'
require 'feature.diagnostic.providers.undefined-doc-name'
require 'feature.diagnostic.providers.undefined-doc-class'
require 'feature.diagnostic.providers.doc-field-no-class'
require 'feature.diagnostic.providers.circle-doc-class'
require 'feature.diagnostic.providers.duplicate-doc-field'
require 'feature.diagnostic.providers.incomplete-signature-doc'
require 'feature.diagnostic.providers.missing-global-doc'
require 'feature.diagnostic.providers.unbalanced-assignments'
require 'feature.diagnostic.providers.unknown-diag-code'
require 'feature.diagnostic.providers.lowercase-global'
require 'feature.diagnostic.providers.global-element'
require 'feature.diagnostic.providers.redundant-value'
require 'feature.diagnostic.providers.count-down-loop'
require 'feature.diagnostic.providers.undefined-doc-param'
require 'feature.diagnostic.providers.close-non-object'
require 'feature.diagnostic.providers.newline-call'
require 'feature.diagnostic.providers.newfield-call'
require 'feature.diagnostic.providers.undefined-field'
require 'feature.diagnostic.providers.undefined-global'
require 'feature.diagnostic.providers.deprecated'
require 'feature.diagnostic.providers.discard-returns'
require 'feature.diagnostic.providers.need-check-nil'
require 'feature.diagnostic.providers.redundant-parameter'
require 'feature.diagnostic.providers.missing-parameter'
require 'feature.diagnostic.providers.assign-type-mismatch'
require 'feature.diagnostic.providers.param-type-mismatch'
require 'feature.diagnostic.providers.return-type-mismatch'
require 'feature.diagnostic.providers.missing-return-value'
require 'feature.diagnostic.providers.redundant-return-value'
require 'feature.diagnostic.providers.global-in-nil-env'
