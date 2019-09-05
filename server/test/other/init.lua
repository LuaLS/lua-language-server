local fs = require 'bee.filesystem'
local path = fs.path '/a/b/c/d/e/../../../..'
local absolute = fs.absolute(path)
assert(absolute:string():sub(-2) == '/a')
