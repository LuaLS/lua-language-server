Class = require 'tools.class'.declare
New   = require 'tools.class'.new

---@class LuaLS
luals = {}

luals.util    = require 'tools.utility'

luals.inspect = require 'tools.inspect'

luals.json    = require 'tools.json'
package.loaded['json'] = luals.json
require 'tools.json-beautify'
require 'tools.jsonc'
require 'tools.json-edit'

luals.uri     = require 'tools.uri'

return luals
