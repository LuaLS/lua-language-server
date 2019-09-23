local guide = require 'parser.guide'

local m = {}

function m.asgetlocal(ast, source, callback)
    local loc = ast.root[source.loc]
    if not loc then
        return
    end
    return m.aslocal(ast, loc, callback)
end

function m.assetlocal(ast, source, callback)
    local loc = ast.root[source.loc]
    if not loc then
        return
    end
    return m.aslocal(ast, loc, callback)
end

function m.aslocal(ast, source, callback)
    callback(source, ast.uri)
end

return function (ast, text, offset)
    local results = {}
    guide.eachSource(ast.root, offset, function (source)
        local tp = source.type
        local f = m['as' .. tp]
        if f then
            f(ast, source, function (target, uri)
                results[#results+1] = {
                    uri    = uri or ast.uri,
                    source = source,
                    target = target,
                }
            end)
        end
    end)
    if #results == 0 then
        return nil
    end
    return results
end
