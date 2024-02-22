local ffi = require 'plugins.ffi'
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

local function formatLines(lines)
    if not lines or #lines == 0 then
        return {}
    end
    table.remove(lines, 1)
    return removeEmpty(lines)
end

---@param str string
local function splitLines(str)
    local lines = {}
    local i = 1
    for line in str:gmatch("[^\r\n]+") do
        lines[i] = line
        i = i + 1
    end
    return lines
end

function TEST(wanted)
    wanted = removeEmpty(splitLines(wanted))
    return function (script)
        local lines = formatLines(ffi.compileCodes({ script }))
        assert(util.equal(wanted, lines), util.dump(lines))
    end
end

TEST [[
    ---@alias ffi.namespace*.EVP_MD ffi.namespace*.struct@env_md_st

    ---@return ffi.namespace*.EVP_MD
    function m.EVP_md5() end
]] [[
    typedef struct env_md_st EVP_MD;
    const EVP_MD *EVP_md5(void);
]]

TEST [[
    ---@class ffi.namespace*.struct@a
    ---@field _in integer
]] [[
    struct a {
        int in;
    };
]]

TEST [[
---@param _in integer
function m.test(_in) end
]] [[
    void test(int in);
]]

TEST [[
    ---@alias ffi.namespace*.ENGINE ffi.namespace*.struct@engine_st
    ---@alias ffi.namespace*.ENGINE1 ffi.namespace*.enum@engine_st1
]] [[
    typedef struct engine_st ENGINE;
    typedef enum engine_st1 ENGINE1;
]]

TEST [[
    ---@param a integer[][]
    function m.test(a) end
]] [[
    void test(int a[][]);
]]

TEST [[
    ---@class ffi.namespace*.struct@A
    ---@field b integer[]
    ---@field c integer[]
]] [[
    struct A {
        int b[5];
        int c[];
    };
]]

TEST [[
    m.B = 5
    m.A = 0
    m.D = 7
    m.C = 6
]] [[
    enum {
        A,
        B=5,
        C,
        D,
    };
]]

TEST [[
    m.B = 2
    m.A = 1
    m.C = 5
    ---@alias ffi.namespace*.enum@a 1 | 2 | 'B' | 'A' | 5 | 'C'
]] [[
    enum a {
       A = 1,
       B = 2,
       C = A|B+2,
    };
]]

TEST [[
    ---@param a boolean
    ---@param b boolean
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(bool a, _Bool b, size_t c, ssize_t d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(int8_t a, int16_t b, int32_t c, int64_t d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(uint8_t a, uint16_t b, uint32_t c, uint64_t d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(unsigned char a, unsigned short b, unsigned long c, unsigned int d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(unsigned char a, unsigned short b, unsigned long c, unsigned int d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(signed char a, signed short b, signed long c, signed int d);
]]

TEST [[
    ---@param a integer
    ---@param b integer
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(char a, short b, long c, int d);
]]

TEST [[
    ---@param a number
    ---@param b number
    ---@param c integer
    ---@param d integer
    function m.test(a, b, c, d) end
]] [[
    void test(float a, double b, int8_t c, uint8_t d);
]]

TEST [[
    ---@alias ffi.namespace*.H ffi.namespace*.void

    function m.test() end
]] [[
    typedef void H;

    H test();
]]

TEST [[
    ---@class ffi.namespace*.a

    ---@param a ffi.namespace*.a
    function m.test(a) end
]] [[
    typedef struct {} a;

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
