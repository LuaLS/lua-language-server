local util = require 'utility'

local function assertView(value, expected)
    local literal = util.viewString(value)
    assert(utf8.len(literal))
    assert(literal == expected, ('expected %q, got %q'):format(expected, literal))
end

assertView('plain text', '"plain text"')
assertView('é中文', '"é中文"')
assertView('\x80', '"\\128"')
assertView('\xff', '"\\255"')
assertView('\xc2A', '"\\194A"')
assertView('\xe2\x82', '"\\226\\130"')
assertView('[^%w_\x80-\xff]', '"[^%w_\\128-\\255]"')
