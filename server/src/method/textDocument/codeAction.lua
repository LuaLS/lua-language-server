return function (lsp, params)
    log.debug(table.dump(params))
    local uri = params.textDocument.uri
    local result = {}

    for _, data in ipairs(params.context.diagnostics) do
        if data.code then
            result[#result+1] = {
                title = ('禁用诊断(%s)'):format(data.code),
                kind = 'quickfix',
                diagnostics = {data},
                command = {
                    title = '测试',
                    command = 'config',
                    arguments = {
                        key = {'diagnostics', 'disable'},
                        action = 'add',
                        value = data.code,
                    }
                }
            }
        end
    end

    log.debug(table.dump(result))

    if #result == 0 then
        return nil
    end

    return result
end
