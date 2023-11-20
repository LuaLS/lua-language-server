Class = require 'tools.class'.declare
New   = require 'tools.class'.new

package.loaded['class'] = require 'tools.class'

---@class LuaLS
luals = {}

luals.util    = require 'tools.utility'
luals.inspect = require 'tools.inspect'
luals.encoder = require 'tools.encoder'

luals.json    = require 'tools.json'
package.loaded['json'] = luals.json
package.loaded['json-beautify'] = require 'tools.json-beautify'
require 'tools.jsonc'
require 'tools.json-edit'
require 'tools.log'
require 'tools.linked-table'
require 'file'

luals.uri     = require 'tools.uri'
luals.config  = require 'config'
luals.files   = New 'FileManager' ()
---@type VM?
luals.vm      = nil

return luals
