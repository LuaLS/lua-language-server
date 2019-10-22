local guide     = require 'parser.guide'
local workspace = require 'workspace'
local files     = require 'files'

local function findDef(searcher, source, callback)
    searcher:eachDef(source, function (src, uri)
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

---@param searcher engineer
local function checkRequire(searcher, source, offset, callback)
    if source.type ~= 'call' then
        return
    end
    local func = source.node
    local pathSource = source.args and source.args[1]
    if not pathSource then
        return
    end
    if not guide.isContain(pathSource, offset) then
        return
    end
    local literal = guide.getLiteral(pathSource)
    if type(literal) ~= 'string' then
        return
    end
    local name = searcher:getSpecialName(func)
    if     name == 'require' then
        local result = workspace.findUrisByRequirePath(literal, true)
        for _, uri in ipairs(result) do
            callback(uri)
        end
    elseif name == 'dofile'
    or     name == 'loadfile' then
        local result = workspace.findUrisByFilePath(literal, true)
        for _, uri in ipairs(result) do
            callback(uri)
        end
    end
end

return function (uri, offset)
    local results = {}
    local searcher = files.getSearcher(uri)
    if not searcher then
        return nil
    end
    guide.eachSourceContain(searcher.ast, offset, function (source)
        checkRequire(searcher, source, offset, function (uri)
            results[#results+1] = {
                uri    = uri,
                source = source,
                target = {
                    start  = 0,
                    finish = 0,
                }
            }
        end)
        findDef(searcher, source, function (src, uri)
            results[#results+1] = {
                uri    = uri,
                source = source,
                target = src,
            }
        end)
    end)
    if #results == 0 then
        return nil
    end
    return results
end
