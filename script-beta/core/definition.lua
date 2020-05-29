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
    ['setindex']    = true,
    ['getindex']    = true,
    ['tableindex']  = true,
    ['setglobal']   = true,
    ['getglobal']   = true,
}

local function checkRequire(source, offset)
    if source.type ~= 'call' then
        return nil
    end
    local func = source.node
    local pathSource = source.args and source.args[1]
    if not pathSource then
        return nil
    end
    if not guide.isContain(pathSource, offset) then
        return nil
    end
    local literal = guide.getLiteral(pathSource)
    if type(literal) ~= 'string' then
        return nil
    end
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

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    local source = findSource(ast, offset, accept)
    if not source then
        return nil
    end

    local results = {}
    local uris = checkRequire(source)
    if uris then
        for i, uri in ipairs(uris) do
            results[#uris+1] = {
                uri    = files.getOriginUri(uri),
                source = source,
                target = {
                    start  = 0,
                    finish = 0,
                }
            }
        end
    end

    local defs = guide.requestDefinition(source)
    for _, src in ipairs(defs) do
        results[#results+1] = {
            target = src,
            uri    = files.getOriginUri(uri),
            source = source,
        }
    end

    if #results == 0 then
        return nil
    end
    return results
end
