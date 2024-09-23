local files      = require 'files'
local vm         = require 'vm'
local findSource = require 'core.find-source'
local guide      = require 'parser.guide'
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
        local res  = results[i].target
        local f    = res.finish
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
    ['setglobal']   = true,
    ['getglobal']   = true,
    ['string']      = true,
    ['boolean']     = true,
    ['number']      = true,
    ['integer']     = true,
    ['...']         = true,

    ['doc.type.name']    = true,
    ['doc.class.name']   = true,
    ['doc.extends.name'] = true,
    ['doc.alias.name']   = true,
    ['doc.cast.name']    = true,
    ['doc.enum.name']    = true,
    ['doc.field.name']   = true,
}

local function convertIndex(source)
    if not source then
        return
    end
    if source.type == 'string'
    or source.type == 'boolean'
    or source.type == 'number'
    or source.type == 'integer' then
        local parent = source.parent
        if not parent then
            return
        end
        if parent.type == 'setindex'
        or parent.type == 'getindex'
        or parent.type == 'tableindex' then
            return parent
        end
    end
    return source
end

---@async
return function (uri, offset)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    local source = convertIndex(findSource(ast, offset, accept))
    if not source then
        return nil
    end

    local results = {}

    local defs = vm.getRefs(source)

    for _, src in ipairs(defs) do
        if not guide.isAssign(src) then
            goto CONTINUE
        end
        if src.type == 'global' then
            goto CONTINUE
        end
        local root = guide.getRoot(src)
        if not root then
            goto CONTINUE
        end
        if src.type == 'self' then
            goto CONTINUE
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
        end
        if src.type == 'doc.type.function'
        or src.type == 'doc.type.table'
        or src.type == 'doc.type.boolean'
        or src.type == 'doc.type.integer'
        or src.type == 'doc.type.string' then
            goto CONTINUE
        end
        if src.type == 'doc.class' then
            goto CONTINUE
        end
        if src.type == 'doc.alias' then
            goto CONTINUE
        end
        if src.type == 'doc.enum' then
            goto CONTINUE
        end
        if src.type == 'doc.type.field' then
            goto CONTINUE
        end
        if src.type == 'doc.class.name'
        or src.type == 'doc.alias.name'
        or src.type == 'doc.enum.name'
        or src.type == 'doc.field.name' then
            goto CONTINUE
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
