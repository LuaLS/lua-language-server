local files = require 'files'
local guide = require 'parser.guide'
local lang  = require 'language'
local await = require 'await'

---@param source parser.object
---@return boolean
local function isForLoopVariable(source)
    -- Check if this local is a for-loop variable
    if source.type ~= 'local' then
        return false
    end
    
    local parent = source.parent
    if not parent then
        return false
    end
    
    -- Check if parent is a numeric for-loop
    if parent.type == 'loop' and parent.loc == source then
        return true
    end
    
    -- Check if parent is a for-in loop
    if parent.type == 'in' and parent.keys then
        for i = 1, #parent.keys do
            if parent.keys[i] == source then
                return true
            end
        end
    end
    
    return false
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end
    
    -- Only check for Lua 5.5
    if state.version ~= 'Lua 5.5' then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'setlocal', function (source)
        await.delay()
        
        -- Get the original local declaration
        local node = source.node
        if not node then
            return
        end
        
        -- Check if this local is a for-loop variable
        if isForLoopVariable(node) then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_READONLY_FOR_LOOP_VAR', node[1]),
            }
        end
    end)
end