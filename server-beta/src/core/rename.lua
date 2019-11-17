local files    = require 'files'
local searcher = require 'searcher'
local guide    = require 'parser.guide'

local function checkSource(source)
    if source.type == 'field'
    or source.type == 'method'
    or source.type == 'tablefield'
    or source.type == 'string'
    or source.type == 'local'
    or source.type == 'setlocal'
    or source.type == 'getlocal'
    or source.type == 'setglobal'
    or source.type == 'getglobal'
    or source.type == 'label'
    or source.type == 'goto' then
        return true
    end
    return false
end

local function rename(source)
    if source.type == 'field'
    or source.type == 'method'
    or source.type == 'tablefield'
    or source.type == 'string'
    or source.type == 'local'
    or source.type == 'setlocal'
    or source.type == 'getlocal'
    or source.type == 'setglobal'
    or source.type == 'getglobal'
    or source.type == 'label'
    or source.type == 'goto' then
        return source
    end
    if source.type == 'setfield'
    or source.type == 'getfield'
    or source.type == 'tablefield' then
        return source.field
    end
    if source.type == 'setindex'
    or source.type == 'getindex'
    or source.type == 'tableindex' then
        return source.index
    end
    if source.type == 'setmethod'
    or source.type == 'getmethod' then
        return source.method
    end
    return nil
end

return function (uri, pos, newname)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}
    guide.eachSourceContain(ast.ast, pos, function(source)
        if not checkSource(source) then
            return
        end
        searcher.eachRef(source, function (info)
            local src = rename(info.source)
            if not src then
                return
            end
            results[#results+1] = {
                start  = src.start,
                finish = src.finish,
                text   = newname,
                uri    = guide.getRoot(src).uri,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
