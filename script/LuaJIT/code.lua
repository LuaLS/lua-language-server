local vm        = require 'vm'


local function getLiterals(arg)
    local literals = vm.getLiterals(arg)
    local res = {}
    for k, v in pairs(literals) do
        if type(k) == 'string' then
            res[#res+1] = k
        end
    end
    return res
end

---@return string[]?
local function getCode(CdefReference)
    local target = CdefReference.target
    if not (target.type == 'field' and target.parent.type == 'getfield') then
        return nil
    end
    target = target.parent.parent
    if target.type == 'call' then
        return getLiterals(target.args and target.args[1])
    elseif target.type == 'local' then
        local res = {}
        for _, o in ipairs(target.ref) do
            if o.parent.type ~= 'call' then
                goto CONTINUE
            end
            local target = o.parent
            local literals = vm.getLiterals(target.args and target.args[1])
            if not literals then
                goto CONTINUE
            end
            for k, v in pairs(literals) do
                if type(k) == 'string' then
                    res[#res+1] = k
                end
            end
            ::CONTINUE::
        end
        return res
    end
end

---@async
return function (CdefReference)
    if not CdefReference then
        return nil
    end
    local codeResults
    for i, v in ipairs(CdefReference) do
        local codes = getCode(v)
        for i, v in ipairs(codes or {}) do
            codeResults = codeResults or {}
            codeResults[#codeResults+1] = v
        end
    end
    return codeResults
end
