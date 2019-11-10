local guide     = require 'parser.guide'
local workspace = require 'workspace'
local files     = require 'files'
local searcher  = require 'searcher'

local function findDef(source, callback)
    if  source.type ~= 'local'
    and source.type ~= 'getlocal'
    and source.type ~= 'setlocal'
    and source.type ~= 'setglobal'
    and source.type ~= 'getglobal'
    and source.type ~= 'field'
    and source.type ~= 'method'
    and source.type ~= 'string'
    and source.type ~= 'number'
    and source.type ~= 'boolean'
    and source.type ~= 'goto' then
        return
    end
    searcher.eachRef(source, function (info)
        if info.mode == 'declare'
        or info.mode == 'set'
        or info.mode == 'get'
        or info.mode == 'return' then
            local src  = info.source
            local root = guide.getRoot(src)
            local uri  = root.uri
            if     src.type == 'setfield'
            or     src.type == 'getfield'
            or     src.type == 'tablefield' then
                callback(src.field, uri)
            elseif src.type == 'setindex'
            or     src.type == 'getindex'
            or     src.type == 'tableindex' then
                callback(src.index, uri)
            elseif src.type == 'getmethod'
            or     src.type == 'setmethod' then
                callback(src.method, uri)
            else
                callback(src, uri)
            end
        end
    end)
end

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}
    guide.eachSourceContain(ast.ast, offset, function (source)
        findDef(source, function (target, uri)
            results[#results+1] = {
                target = target,
                uri    = files.getOriginUri(uri),
                source = source,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
