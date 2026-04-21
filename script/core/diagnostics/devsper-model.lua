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

-- Returns true if `callNode` is `devsper.<methodName>(...)`
local function isDevsperGlobalMethod(callNode, methodName)
    local callee = callNode.node
    if not callee then return false end
    if callee.type ~= 'getfield' then return false end
    if not callee.field then return false end
    if callee.field[1] ~= methodName then return false end
    local receiver = callee.node
    if not receiver then return false end
    if receiver.type ~= 'getglobal' then return false end
    return receiver[1] == 'devsper'
end

local KNOWN_PREFIXES = {
    '^claude%-',
    '^gpt%-',
    '^o%d',       -- o1, o3, etc.
    '^gemini%-',
    '^llama',
    '^mistral',
    '^phi',
    '^qwen',
    '^deepseek',
    '^gemma',
    '^falcon',
}

local KNOWN_EXACT = { auto = true }

local function isKnownModel(modelStr)
    if KNOWN_EXACT[modelStr] then return true end
    for _, pattern in ipairs(KNOWN_PREFIXES) do
        if modelStr:match(pattern) then return true end
    end
    return false
end

local function checkModelValue(modelNode, callback)
    if not modelNode then return end
    if modelNode.type ~= 'string' then return end  -- skip non-literal values
    local modelStr = modelNode[1]
    if not modelStr then return end
    if not isKnownModel(modelStr) then
        callback {
            start   = modelNode.start,
            finish  = modelNode.finish,
            message = ("devsper: unrecognized model '%s' — verify this provider is configured"):format(modelStr),
        }
    end
end

return function (uri, callback)
    -- Only run on .devsper files
    if not uri:match('%.devsper$') then return end

    local state = files.getState(uri)
    if not state then return end

    guide.eachSourceType(state.ast, 'call', function (source)
        await.delay()

        -- devsper.workflow(config) — check config.model
        if isDevsperGlobalMethod(source, 'workflow') then
            local config = source.args and source.args[1]
            if config and config.type == 'table' then
                checkModelValue(tableGet(config, 'model'), callback)
            end

        -- wf.task(id, spec) — check spec.model
        elseif isLocalMethod(source, 'wf', 'task') then
            local spec = source.args and source.args[2]
            if spec and spec.type == 'table' then
                checkModelValue(tableGet(spec, 'model'), callback)
            end
        end
    end)
end
