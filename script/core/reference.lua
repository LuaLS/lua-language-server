local guide      = require 'parser.guide'
local files      = require 'files'
local vm         = require 'vm'
local findSource = require 'core.find-source'
local jumpSource = require 'core.jump-source'

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
    ['doc.enum.name']    = true,
    ['doc.field.name']   = true,
}

---@async
---@param uri uri
---@param position integer
---@param includeDeclaration boolean
return function (uri, position, includeDeclaration)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    local source = findSource(ast, position, accept)
    if not source then
        return nil
    end

    local metaSource = vm.isMetaFile(uri)

    local refs = vm.getRefs(source)

    local results = {}
    for _, src in ipairs(refs) do
        local root = guide.getRoot(src)
        if not root then
            goto CONTINUE
        end
        if not metaSource and vm.isMetaFile(root.uri) then
            goto CONTINUE
        end
        if src.type == 'self' then
            goto CONTINUE
        end
        if not includeDeclaration then
            if guide.isAssign(src)
            or guide.isLiteral(src) then
                goto CONTINUE
            end
        end
        src = src.field or src.method or src
        if src.type == 'getindex'
        or src.type == 'setindex'
        or src.type == 'tableindex' then
            src = src.index
            if not src then
                goto CONTINUE
            end
            if not guide.isLiteral(src) then
                goto CONTINUE
            end
        else
            if guide.isLiteral(src) and src.type ~= 'function' then
                goto CONTINUE
            end
        end
        if src.type == 'doc.class' then
            src = src.class
        end
        if src.type == 'doc.alias' then
            src = src.alias
        end
        if src.type == 'doc.enum' then
            src = src.enum
        end
        if src.type == 'doc.type.field' then
            src = src.name
        end
        if src.type == 'doc.class.name'
        or src.type == 'doc.alias.name'
        or src.type == 'doc.enum.name'
        or src.type == 'doc.type.name'
        or src.type == 'doc.extends.name' then
            if  source.type ~= 'doc.type.name'
            and source.type ~= 'doc.class.name'
            and source.type ~= 'doc.enum.name'
            and source.type ~= 'doc.extends.name'
            and source.type ~= 'doc.see.name'
            and source.type ~= 'doc.alias.name' then
                goto CONTINUE
            end
        end
        if src.type == 'doc.generic.name' then
            goto CONTINUE
        end
        if src.type == 'doc.param' then
            goto CONTINUE
        end

        results[#results+1] = {
            target = src,
            uri    = root.uri,
            source = source,
        }
        ::CONTINUE::
    end

    if #results == 0 then
        return nil
    end

    sortResults(results)
    jumpSource(results)

    return results
end
