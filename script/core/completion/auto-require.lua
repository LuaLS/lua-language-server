local config    = require 'config'
local util      = require 'utility'
local guide     = require 'parser.guide'
local workspace = require 'workspace'
local files     = require 'files'
local furi      = require 'file-uri'
local rpath     = require 'workspace.require-path'
local vm        = require 'vm'
local matchKey  = require 'core.matchkey'

local ipairs = ipairs

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
    local hit = false
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
                hit = true
                callback(uri, stemName, targetSource)
            end
            ::INNER_CONTINUE::
        end
        ::CONTINUE::
    end
    -- 如果没命中, 则检查枚举
    if not hit then
        local docs = vm.getDocSets(state.uri)
        for _, doc in ipairs(docs) do
            if doc.type ~= 'doc.enum' or vm.getDeprecated(doc) then
                goto CONTINUE
            end
            -- 检查枚举名是否匹配
            if not (doc.enum[1] == word or doc.enum[1]:match(".*%.([^%.]*)$") == word) then
                goto CONTINUE
            end
            local uri = guide.getUri(doc)
            local targetState = files.getState(uri)
            if not targetState then
                goto CONTINUE
            end
            local targetSource = m.getTargetSource(targetState)
            if not targetSource or (targetSource.type ~= 'getlocal' and targetSource.type ~= 'table') or vm.getDeprecated(targetSource.node) then
                goto CONTINUE
            end
            -- 枚举的完整路径
            local fullKeyPath = ""
            local node = doc.bindSource.parent
            while node do
                -- 检查是否可见
                if not vm.isVisible(state.ast, node) then
                    goto CONTINUE
                end
                if node.type == 'setfield' or node.type == 'getfield' then
                    fullKeyPath = "." .. node.field[1] .. fullKeyPath
                end
                if node.type == 'getlocal' then
                    node = node.node
                    break
                end
                node = node.node
            end
            -- 匹配导出的值, 确定最终路径
            if targetSource.node == node then
                hit = true
            elseif targetSource.type == 'table' then
                for _, value in ipairs(targetSource) do
                    if value.value.node == node then
                        fullKeyPath = "." .. value.value[1] .. fullKeyPath
                        hit = true
                        break
                    end
                end
            end
            if hit then
                callback(guide.getUri(doc), nil, nil, fullKeyPath)
            end
            ::CONTINUE::
        end
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
