local vm    = require 'vm'
local ws    = require 'workspace'
local furi  = require 'file-uri'
local files = require 'files'

local function asString(source)
    local literal = vm.getLiteral(source)
    if type(literal) ~= 'string' then
        return nil
    end
    local parent = source.parent
    if parent and parent.type == 'callargs' then
        local result
        local call = parent.parent
        local node = call.node
        local lib = vm.getLibrary(node)
        if not lib then
            return
        end
        if     lib.name == 'require' then
            result = ws.findUrisByRequirePath(literal, true)
        elseif lib.name == 'dofile'
        or     lib.name == 'loadfile' then
            result = ws.findUrisByFilePath(literal, true)
        end
        if result and #result > 0 then
            for i, uri in ipairs(result) do
                local path = furi.decode(uri)
                if files.eq(path:sub(1, #ws.path), ws.path) then
                    path = path:sub(#ws.path + 1):gsub('^[/\\]*', '')
                end
                result[i] = ('[%s](%s)'):format(path, uri)
            end
            return table.concat(result, '\n')
        end
    end
end

return function (source)
    if source.type == 'string' then
        return asString(source)
    end
end
