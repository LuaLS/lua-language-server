local guide = require 'parser.guide'
local files = require 'files'
local vm    = require 'vm'

local function isFunction(source, offset)
    if source.type ~= 'function' then
        return false
    end
    -- 必须点在 `function` 这个单词上才能查找函数引用
    return offset >= source.start and offset < source.start + #'function'
end

local function findRef(source, offset, callback)
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
    and source.type ~= 'goto'
    and source.type ~= 'label'
    and not isFunction(source, offset) then
        return
    end
    vm.eachRef(source, function (src)
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
    end)
    vm.eachDef(source, function (src)
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
    end)
end

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}
    local mark = {}
    guide.eachSourceContain(ast.ast, offset, function (source)
        findRef(source, offset, function (target, uri)
            if mark[target] then
                return
            end
            mark[target] = true
            results[#results+1] = {
                target = target,
                uri    = files.getOriginUri(uri),
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
