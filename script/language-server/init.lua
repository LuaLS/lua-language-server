require 'language-server.task'
require 'language-server.capability'

require 'language-server.capability.lifecycle.initialize'
require 'language-server.capability.lifecycle.shutdown'
require 'language-server.capability.lifecycle.exit'

local server = require 'language-server.language-server'

return server
