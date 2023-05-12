local utility = require 'utility'
local cdriver = require 'plugins.ffi.c-parser.cdriver'

rawset(_G, 'TEST', true)
local ctypes = require 'plugins.ffi.c-parser.ctypes'
ctypes.TESTMODE = true

--TODO expand all singlenode
function TEST(wanted, full)
    return function (script)
        local rrr = cdriver.process_context(script .. "$EOF$")
        assert(rrr)
        if full then
            for i, v in ipairs(rrr) do
                assert(utility.equal(v, wanted[i]), utility.dump(v))
            end
        else
            assert(utility.equal(rrr[1], wanted), utility.dump(rrr[1]))
        end
    end
end

TEST {
    name = "struct@A",
    type = {
        fields = {
            {
                isarray = true,
                name = "a",
                type = { "int", },
            },
            {
                isarray = true,
                name = "b",
                type = { "int", },
            },
        },
        name = "A",
        type = "struct",
    },
}
    [[
    struct A {
        int a[5];
        int b[];
    };
]]

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
