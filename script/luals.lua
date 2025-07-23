Class   = require 'class'.declare
New     = require 'class'.new
Delete  = require 'class'.delete
Type    = require 'class'.type
IsValid = require 'class'.isValid
Extends = require 'class'.extends

require 'tools.log'

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
ls.timer         = require 'tools.timer'
ls.await         = require 'tools.await'
ls.eventLoop     = require 'tools.event-loop'

ls.parser        = require 'parser'

ls.await.setErrorHandler(function (traceback)
    log.error(traceback)
end)
ls.await.setSleepWaker(function (time, callback)
    if time <= 0 then
        ls.eventLoop.addDelayQueue(callback)
    else
        ls.timer.wait(time, callback)
    end
end)
ls.eventLoop.addTask(ls.timer.update)

return ls
