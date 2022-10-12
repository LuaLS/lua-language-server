local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'
local await  = require 'await'

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

---@param func parser.object
---@return boolean
local function isEmptyFunction(func)
    if #func > 0 then
        return false
    end
    local startRow  = guide.rowColOf(func.start)
    local finishRow = guide.rowColOf(func.finish)
    return finishRow - startRow <= 1
end

---@param func parser.object
---@return integer
local function getReturnsMin(func)
    local min = vm.countReturnsOfFunction(func, true)
    if min == 0 then
        return 0
    end
    for _, doc in ipairs(func.bindDocs) do
        if doc.type == 'doc.overload' then
            local n = vm.countReturnsOfFunction(doc.overload)
            if n == 0 then
                return 0
            end
            if n < min then
                min = n
            end
        end
    end
    return min
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'function', function (source)
        -- check declare only
        if isEmptyFunction(source) then
            return
        end
        await.delay()
        if getReturnsMin(source) == 0 then
            return
        end
        if hasReturn(source) then
            return
        end
        local lastAction = source[#source]
        local pos
        if lastAction then
            pos = lastAction.range or lastAction.finish
        else
            local row = guide.rowColOf(source.finish)
            pos = guide.positionOf(row - 1, 0)
        end
        callback {
            start   = pos,
            finish  = pos,
            message = lang.script('DIAG_MISSING_RETURN'),
        }
    end)
end
