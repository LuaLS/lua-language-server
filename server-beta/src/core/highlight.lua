local guide    = require 'parser.guide'
local files    = require 'files'
local searcher = require 'searcher'
local define   = require 'proto.define'

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
    elseif source.type == 'string' then
        ofIndex(source, uri, callback)
        callback(source)
    elseif source.type == 'boolean'
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
            local kind
            if     target.type == 'getfield' then
                target = target.field
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setfield'
            or     target.type == 'tablefield' then
                target = target.field
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getmethod' then
                target = target.method
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setmethod' then
                target = target.method
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getindex' then
                target = target.index
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setindex'
            or     target.type == 'tableindex' then
                target = target.index
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'getlocal'
            or     target.type == 'getglobal'
            or     target.type == 'goto' then
                kind   = define.DocumentHighlightKind.Read
            elseif target.type == 'setlocal'
            or     target.type == 'local'
            or     target.type == 'setglobal'
            or     target.type == 'label' then
                kind   = define.DocumentHighlightKind.Write
            elseif target.type == 'string' then
                kind   = define.DocumentHighlightKind.Text
            else
                log.warn('Unknow target.type:', target.type)
                return
            end
            if mark[target] then
                return
            end
            mark[target] = true
            results[#results+1] = {
                start  = target.start,
                finish = target.finish,
                kind   = kind,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
