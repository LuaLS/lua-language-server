local workspace  = require 'workspace'
local files      = require 'files'
local vm         = require 'vm'
local findSource = require 'core.find-source'
local guide      = require 'parser.guide'
local rpath      = require 'workspace.require-path'
local jumpSource = require 'core.jump-source'
local wssymbol   = require 'core.workspace-symbol'

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
    ['doc.see.name']     = true,
    ['doc.cast.name']    = true,
    ['doc.enum.name']    = true,
    ['doc.field.name']   = true,
}

local function checkRequire(source, offset)
    if source.type ~= 'string' then
        return nil
    end
    local callargs = source.parent
    if callargs.type ~= 'callargs' then
        return
    end
    if callargs[1] ~= source then
        return
    end
    local call = callargs.parent
    local func = call.node
    local literal = guide.getLiteral(source)
    local libName = vm.getLibraryName(func)
    if not libName then
        return nil
    end
    if     libName == 'require' then
        return rpath.findUrisByRequireName(guide.getUri(source), literal)
    elseif libName == 'dofile'
    or     libName == 'loadfile' then
        return workspace.findUrisByFilePath(literal)
    end
    return nil
end

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
---@param source parser.object
---@param results table
local function checkSee(source, results)
    if source.type ~= 'doc.see.name' then
        return
    end
    local symbols = wssymbol(source[1], guide.getUri(source))
    for _, symbol in ipairs(symbols) do
        if symbol.name == source[1] then
            results[#results+1] = {
                target = symbol.source,
                source = source,
                uri    = guide.getUri(symbol.source),
            }
        end
    end
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
    local uris = checkRequire(source)
    if uris then
        for i, uri in ipairs(uris) do
            results[#results+1] = {
                uri    = uri,
                source = source,
                target = {
                    start  = 0,
                    finish = 0,
                    uri    = uri,
                }
            }
        end
    end

    checkSee(source, results)

    local defs = vm.getDefs(source)

    for _, src in ipairs(defs) do
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
        else
            if  guide.isLiteral(src)
            and src.type ~= 'function'
            and src.type ~= 'doc.type.function'
            and src.type ~= 'doc.type.table' then
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
        or src.type == 'doc.enum.name' then
            if  source.type ~= 'doc.type.name'
            and source.type ~= 'doc.extends.name'
            and source.type ~= 'doc.see.name'
            and source.type ~= 'doc.class.name'
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
