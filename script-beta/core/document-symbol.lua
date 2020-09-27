local await  = require 'await'
local symbol = require 'core.symbol'

local function packChild(ranges, symbols)
    await.delay()
    table.sort(symbols, function (a, b)
        return a.selectionRange[1] < b.selectionRange[1]
    end)
    await.delay()
    local root = {
        valueRange = { 0, math.maxinteger },
        children   = {},
    }
    local stacks = { root }
    for _, symbol in ipairs(symbols) do
        local parent = stacks[#stacks]
        -- 移除已经超出生效范围的区间
        while symbol.selectionRange[1] > parent.valueRange[2] do
            stacks[#stacks] = nil
            parent = stacks[#stacks]
        end
        -- 向后看，找出当前可能生效的区间
        local nextRange
        while #ranges > 0
        and   symbol.selectionRange[1] >= ranges[#ranges].valueRange[1] do
            if symbol.selectionRange[1] <= ranges[#ranges].valueRange[2] then
                nextRange = ranges[#ranges]
            end
            ranges[#ranges] = nil
        end
        if nextRange then
            stacks[#stacks+1] = nextRange
            parent = nextRange
        end
        if parent == symbol then
            -- function f() end 的情况，selectionRange 在 valueRange 内部，
            -- 当前区间置为上一层
            parent = stacks[#stacks-1]
        end
        -- 把自己放到当前区间中
        if not parent.children then
            parent.children = {}
        end
        parent.children[#parent.children+1] = symbol
    end
    return root.children
end

local function packSymbols(symbols)
    local ranges = {}
    for _, symbol in ipairs(symbols) do
        if symbol.valueRange then
            ranges[#ranges+1] = symbol
        end
    end
    await.delay()
    table.sort(ranges, function (a, b)
        return a.valueRange[1] > b.valueRange[1]
    end)
    -- 处理嵌套
    return packChild(ranges, symbols)
end

return function (uri)
    local symbols = symbol(uri)
    if not symbols then
        return nil
    end

    local packedSymbols = packSymbols(symbols)

    return packedSymbols
end
