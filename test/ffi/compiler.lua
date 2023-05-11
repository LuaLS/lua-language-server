local luajit = require 'LuaJIT'
local util = require 'utility'
rawset(_G, 'TEST', true)

local function removeEmpty(lines)
    local removeLines = {}
    for i, v in ipairs(lines) do
        if v ~= '\n' then
            removeLines[#removeLines+1] = v:gsub('^%s+', '')
        end
    end
    return removeLines
end
---@param str string
function split_lines(str)
    local lines = {}
    local i = 1
    for line in str:gmatch("[^\r\n]+") do
        lines[i] = line
        i = i + 1
    end
    return lines
end

function TEST(wanted)
    wanted = removeEmpty(split_lines(wanted))
    return function (script)
        local lines = luajit.compileCodes({ script })
        table.remove(lines, 1)
        lines = removeEmpty(lines)
        assert(util.equal(wanted, lines), util.dump(lines))
    end
end

TEST [[
    ---@class ffi.namespace*.a
    ---@field a integer

    ---@param a ffi.namespace*.a*
    function m.test(a) end
]] [[
    typedef struct {int a;} a;

    void test(a* a);
]]

TEST [[
    ---@class ffi.namespace*.struct@a
    ---@field a integer
    ---@field b ffi.namespace*.char*

    ---@param a ffi.namespace*.struct@a
    function m.test(a) end
]] [[
    struct a {int a;char* b;};

    void test(struct a* a);
]]
