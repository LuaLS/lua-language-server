
local export = {}
local EXISTS = {}

export.EXISTS = EXISTS

local divider = "\n=================\n"
local header1 = ("%stest failed. got:%s"):format(divider, divider)
local header2 = ("%sexpected:%s"):format(divider, divider)
local template = header1 .. "%s" .. header2 .. "%s" .. divider

function export.eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    if b == EXISTS and a ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false, template:format("type is: " .. tp1, "type is: " .. tp2)
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            local ok, err = export.eq(a[k], b[k])
            if not ok then
                return false, string.format(".%s%s", k, err)
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false, string.format(".%s: missing key in result", k)
            end
        end
        return true
    end

    if a == b then
        return true
    end

    return false, template:format(tostring(a), tostring(b))
end

return export
