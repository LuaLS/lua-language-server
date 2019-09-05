local fs = require 'bee.filesystem'
local platform = require 'bee.platform'
local path = fs.path '/a/b/c/d/e/../../../..'
local absolute = fs.absolute(path)
if platform.OS == 'Windows' then
    assert(absolute:string():sub(-2) == '/a', absolute:string())
elseif platform.OS == 'Linux' then
    assert(absolute:string():sub(-3) == '/a/', absolute:string())
elseif platform.OS == 'macOS' then
    -- 不支持
end
