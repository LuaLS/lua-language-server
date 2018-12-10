local mt = {}
mt.__index = mt

function mt:searchGroup(group)
    if not group then
        return
    end
    if group.type ~= nil then
        return
    end
    for obj in pairs(group) do
        if obj.valuetype then
            group.type = obj.valuetype
            return
        end
    end
    group.type = false
end

function mt:searchVar(var)
    if var.valuetype then
        return
    end
    if self.lock[var] then
        return
    end
    if not var.group and next(var.childs) then
        var.valuetype = 'table'
        var.group = {
            type = 'table',
        }
        return
    end
    self.lock[var] = true
    self:searchGroup(var.group)
    self.lock[var] = nil
end

function mt:searchVars(vars)
    for _, var in ipairs(vars) do
        self:searchVar(var)
    end
end

return function (results)
    local session = setmetatable({
        lock = {},
    }, mt)
    session:searchVars(results.vars)
end
