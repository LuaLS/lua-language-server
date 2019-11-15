local guide    = require 'parser.guide'
local files    = require 'files'
local searcher = require 'searcher'

local function ofLocal(source, callback)
    callback(source)
    if source.ref then
        for _, ref in ipairs(source.ref) do
            callback(ref)
        end
    end
end

local function ofField(source, uri, callback)
    callback(source)
    local parent = source.parent
    if not parent or not parent.node then
        return
    end
    local myKey = guide.getKeyName(source)
    searcher.eachField(parent.node, function (info)
        if info.key ~= myKey then
            return
        end
        local destUri = guide.getRoot(info.source).uri
        if destUri ~= uri then
            return
        end
        callback(info.source)
    end)
end

local function ofIndex(source, uri, callback)
    local parent = source.parent
    if parent.type == 'setindex'
    or parent.type == 'getindex'
    or parent.type == 'tableindex' then
        ofField(source, uri, callback)
    end
end

local function ofLabel(source, callback)
    searcher.eachRef(source, function (info)
        callback(info.source)
    end)
end

local function find(source, uri, callback)
    if     source.type == 'local' then
        ofLocal(source, callback)
    elseif source.type == 'getlocal'
    or     source.type == 'setlocal' then
        ofLocal(source.node, callback)
    elseif source.type == 'field'
    or     source.type == 'method' then
        ofField(source, uri, callback)
    elseif source.type == 'string'
    or     source.type == 'boolean'
    or     source.type == 'number' then
        ofIndex(source, uri, callback)
    elseif source.type == 'goto'
    or     source.type == 'label' then
        ofLabel(source, callback)
    end
end

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}
    local mark = {}
    guide.eachSourceContain(ast.ast, offset, function (source)
        find(source, uri, function (target)
            if     target.type == 'getfield'
            or     target.type == 'setfield'
            or     target.type == 'tablefield' then
                target = target.field
            elseif target.type == 'getmethod'
            or     target.type == 'setmethod' then
                target = target.method
            elseif target.type == 'getindex'
            or     target.type == 'setindex'
            or     target.type == 'tableindex' then
                target = target.index
            end
            if mark[target] then
                return
            end
            mark[target] = true
            results[#results+1] = {
                start  = target.start,
                finish = target.finish,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
