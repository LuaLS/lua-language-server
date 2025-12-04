require 'scope'
require 'config'
require 'filesystem'
require 'node'
require 'vm'
require 'file'
require 'feature'

require 'language-server.task'
require 'language-server.capability'

require 'language-server.capability.lifecycle.initialize'
require 'language-server.capability.lifecycle.shutdown'
require 'language-server.capability.lifecycle.exit'
require 'language-server.capability.lifecycle.initialized'

require 'language-server.capability.features.hover'

local server = require 'language-server.language-server'

return server
