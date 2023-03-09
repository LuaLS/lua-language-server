local config    = require 'config'
local util      = require 'utility'
local guide     = require 'parser.guide'
local workspace = require 'workspace'
local files     = require 'files'
local furi      = require 'file-uri'
local rpath     = require 'workspace.require-path'
local vm        = require 'vm'
local matchKey  = require 'core.matchkey'

---@class auto-require
local m = {}

---@type table<uri, true>
m.validUris = {}

---@param state parser.state
---@return parser.object?
function m.getTargetSource(state)
    local targetReturns = state.ast.returns
    if not targetReturns then
        return nil
    end
    local targetSource = targetReturns[1] and targetReturns[1][1]
    if not targetSource then
        return nil
    end
    if  targetSource.type ~= 'getlocal'
    and targetSource.type ~= 'table'
    and targetSource.type ~= 'function' then
        return nil
    end
    return targetSource
end

function m.check(state, word, position, callback)
    local globals = util.arrayToHash(config.get(state.uri, 'Lua.diagnostics.globals'))
    local locals = guide.getVisibleLocals(state.ast, position)
    for uri in files.eachFile(state.uri) do
        if uri == guide.getUri(state.ast) then
            goto CONTINUE
        end
        if not m.validUris[uri] then
            goto CONTINUE
        end
        local path = furi.decode(uri)
        local relativePath = workspace.getRelativePath(path)
        local infos = rpath.getVisiblePath(uri, path)
        local testedStem = { }
        for _, sr in ipairs(infos) do
            local stemName
            if sr.searcher == '[[meta]]' then
                stemName = sr.name
            else
                local pattern = sr.searcher
                    : gsub("(%p)", "%%%1")
                    : gsub("%%%?", "(.-)")

                local stemPath = relativePath:match(pattern)
                if not stemPath then
                    goto INNER_CONTINUE
                end

                stemName = stemPath:match("[%a_][%w_]*$")

                if not stemName or testedStem[stemName] then
                    goto INNER_CONTINUE
                end
            end
            testedStem[stemName] = true

            if  not locals[stemName]
            and not vm.hasGlobalSets(state.uri, 'variable', stemName)
            and not globals[stemName]
            and matchKey(word, stemName) then
                local targetState = files.getState(uri)
                if not targetState then
                    goto INNER_CONTINUE
                end
                local targetSource = m.getTargetSource(targetState)
                if not targetSource then
                    goto INNER_CONTINUE
                end
                if  targetSource.type == 'getlocal'
                and vm.getDeprecated(targetSource.node) then
                    goto INNER_CONTINUE
                end
                callback(uri, stemName, targetSource)
            end
            ::INNER_CONTINUE::
        end
        ::CONTINUE::
    end
end

files.watch(function (ev, uri)
    if ev == 'update'
    or ev == 'remove' then
        m.validUris[uri] = nil
    end
    if ev == 'compile' then
        local state = files.getLastState(uri)
        if state and m.getTargetSource(state) then
            m.validUris[uri] = true
        end
    end
end)

return m
