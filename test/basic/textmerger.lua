local tm    = require 'text-merger'

local function TEST(source)
    return function (expect)
        return function (changes)
            local text = tm(source, nil, changes)
            assert(text == expect)
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
