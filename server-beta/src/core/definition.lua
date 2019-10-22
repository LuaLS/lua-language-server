local guide     = require 'parser.guide'
local engineer  = require 'core.engineer'
local workspace = require 'workspace'

local function findDef(searcher, source, callback)
    searcher:eachDef(source, function (src)
        if     src.type == 'setfield'
        or     src.type == 'getfield'
        or     src.type == 'tablefield' then
            callback(src.field)
        elseif src.type == 'setindex'
        or     src.type == 'getindex'
        or     src.type == 'tableindex' then
            callback(src.index)
        elseif src.type == 'getmethod'
        or     src.type == 'setmethod' then
            callback(src.method)
        else
            callback(src)
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

return function (ast, offset)
    local results = {}
    local searcher = engineer(ast)
    guide.eachSourceContain(ast.ast, offset, function (source)
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
        findDef(searcher, source, function (src)
            results[#results+1] = {
                uri    = ast.uri,
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
