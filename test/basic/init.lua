local files = require 'files'

local text = [[


function Test(self)

end
]]
files.setText('', text)

local changes = {
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

for _, change in ipairs(changes) do
    if change.range then
        local start, finish = files.unrange('', change.range)
        text = text:sub(1, start - 1) .. change.text .. text:sub(finish)
    else
        text = change.text
    end
    files.setRawText('', text)
end

assert(text == [[


function Test(self)

end

asser]])
