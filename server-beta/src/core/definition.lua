local guide    = require 'parser.guide'
local engineer = require 'core.engineer'

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

function m.aslocal(state, ast, source)
    engineer(ast):eachLocalRef(source, function (src, mode)
        if mode == 'local' or mode == 'set' then
            state.callback(src)
        end
    end)
end

m.asgetlocal = m.aslocal
m.assetlocal = m.aslocal

function m.globals(state, ast, source)
    engineer(ast):eachGloablOfName(source[1], function (src, mode)
        if mode == 'set' then
            state.callback(src)
        end
    end)
end

m.assetglobal = m.globals
m.asgetglobal = m.globals

return function (ast, text, offset)
    local results = {}
    local state = {
        ast = ast,
        cache = {},
    }
    function state.callback(target, uri)
        results[#results+1] = {
            uri    = uri or ast.uri,
            source = state.source,
            target = target,
        }
    end
    guide.eachSource(ast.root, offset, function (source)
        state.source = source
        m.search(state, ast, source)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
