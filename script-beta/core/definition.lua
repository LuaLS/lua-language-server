local guide      = require 'parser.guide'
local workspace  = require 'workspace'
local files      = require 'files'
local vm         = require 'vm'
local findSource = require 'core.find-source'

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
    local lib = vm.getLibrary(func)
    if not lib then
        return nil
    end
    if     lib.name == 'require' then
        return workspace.findUrisByRequirePath(literal, true)
    elseif lib.name == 'dofile'
    or     lib.name == 'loadfile' then
        return workspace.findUrisByFilePath(literal, true)
    end
    return nil
end

local function convertIndex(source)
    if source.type == 'string'
    or source.type == 'boolean'
    or source.type == 'number' then
        local parent = source.parent
        if parent.type == 'setindex'
        or parent.type == 'getindex'
        or parent.type == 'tableindex' then
            return parent
        end
    end
    return source
end

return function (uri, offset)
    local ast = files.getAst(uri)
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
                uri    = files.getOriginUri(uri),
                source = source,
                target = {
                    start  = 0,
                    finish = 0,
                }
            }
        end
    end

    vm.eachDef(source, function (src)
        results[#results+1] = {
            target = src,
            uri    = files.getOriginUri(uri),
            source = source,
        }
    end)

    if #results == 0 then
        return nil
    end
    return results
end
