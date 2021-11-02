local files     = require 'files'
local json      = require 'json'
local util      = require 'utility'
local proto     = require 'proto'
local define    = require 'proto.define'
local lang      = require 'language'
local converter = require 'proto.converter'
local guide     = require 'parser.guide'

---@async
return function (data)
    local state = files.getState(data.uri)
    local text  = files.getText(data.uri)
    if not text then
        return
    end
    local start  = guide.positionToOffset(state, data.start)
    local finish = guide.positionToOffset(state, data.finish)
    local jsonStr = text:sub(start + 1, finish)
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
                [data.uri] = {
                    {
                        range   = converter.packRange(data.uri, data.start, data.finish),
                        newText = luaStr,
                    }
                }
            }
        }
    })
end
