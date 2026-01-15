local tm    = require 'tools.text-merger'
--local tm2   = require 'tools.text-merger2'

print('正在测试：text-merger')

local function TEST(source)
    return function (expect)
        return function (changes)
            local text = tm.create(source):applyChanges(changes):getText()
            assert(text == expect)
            -- local text2 = tm2(source, nil, changes)
            -- assert(text2 == expect)
        end
    end
end

TEST [[


function Test(self)

end
]][[


function Test(self)

end

asser]]{
    [1] = {
        range = {
            ["end"] = {
                character = 0,
                line = 5,
            },
            start = {
                character = 0,
                line = 5,
            },
        },
        rangeLength = 0,
        text = "\
",
    },
    [2] = {
        range = {
            ["end"] = {
                character = 0,
                line = 6,
            },
            start = {
                character = 0,
                line = 6,
            },
        },
        rangeLength = 0,
        text = "a",
    },
    [3] = {
        range = {
            ["end"] = {
                character = 1,
                line = 6,
            },
            start = {
                character = 1,
                line = 6,
            },
        },
        rangeLength = 0,
        text = "s",
    },
    [4] = {
        range = {
            ["end"] = {
                character = 2,
                line = 6,
            },
            start = {
                character = 2,
                line = 6,
            },
        },
        rangeLength = 0,
        text = "s",
    },
    [5] = {
        range = {
            ["end"] = {
                character = 3,
                line = 6,
            },
            start = {
                character = 3,
                line = 6,
            },
        },
        rangeLength = 0,
        text = "e",
    },
    [6] = {
        range = {
            ["end"] = {
                character = 4,
                line = 6,
            },
            start = {
                character = 4,
                line = 6,
            },
        },
        rangeLength = 0,
        text = "r",
    },
}

TEST [[
local mt = {}

function mt['xxx']()
    

    
end
]] [[
local mt = {}

function mt['xxx']()
    
end
]] {
    [1] = {
        range = {
            ["end"] = {
                character = 4,
                line = 5,
            },
            start = {
                character = 4,
                line = 3,
            },
        },
        rangeLength = 8,
        text = "",
    },
}

TEST [[
local mt = {}

function mt['xxx']()
    
end
]] [[
local mt = {}

function mt['xxx']()
    p
end
]] {
    [1] = {
        range = {
            ["end"] = {
                character = 4,
                line = 3,
            },
            start = {
                character = 4,
                line = 3,
            },
        },
        rangeLength = 0,
        text = "p",
    },
}

TEST [[
print(12345)
]] [[
print(123
45)
]] {
    [1] = {
        range = {
            ["end"] = {
                character = 9,
                line = 0,
            },
            start = {
                character = 9,
                line = 0,
            },
        },
        rangeLength = 0,
        text = "\
",
    },
}

TEST [[
print(123
45)
]] [[
print(12345)
]] {
    [1] = {
        range = {
            ["end"] = {
                character = 0,
                line = 1,
            },
            start = {
                character = 9,
                line = 0,
            },
        },
        rangeLength = 2,
        text = "",
    },
}

local text = string.rep('abcdefghijklmnopqrstuvwxyz\n', 10000)
local changes = {}
for i = 1, 100 do
    changes[#changes+1] = {
        range = {
            start = { line = i * 10, character = 0 },
            ['end'] = { line = i * 10, character = 5 },
        },
        text = 'changed words',
    }
end
for i = 1, 100 do
    changes[#changes+1] = {
        range = {
            start = { line = i * 10 + 5000, character = 10 },
            ['end'] = { line = i * 10 + 5 + 5000, character = 20 },
        },
        text = '',
    }
end

local c1 = os.clock()
local t1 = tm.create(text):applyChanges(changes):getText()
local c2 = os.clock()
print('text-merger Large test time: {%.3f} secs' % { c2 - c1 })

-- local c3 = os.clock()
-- local t2 = tm2(text, nil, changes)
-- local c4 = os.clock()
-- print('text-merger2 Large test time: {%.3f} secs' % { c4 - c3 })

-- assert(t1 == t2)
