local json = require 'json'

local replacement = utf8.char(0xfffd)

local function assertEncoding(value, expected)
    local encoded = json.encode(value)
    assert(utf8.len(encoded))
    assert(encoded == expected, ('expected %q, got %q'):format(expected, encoded))
end

assertEncoding('plain text', '"plain text"')
assertEncoding('é中文', '"é中文"')
assertEncoding('\x80', '"' .. replacement .. '"')
assertEncoding('\xff', '"' .. replacement .. '"')
assertEncoding('\xc2A', '"' .. replacement .. 'A"')
assertEncoding('\xe2\x82', '"' .. replacement .. replacement .. '"')
assertEncoding('[^%w_\x80-\xff]', '"[^%w_' .. replacement .. '-' .. replacement .. ']"')
assertEncoding({ ['\x80'] = 'value' }, '{"' .. replacement .. '":"value"}')

assert(json.decode(json.encode('\x80')) == replacement)

local jsonb = require 'json-beautify'
local beautified = jsonb.beautify({ value = '\x80' })
assert(utf8.len(beautified))
assert(beautified:find(replacement, 1, true))
