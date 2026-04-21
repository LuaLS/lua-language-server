local files = require 'files'
local guide = require 'parser.guide'

-- Returns the value node of a named field in a table AST node, or nil.
local function tableGet(tblNode, key)
    for i = 1, #tblNode do
        local child = tblNode[i]
        if child.type == 'tablefield'
        and child.field
        and child.field[1] == key then
            return child.value
        end
    end
    return nil
end

-- Returns true if `node` is a getfield call like `<local>.methodName(...)`
local function isLocalMethod(callNode, methodName)
    local callee = callNode.node
    if not callee then return false end
    if callee.type ~= 'getfield' then return false end
    if not callee.field then return false end
    if callee.field[1] ~= methodName then return false end
    -- receiver must be a local variable (getlocal)
    local receiver = callee.node
    if not receiver then return false end
    return receiver.type == 'getlocal'
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

local validBuiltins = {
    git        = true,
    search     = true,
    http       = true,
    code       = true,
    filesystem = true,
}

return function (uri, callback)
    -- Only run on .devsper files
    if not uri:match('%.devsper$') then return end

    local state = files.getState(uri)
    if not state then return end

    guide.eachSourceType(state.ast, 'call', function (source)
        local args = source.args
        if not args then return end

        -- wf.task(id, spec) — spec must have a `prompt` key
        if isLocalMethod(source, 'task') then
            local spec = args[2]
            if spec and spec.type == 'table' then
                if not tableGet(spec, 'prompt') then
                    callback {
                        start   = spec.start,
                        finish  = spec.finish,
                        message = 'devsper: wf.task() spec is missing required field "prompt"',
                    }
                end
            end

        -- wf.plugin(name, spec) — spec must have a `source` key; builtin: prefix validated
        elseif isLocalMethod(source, 'plugin') then
            local spec = args[2]
            if spec and spec.type == 'table' then
                local sourceVal = tableGet(spec, 'source')
                if not sourceVal then
                    callback {
                        start   = spec.start,
                        finish  = spec.finish,
                        message = 'devsper: wf.plugin() spec is missing required field "source"',
                    }
                elseif sourceVal.type == 'string' then
                    local strVal = sourceVal[1]
                    if strVal then
                        local builtinName = strVal:match('^builtin:(.+)$')
                        if builtinName and not validBuiltins[builtinName] then
                            callback {
                                start   = sourceVal.start,
                                finish  = sourceVal.finish,
                                message = ('devsper: unknown builtin plugin %q (valid: git, search, http, code, filesystem)'):format(builtinName),
                            }
                        end
                    end
                end
            end

        -- devsper.tool(name, spec) — spec must have `description` and `run` keys
        elseif isDevsperGlobalMethod(source, 'tool') then
            local spec = args[2]
            if spec and spec.type == 'table' then
                if not tableGet(spec, 'description') then
                    callback {
                        start   = spec.start,
                        finish  = spec.finish,
                        message = 'devsper: devsper.tool() spec is missing required field "description"',
                    }
                end
                if not tableGet(spec, 'run') then
                    callback {
                        start   = spec.start,
                        finish  = spec.finish,
                        message = 'devsper: devsper.tool() spec is missing required field "run"',
                    }
                end
            end
        end
    end)
end
