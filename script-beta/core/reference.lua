local guide      = require 'parser.guide'
local files      = require 'files'
local findSource = require 'core.find-source'

local function isValidFunction(source, offset)
    -- 必须点在 `function` 这个单词上才能查找函数引用
    return offset >= source.start and offset < source.start + #'function'
end

local accept = {
    ['local']       = true,
    ['setlocal']    = true,
    ['getlocal']    = true,
    ['label']       = true,
    ['goto']        = true,
    ['field']       = true,
    ['method']      = true,
    ['setindex']    = true,
    ['getindex']    = true,
    ['tableindex']  = true,
    ['setglobal']   = true,
    ['getglobal']   = true,
    ['function']    = true,
}

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local source = findSource(ast, offset, accept)
    if not source then
        return nil
    end
    if source.type == 'function' and not isValidFunction(source, offset) and not TEST then
        return nil
    end

    local results = {}
    local refs = guide.requestReference(source)
    for _, src in ipairs(refs) do
        local root = guide.getRoot(src)
        if     src.type == 'setfield'
        or     src.type == 'getfield'
        or     src.type == 'tablefield' then
            src = src.field
        elseif src.type == 'setindex'
        or     src.type == 'getindex'
        or     src.type == 'tableindex' then
            src = src.index
        elseif src.type == 'getmethod'
        or     src.type == 'setmethod' then
            src = src.method
        end
        results[#results+1] = {
            target = src,
            uri    = files.getOriginUri(root.uri),
        }
    end

    if #results == 0 then
        return nil
    end
    return results
end
