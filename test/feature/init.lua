print('[feature] 测试中...')

---@generic T
---@param script string
---@param callback fun(catched: table<string, table[]>): T?
---@return T?
---@return table<string, table[]>
function TEST_FRAME(script, callback)
    test.scope.rt:reset()
    local _ <close> = test.checkInclude(script)
    local newScript, catched = test.catch(script, '!?')

    local file <close>  = ls.file.setServerText(test.fileUri, newScript)
    local vfile <close> = test.scope.vm:indexFile(test.fileUri)

    return callback(catched), catched
end

require 'test.feature.definition'

print('[feature] 测试完毕')
