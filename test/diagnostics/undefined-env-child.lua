TEST [[
---@type iolib
_ENV = io
<!print!>(stderr) -- `print` is warning but `stderr` is not
]]

TEST [[
---@type iolib
local _ENV = io
<!print!>(stderr) -- `print` is warning but `stderr` is not
]]

TEST [[
local _ENV = { print = print }
print(1)
]]

TEST [[
_ENV = {}
GLOBAL = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = {}
local _ = print --> local _ = _ENV.print
]]

TEST [[
GLOBAL = 1
_ENV = nil
]]

TEST [[
print(1)
_ENV = nil
]]
