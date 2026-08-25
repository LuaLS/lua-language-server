local define  = require 'feature.diagnostic.define'
local disable = require 'feature.diagnostic.disable'
local merge   = require 'feature.diagnostic.merge'

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

---@type (fun(param: Feature.Diagnostic.Param): Feature.Diagnostic[])[]
local providers = {}

---@param callback fun(param: Feature.Diagnostic.Param): Feature.Diagnostic[]
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

---@param uri Uri
---@return Feature.Diagnostic[]
ls.feature.diagnostic = function (uri)
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
    local ast = document.ast
    if not ast then
        return {}
    end

    local vfile = scope.vm:getFile(uri)
    local syntaxErrors = vfile and vfile.coder and vfile.coder.errors or {}

    local disables = ls.util.arrayToHash(scope.config:get(uri, 'Lua.diagnostics.disable') or {})
    local opened = document.file:isOpenedByClient()
    local disableRanges = disable.buildRanges(ast)

    ---@type Feature.Diagnostic.Param
    local param = {
        uri      = uri,
        scope    = scope,
        document = document,
        ast      = ast,
        errors   = syntaxErrors,
    }

    local results = {}
    for _, provider in ipairs(providers) do
        for _, diag in ipairs(provider(param)) do
            if disables[diag.code] then
                goto continue
            end
            local isSyntax = diag.data == 'syntax'
            local row = ast.lexer:rowcol(diag.start)
            if disable.isDisabled(disableRanges, row, diag.code, isSyntax) then
                goto continue
            end
            if not isSyntax then
                if not acceptSemantic(scope, uri, diag, opened) then
                    goto continue
                end
            end
            results[#results+1] = diag
            ::continue::
        end
    end

    return merge.merge(results)
end

require 'feature.diagnostic.providers.syntax'
require 'feature.diagnostic.providers.empty-block'
require 'feature.diagnostic.providers.unused-local'
require 'feature.diagnostic.file'
require 'feature.diagnostic.scope'
