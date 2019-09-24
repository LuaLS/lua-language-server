local guide = require 'parser.guide'

local m = {}

function m.search(state, ast, source)
    if not source then
        return
    end
    if state.cache[source] then
        return
    end
    state.cache[source] = true
    local f = m['as' .. source.type]
    if not f then
        return
    end
    f(state, ast, source)
end

function m.asgetlocal(state, ast, source)
    local loc = ast.root[source.loc]
    m.search(state, ast, loc)
end

function m.assetlocal(state, ast, source)
    local loc = ast.root[source.loc]
    m.search(state, ast, loc)
    state.callback(source, ast.uri)
end

function m.aslocal(state, ast, source)
    state.callback(source, ast.uri)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            m.search(state, ast, ast.root[ref])
        end
    end
end

function m.assetglobal(state, ast, source)
    local name = source[1]
    guide.eachSourceOf(ast.root, 'setglobal', function (src)
        if src[1] == name then
            state.callback(src, ast.uri)
        end
    end)
end

function m.asgetglobal(state, ast, source)
    local name = source[1]
    guide.eachSourceOf(ast.root, 'setglobal', function (src)
        if src[1] == name then
            state.callback(src, ast.uri)
        end
    end)
end

return function (ast, text, offset)
    local results = {}
    local state = {
        cache = {},
        callback = function (target, uri)
            results[#results+1] = {
                uri    = uri or ast.uri,
                source = source,
                target = target,
            }
        end
    }
    guide.eachSource(ast.root, offset, function (source)
        m.search(state, ast, source)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
