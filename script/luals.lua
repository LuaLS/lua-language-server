Class   = require 'class'.declare
New     = require 'class'.new
Delete  = require 'class'.delete
Type    = require 'class'.type
IsValid = require 'class'.isValid
Extends = require 'class'.extends

---@class LuaLS
ls = {}

ls.util    = require 'utility'
ls.util.enableCloseFunction()
ls.util.enableFormatString()
ls.util.enableDividStringAsPath()
ls.fsu     = require 'tools.fs-utility'
ls.inspect = require 'tools.inspect'
ls.encoder = require 'tools.encoder'
ls.gc      = require 'tools.gc'
ls.json    = require 'tools.json'
ls.glob    = require 'tools.glob'
package.loaded['json'] = ls.json
package.loaded['json-beautify'] = require 'tools.json-beautify'
package.loaded['jsonc']         = require 'tools.jsonc'
package.loaded['json-edit']     = require 'tools.json-edit'
ls.linkedTable   = require 'tools.linked-table'
ls.pathTable     = require 'tools.path-table'
ls.caselessTable = require 'tools.caseless-table'
ls.uri           = require 'tools.uri'
ls.task          = require 'tools.task'
ls.timer         = require 'tools.timer'
ls.parser        = require 'parser'

require 'config'
require 'file'
require 'node'
require 'vm'
require 'scope'

return ls
