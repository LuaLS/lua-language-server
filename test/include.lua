test.includeUri = ls.uri.encode(test.rootPath .. '/include.lua')

test.includeCodes = {}

test.includeCodes['setmetatable'] = [[
---@generic T: table, MT: table|nil
---@param t T
---@param mt MT
---@return T & MT['__index']
function setmetatable(t, mt) end
]]

test.includeCodes['binary'] = [[
---@alias op.add<A: any, B: any> number
---@alias op.add<A: integer, B: integer> integer
]]

test.includeCodes['type'] = [[
---@overload fun(x: nil): 'nil'
---@overload fun(x: boolean): 'boolean'
---@overload fun(x: number): 'number'
---@overload fun(x: string): 'string'
---@overload fun(x: table): 'table'
---@overload fun(x: function): 'function'
---@overload fun(x: thread): 'thread'
---@overload fun(x: userdata): 'userdata'
function type(...) end
]]

test.includeCodes['type2'] = [[
---@alias TypeViewMap {
---    [nil]: 'nil',
---    [boolean]: 'boolean',
---    [number]: 'number',
---    [string]: 'string',
---    [table]: 'table',
---    [function]: 'function',
---    [thread]: 'thread',
---    [userdata]: 'userdata',
---}

---@generic T
---@param obj T
---@return TypeViewMap[T]
function type(obj) end
]]

test.includeCodes['type3'] = [[
---@alias TypeViewMap {
---    [nil]: 'nil',
---    [boolean]: 'boolean',
---    [number]: 'number',
---    [string]: 'string',
---    [table]: 'table',
---    [function]: 'function',
---    [thread]: 'thread',
---    [userdata]: 'userdata',
---}

---@alias TypeView<T> TypeViewMap[T]

---@generic T
---@param obj T
---@return TypeView<T>
function type(obj) end
]]

--- 使用 `--!include setmetatable` 在测试中包含预定义代码片段。
---@param script string
---@return function?
function test.checkInclude(script)
    local buf = {}
    for include in script:gmatch('%-%-!include%s+([%w_]+)') do
        local code = test.includeCodes[include]
        assert(code, 'Include file not found: ' .. include)
        buf[#buf+1] = code
    end

    if #buf == 0 then
        return nil
    end

    local text = table.concat(buf, '\n')
    local file = ls.file.setServerText(test.includeUri, text)
    local vfile = test.scope.vm:indexFile(test.includeUri)

    return function ()
        file:remove()
        vfile:remove()
    end
end
