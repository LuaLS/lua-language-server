local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local lang   = require 'language'

---@param source parser.object
---@return integer
local function countReturns(source)
    local n = 0

    local docs = source.bindDocs
    if docs then
        for _, doc in ipairs(docs) do
            if doc.type == 'doc.return' then
                for _, rtn in ipairs(doc.returns) do
                    if rtn.returnIndex and rtn.returnIndex > n then
                        n = rtn.returnIndex
                    end
                end
            end
        end
    end

    local returns = source.returns
    if returns then
        for _, rtn in ipairs(returns) do
            if #rtn > n then
                n = #rtn
            end
        end
    end

    return n
end

local function countMaxReturns(source)
    local hasFounded
    local n = 0
    for _, def in ipairs(vm.getDefs(source)) do
        if def.type == 'doc.type.function'
        or def.type == 'function' then
            hasFounded = true
            local rets = countReturns(def)
            if rets > n then
                n = rets
            end
        end
    end

    if hasFounded then
        return n
    else
        return math.huge
    end
end

local function countCallArgs(source)
    local result = 0
    if not source.args then
        return 0
    end
    local lastArg = source.args[#source.args]
    if lastArg.type == 'varargs' then
        return math.huge
    end
    if lastArg.type == 'call' then
        result = result + countMaxReturns(lastArg) - 1
    end
    result = result + #source.args
    return result
end

---@return integer
local function countFuncArgs(source)
    if not source.args or #source.args == 0 then
        return 0
    end
    local count = 0
    for i = #source.args, 1, -1 do
        local arg = source.args[i]
        if  arg.type ~= '...'
        and not (arg.name and arg.name[1] =='...')
        and not vm.compileNode(arg):isNullable() then
            return i
        end
    end
    return count
end

local function getFuncArgs(func)
    local funcArgs
    local defs = vm.getDefs(func)
    for _, def in ipairs(defs) do
        if def.type == 'function'
        or def.type == 'doc.type.function' then
            local args = countFuncArgs(def)
            if not funcArgs or args < funcArgs then
                funcArgs = args
            end
        end
    end
    return funcArgs
end

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'call', function (source)
        local callArgs = countCallArgs(source)

        local func = source.node
        local funcArgs = getFuncArgs(func)

        if not funcArgs then
            return
        end

        local delta = callArgs - funcArgs
        if delta >= 0 then
            return
        end
        callback {
            start  = source.start,
            finish = source.finish,
            message = lang.script('DIAG_MISS_ARGS', funcArgs, callArgs),
        }
    end)
end
