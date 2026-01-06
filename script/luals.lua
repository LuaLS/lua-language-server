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
ls.util.enableFalswallow()

ls.fsu     = require 'tools.fs-utility'
ls.encoder = require 'tools.encoder'
ls.gc      = require 'tools.gc'
ls.json    = require 'tools.json'
ls.glob    = require 'tools.glob'
package.loaded['json'] = ls.json
package.loaded['json-beautify'] = require 'tools.json-beautify'
package.loaded['jsonc']         = require 'tools.jsonc'
package.loaded['json-edit']     = require 'tools.json-edit'
---@class LuaLS.Tools
ls.tools = {
    linkedTable   = require 'tools.linked-table',
    pathTable     = require 'tools.path-table',
    caselessTable = require 'tools.caseless-table',
    pqueue        = require 'tools.priority-queue',
    activePool    = require 'tools.active-pool',
}
ls.uri           = require 'tools.uri'
ls.timer         = require 'tools.timer'
ls.await         = require 'tools.await'
ls.eventLoop     = require 'tools.event-loop'
ls.sevent        = require 'tools.simple-event'

require 'async'

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

local inspect = require 'tools.inspect'

local inspectOptions = {
    process = function (item, path)
        -- don't inspect metatable
        if path[#path] == inspect.METATABLE then
            return nil
        end
        -- don't show text
        if path[#path] == 'text' then
            return '***'
        end
        if item == _G then
            return '<_G>'
        end
        if type(item) == 'string' and #item > 1000 then
            return item:sub(1, 450) .. '...' .. item:sub(-450)
        end
        return item
    end
}
function ls.inspect(root)
    return inspect.inspect(root, inspectOptions)
end

return ls
