local rust = assert(require 'rust')

-- submodule registration
assert(type(rust.luafmt) == 'table')
assert(type(rust.luafmt.format) == 'function')

-- format success
local ok, result = rust.luafmt.format('local a=1\n')
assert(ok)
assert(result:match('a = 1'))

-- format failure (syntax error)
local ok, err = rust.luafmt.format('local x = = 1\n')
assert(not ok)
assert(type(err) == 'string')
