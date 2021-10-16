local files = require 'files'
local tm    = require 'text-merger'
local json  = require 'json'

local function TEST(source)
    return function (expect)
        return function (changes)
            files.removeAll()
            files.setText('', source)
            local text = tm('', changes)
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

---@diagnostic disable:trailing-space
TEST ''
[[x = {  "test"  } }]]
{
    json.decode [[{"range":{"end":{"line":0,"character":0},"start":{"line":0,"character":0}},"rangeLength":0,"text":"x"}]],
    json.decode [[{"range":{"end":{"line":0,"character":1},"start":{"line":0,"character":1}},"rangeLength":0,"text":" "}]],
    json.decode [[{"range":{"end":{"line":0,"character":2},"start":{"line":0,"character":2}},"rangeLength":0,"text":"="}]],
    json.decode [[{"range":{"end":{"line":0,"character":3},"start":{"line":0,"character":3}},"rangeLength":0,"text":" "}]],
--[[
x = 
]]
    json.decode [[{"range":{"end":{"line":0,"character":4},"start":{"line":0,"character":4}},"rangeLength":0,"text":"{ \r }"}]],
--[[
x = { 
 }
]]
    json.decode [[{"range":{"end":{"line":0,"character":7},"start":{"line":0,"character":6}},"rangeLength":1,"text":""}]],
--[[
x = {  }
    json.decode [[{"range":{"end":{"line":0,"character":6},"start":{"line":0,"character":6}},"rangeLength":0,"text":"\"\r\""}]],
--[[
x = { "
" }
]]
    json.decode [[{"range":{"end":{"line":0,"character":8},"start":{"line":0,"character":7}},"rangeLength":1,"text":""}]],
--[[
x = { "" }
]]
    json.decode [[{"range":{"end":{"line":0,"character":7},"start":{"line":0,"character":7}},"rangeLength":0,"text":"t"}]],
--[[
x = { "t" }
]]
    json.decode [[{"range":{"end":{"line":0,"character":8},"start":{"line":0,"character":8}},"rangeLength":0,"text":"e"}]],
    json.decode [[{"range":{"end":{"line":0,"character":9},"start":{"line":0,"character":9}},"rangeLength":0,"text":"s"}]],
    json.decode [[{"range":{"end":{"line":0,"character":10},"start":{"line":0,"character":10}},"rangeLength":0,"text":"t"}]],
--[[
x = { "test" }
]]
    json.decode [[{"range":{"end":{"line":0,"character":13},"start":{"line":0,"character":5}},"rangeLength":8,"text":""}]],
--[[
x = {}
]]
    json.decode [[{"range":{"end":{"line":0,"character":6},"start":{"line":0,"character":4}},"rangeLength":2,"text":""}]],
--[[
x = 
]]
    json.decode [[{"range":{"end":{"line":0,"character":4},"start":{"line":0,"character":4}},"rangeLength":0,"text":"{  \"test\"  }"}]],
--[[
x = {  \"test\"  }
]]
}
---@diagnostic enable:trailing-space
