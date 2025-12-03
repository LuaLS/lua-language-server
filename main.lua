collectgarbage('generational', 10, 50)

---@class never
---@field never never

require 'luals'
require 'master'
local server = require 'languag-server'
server.create():start()

ls.eventLoop.start()
