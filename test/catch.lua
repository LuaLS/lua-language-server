local mt = {}

local function catchedTable()
    return setmetatable({}, mt)
end

function mt.__add(a, b)
    if not a or not b then
        return a or b
    end
    local t = catchedTable()
    for _, v in ipairs(a) do
        t[#t+1] = v
    end
    for _, v in ipairs(b) do
        t[#t+1] = v
    end
    return t
end

local function getLine(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return i
        end
    end
end

local function getPosition(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return 10000 * i + offset - lns[i]
        end
    end
end

---@param script string
---@param sep string
return function (script, sep)
    local pattern = ('()<(%s).-%s>()'):format(sep, sep)
    local lns = {}
    lns[0] = 0
    for pos in script:gmatch '()\n' do
        lns[#lns+1] = pos
    end
    lns[#lns+1] = math.maxinteger
    local codes = {}
    local pos   = 1
    ---@type integer[]
    local list = {}
    local cuted = 0
    local lastLine = 0
    for a, char, b in script:gmatch(pattern) do
        codes[#codes+1] = script:sub(pos, a - 1)
        codes[#codes+1] = script:sub(a + 2, b - 3)
        pos = b
        local line1 = getLine(a + 1, lns)
        if line1 ~= lastLine then
            cuted = 0
            lastLine = line1
        end
        cuted = cuted + 2
        local left = getPosition(a + 1, lns) - cuted
        local line2 = getLine(b - 3, lns)
        if line2 ~= lastLine then
            cuted = 0
            lastLine = line2
        end
        local right = getPosition(b - 3, lns) - cuted
        cuted = cuted + 2
        if not list[char] then
            list[char] = catchedTable()
        end
        list[char][#list[char]+1] = { left, right }
    end
    codes[#codes+1] = script:sub(pos)
    return table.concat(codes), list
end
