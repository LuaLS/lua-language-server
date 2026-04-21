local files = require 'files'
local guide = require 'parser.guide'
local await = require 'await'

-- Returns the value node of a named field in a table AST node, or nil.
local function tableGet(tblNode, key)
    if not tblNode or tblNode.type ~= 'table' then return nil end
    for i = 1, #tblNode do
        local child = tblNode[i]
        if child and child.type == 'tablefield' and child.field and child.field[1] == key then
            return child.value
        end
    end
    return nil
end

-- Returns true if `node` is a getfield call like `<receiverName>.methodName(...)`
local function isLocalMethod(source, receiverName, methodName)
    if not source or source.type ~= 'call' then return false end
    local callee = source.node
    if not callee or callee.type ~= 'getfield' then return false end
    if not callee.field or callee.field[1] ~= methodName then return false end
    local receiver = callee.node
    if not receiver or receiver.type ~= 'getlocal' then return false end
    return receiver[1] == receiverName
end

return function (uri, callback)
    -- Only run on .devsper files
    if not uri:match('%.devsper$') then return end

    local state = files.getState(uri)
    if not state then return end

    -- Pass 1: collect all declared task IDs from wf.task(id, spec) calls
    local declaredIds = {}

    guide.eachSourceType(state.ast, 'call', function (source)
        await.delay()
        if not isLocalMethod(source, 'wf', 'task') then return end
        local args = source.args
        if not args then return end
        local idNode = args[1]
        if not idNode or idNode.type ~= 'string' then return end
        local id = idNode[1]
        if id then
            declaredIds[id] = { start = idNode.start, finish = idNode.finish }
        end
    end)

    -- Build sorted ID list once for error messages
    local sortedIds = {}
    for k in pairs(declaredIds) do
        sortedIds[#sortedIds + 1] = k
    end
    table.sort(sortedIds)
    local declaredIdsStr = table.concat(sortedIds, ', ')

    -- Pass 2: check depends_on entries in each wf.task spec
    guide.eachSourceType(state.ast, 'call', function (source)
        await.delay()
        if not isLocalMethod(source, 'wf', 'task') then return end
        local args = source.args
        if not args then return end
        local spec = args[2]
        if not spec or spec.type ~= 'table' then return end

        local dependsOn = tableGet(spec, 'depends_on')
        if not dependsOn or dependsOn.type ~= 'table' then return end

        -- Array table elements are wrapped in tableexp nodes in the luals AST
        for i = 1, #dependsOn do
            local exp = dependsOn[i]
            if exp and exp.type == 'tableexp' then
                local child = exp.value
                if child and child.type == 'string' then
                    local val = child[1]
                    if val and val ~= '*' and not declaredIds[val] then
                        callback {
                            start   = child.start,
                            finish  = child.finish,
                            message = ("devsper: unknown task id '%s' in depends_on — declared ids: %s"):format(
                                val, declaredIdsStr
                            ),
                        }
                    end
                end
            end
            -- Non-string/non-literal children silently skipped
        end
    end)
end
