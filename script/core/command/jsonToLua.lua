local files  = require 'files'
local json   = require 'json'
local util   = require 'utility'
local proto  = require 'proto'
local define = require 'proto.define'
local lang   = require 'language'

return function (data)
    local text = files.getText(data.uri)
    if not text then
        return
    end
    local jsonStr = text:sub(data.start, data.finish)
    local suc, res = pcall(json.decode, jsonStr)
    if not suc then
        proto.notify('window/showMessage', {
            type     = define.MessageType.Warning,
            message  = lang.script('COMMAND_JSON_TO_LUA_FAILED', res:match '%:%d+%:(.+)'),
        })
        return
    end
    local luaStr = util.dump(res)
    proto.awaitRequest('workspace/applyEdit', {
        label = 'json to lua',
        edit  = {
            changes = {
                [files.getOriginUri(data.uri)] = {
                    {
                        range   = files.range(data.uri, data.start, data.finish),
                        newText = luaStr,
                    }
                }
            }
        }
    })
end
