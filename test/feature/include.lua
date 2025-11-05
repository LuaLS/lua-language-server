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

---@param script string
---@return File?
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
    local file = ls.file.setText(test.includeUri, text)
    test.scope.vm:indexFile(test.includeUri)

    return file
end
