local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'

---@param uri uri
---@param func parser.object
local function hasDocReturn(uri, func)
    if not func.bindDocs then
        return false
    end
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.return' then
            -- don't need return with only one `any`
            local lastReturn = doc.returns[#doc.returns]
            if lastReturn.returnIndex ~= 1
            or vm.getInfer(lastReturn):view(uri) ~= 'any' then
                return true
            end
        end
    end
    return false
end

---@param block parser.object
---@return boolean
local function hasReturn(block)
    if block.hasReturn or block.hasError then
        return true
    end
    if block.type == 'if' then
        local hasElse
        for _, subBlock in ipairs(block) do
            if not hasReturn(subBlock) then
                return false
            end
            if subBlock.type == 'elseblock' then
                hasElse = true
            end
        end
        return hasElse == true
    else
        if block.type == 'while' then
            if vm.testCondition(block.filter) then
                return true
            end
        end
        for _, action in ipairs(block) do
            if guide.isBlockType(action) then
                if hasReturn(action) then
                    return true
                end
            end
        end
    end
    return false
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'function', function (source)
        -- check declare only
        if #source == 0 then
            return
        end
        if not hasDocReturn(uri, source) then
            return
        end
        if hasReturn(source) then
            return
        end
        local lastAction = source[#source]
        local finish = lastAction.range or lastAction.finish
        callback {
            start   = finish,
            finish  = finish,
            message = lang.script('DIAG_MISSING_RETURN'),
        }
    end)
end
