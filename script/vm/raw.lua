local mt = require 'vm.manager'

function mt:callRawSet(func, values, source)
    local tbl = values[1]
    local index = values[2]
    local value = values[3]
    if not tbl or not index or not value then
        return
    end
    if index:getLiteral() then
        index = index:getLiteral()
    end
    tbl:addInfo('set child', source, index)
    tbl:rawSet(index, value, source)
    func:setReturn(1, tbl)
end

function mt:callRawGet(func, values, source)
    local tbl = values[1]
    local index = values[2]
    if not tbl or not index then
        return
    end
    if index:getLiteral() then
        index = index:getLiteral()
    end
    tbl:addInfo('get child', source, index)
    local value = tbl:rawGet(index)
    func:setReturn(1, value)
end
