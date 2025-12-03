collectgarbage('generational', 10, 50)

---@class never
---@field never never

require 'luals'
require 'master'
local server = require 'language-server.init'
server.create():start()

ls.eventLoop.start()
