local cdriver = require 'LuaJIT.c-parser.cdriver'

rawset(_G, 'TEST', true)

local function nkeys(t)
    local n = 0
    for key, value in pairs(t) do
        n = n + 1
    end
    return n
end

local function deep_eq(a, b)
    local type_a = type(a)
    local type_b = type(b)

    if type_a ~= 'table' or type_b ~= 'table' then
        return a == b
    end

    local n_a = nkeys(a)
    local n_b = nkeys(b)
    if n_a ~= n_b then
        return false
    end

    for k, v_a in pairs(a) do
        local v_b = b[k]
        local eq = deep_eq(v_a, v_b)
        if not eq then
            return false
        end
    end

    return true
end


function TEST(wanted, full)
    return function (script)
        local rrr = cdriver.process_context(script .. "$EOF$")
        assert(rrr)
        if full then
            for i, v in ipairs(rrr) do
                assert(deep_eq(v, wanted[i]))
            end
        else
            assert(deep_eq(rrr[1], wanted))
        end
    end
end

TEST {
    name = 'struct@a',
    type = {
        name = 'a',
        type = 'struct'
    }
} [[
    struct a {int f;};
]]

TEST({
    {name = "struct@nil",type = {type = 'struct'}},
    {name = 'a', type = {
        name = 'a',
        type = 'typedef',
        def = {
            {type = 'struct',}
        }
    }}
}, true) [[
    typedef struct {} a;
]]


TEST {
    name = 'a',
    type = {
        name = 'a',
        type = 'function',
        params = {
            { type = { 'int' } },
        },
        ret = {
            type = { 'int' }
        },
        vararg = false
    },

} [[
    int a(int);
]]
