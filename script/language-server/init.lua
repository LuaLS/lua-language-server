require 'scope'
require 'config'
require 'filesystem'
require 'node'
require 'vm'
require 'custom'
require 'file'
require 'feature'

require 'language-server.task'
require 'language-server.capability'

require 'language-server.capability.lifecycle-messages.initialize'
require 'language-server.capability.lifecycle-messages.shutdown'
require 'language-server.capability.lifecycle-messages.exit'
require 'language-server.capability.lifecycle-messages.initialized'

require 'language-server.capability.document-synchronization.did-open-text-document'
require 'language-server.capability.document-synchronization.did-change-text-document'
require 'language-server.capability.document-synchronization.did-close-text-document'

require 'language-server.capability.language-features.go-to-definition'
require 'language-server.capability.language-features.hover'
require 'language-server.capability.language-features.completion'

local server = require 'language-server.language-server'

return server
