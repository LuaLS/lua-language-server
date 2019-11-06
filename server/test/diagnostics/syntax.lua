local config = require 'config'

TEST [[
local x <const> = 1
<!x!> = 2
return x
]]

