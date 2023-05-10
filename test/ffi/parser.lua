local utility = require 'utility'
local cdriver = require 'LuaJIT.c-parser.cdriver'

rawset(_G, 'TEST', true)
local ctypes = require 'LuaJIT.c-parser.ctypes'
ctypes.TESTMODE = true

function TEST(wanted, full)
    return function (script)
        local rrr = cdriver.process_context(script .. "$EOF$")
        assert(rrr)
        if full then
            for i, v in ipairs(rrr) do
                assert(utility.equal(v, wanted[i]))
            end
        else
            assert(utility.equal(rrr[1], wanted))
        end
    end
end


TEST {
    name = 'union@a',
    type = {
        name = 'a',
        type = 'union',
        fields = {
            { name = 'b', type = { 'int' } },
            { name = 'c', type = { 'int8_t' } }
        }
    }
} [[
    union a{
        int b;
        int8_t c;
    };
]]

TEST {
    name = 'union@a',
    type = {
        name = 'a',
        type = 'union',
    }
} [[
    union a{};
]]

TEST {
    name = 'enum@anonymous',
    type = {
        type = 'enum',
        values = {
            { name = 'a', value = { '1' } },
            { name = 'b', value = { 'a' } },
        }
    }
} [[
    enum {
        a = 1,
        b = a,
    };
]]

TEST {
    name = 'enum@a',
    type = {
        name = 'a',
        type = 'enum',
        values = {
            { name = 'b', value = { op = '|', { '1' }, { '2' } } },
        }
    }
} [[
    enum a{
        b = 1|2,
    };
]]

TEST {
    name = 'enum@a',
    type = {
        name = 'a',
        type = 'enum',
    }
} [[
    enum a{};
]]

TEST {
    name = 'struct@a',
    type = {
        name = 'a',
        type = 'struct',
        fields = {
            { name = 'f', type = { 'int' } },
            { name = 'b', type = { 'int', '*', '*' } }
        }
    }
} [[
    struct a {int f,**b;};
]]

TEST {
    name = 'struct@a',
    type = {
        name = 'a',
        type = 'struct',
        fields = {
            { name = 'f', type = { 'int' } },
        }
    }
} [[
    struct a {int f;};
]]

TEST({
    { name = "struct@anonymous", type = { type = 'struct' } },
    {
        name = 'a',
        type = {
            name = 'a',
            type = 'typedef',
            def = {
                { type = 'struct', }
            }
        }
    }
}, true) [[
    typedef struct {} a;
]]

TEST {
    name = 'a',
    type = {
        name = 'a',
        type = 'function',
        params = {
            { type = { 'int' }, name = 'b' },
        },
        ret = {
            type = { 'int' }
        },
        vararg = false
    },

} [[
    int a(int b);
]]
