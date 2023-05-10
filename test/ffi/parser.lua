local utility = require 'utility'
local cdriver = require 'LuaJIT.c-parser.cdriver'

rawset(_G, 'TEST', true)

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
    { name = "struct@nil", type = { type = 'struct' } },
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
