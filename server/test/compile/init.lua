local parser = require 'parser'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

function TEST(buf)
    local ast = parser:ast(buf)
    assert(ast)
    local results = matcher.compile(ast)
    assert(results)
end

TEST [[
obj.lines:

self._needDiagnostics[uri] = {
    ast     = ast,
    results = obj.results,
    lines   = obj.lines,
    uri     = uri,
}
]]
