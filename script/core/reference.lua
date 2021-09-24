local searcher   = require 'core.searcher'
local guide      = require 'parser.guide'
local files      = require 'files'
local vm         = require 'vm'
local findSource = require 'core.find-source'

local function sortResults(results)
    -- 先按照顺序排序
    table.sort(results, function (a, b)
        local u1 = guide.getUri(a.target)
        local u2 = guide.getUri(b.target)
        if u1 == u2 then
            return a.target.start < b.target.start
        else
            return u1 < u2
        end
    end)
    -- 如果2个结果处于嵌套状态，则取范围小的那个
    local lf, lu
    for i = #results, 1, -1 do
        local res = results[i].target
        local f   = res.finish
        local uri = guide.getUri(res)
        if lf and f > lf and uri == lu then
            table.remove(results, i)
        else
            lu = uri
            lf = f
        end
    end
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
    ['...']         = true,

    ['doc.type.name']    = true,
    ['doc.class.name']   = true,
    ['doc.extends.name'] = true,
    ['doc.alias.name']   = true,
}

return function (uri, position)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    local source = findSource(ast, position, accept)
    if not source then
        return nil
    end

    local metaSource = vm.isMetaFile(uri)

    local refs = vm.getAllRefs(source)
    local values = {}
    for _, src in ipairs(refs) do
        local value = searcher.getObjectValue(src)
        if value and value ~= src and guide.isLiteral(value) then
            values[value] = true
        end
    end

    local results = {}
    for _, src in ipairs(refs) do
        if src.dummy then
            goto CONTINUE
        end
        if values[src] then
            goto CONTINUE
        end
        local root = guide.getRoot(src)
        if not root then
            goto CONTINUE
        end
        if not metaSource and vm.isMetaFile(root.uri) then
            goto CONTINUE
        end
        if  (   src.type == 'doc.class.name'
            or  src.type == 'doc.type.name'
            or  src.type == 'doc.extends.name'
            )
        and source.type ~= 'doc.type.name'
        and source.type ~= 'doc.class.name' then
            goto CONTINUE
        end
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
        elseif src.type == 'table' and src.parent.type ~= 'return' then
            goto CONTINUE
        end
        results[#results+1] = {
            target = src,
            uri    = root.uri,
        }
        ::CONTINUE::
    end

    if #results == 0 then
        return nil
    end

    sortResults(results)

    return results
end
