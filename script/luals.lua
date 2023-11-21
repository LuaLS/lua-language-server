Class  = require 'class'.declare
New    = require 'class'.new
Delete = require 'class'.delete

package.loaded['class'] = require 'class'

---@class LuaLS
luals = {}

luals.util    = require 'utility'
luals.inspect = require 'inspect'
luals.encoder = require 'encoder'

luals.json    = require 'json'
require 'jsonc'
require 'json-edit'
require 'log'
require 'linked-table'

luals.uri     = require 'uri'
luals.task    = require 'task'
luals.timer   = require 'timer'

luals.config  = require 'config'

require 'file'
luals.files   = New 'FileManager' ()
---@type VM?
luals.vm      = nil

return luals
