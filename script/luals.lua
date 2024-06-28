Class  = require 'class'.declare
New    = require 'class'.new
Delete = require 'class'.delete

package.loaded['class'] = require 'class'

---@class LuaLS
ls = {}

ls.util    = require 'utility'
ls.inspect = require 'inspect'
ls.encoder = require 'encoder'

ls.json    = require 'json'
require 'jsonc'
require 'json-edit'
require 'log'
require 'linked-table'

ls.uri     = require 'uri'
ls.task    = require 'task'
ls.timer   = require 'timer'

ls.config  = require 'config'

require 'file'
ls.files   = New 'FileManager' ()
---@type VM?
ls.vm      = nil

return ls
