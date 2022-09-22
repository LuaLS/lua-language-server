local files     = require 'files'
local json      = require 'jsonc'
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
    local start    = guide.positionToOffset(state, data.start)
    local finish   = guide.positionToOffset(state, data.finish)
    local jsonStr  = text:sub(start + 1, finish)
    local suc, res = pcall(json.decode, jsonStr:match '[%{%[].+')
    if not suc or res == json.null then
        proto.notify('window/showMessage', {
            type     = define.MessageType.Warning,
            message  = lang.script('COMMAND_JSON_TO_LUA_FAILED', res:match '%:%d+%:(.+)'),
        })
        return
    end
    ---@cast res table
    local luaStr = util.dump(res)
    if jsonStr:sub(1, 1) == '"' then
        local key = jsonStr:match '^"([^\r\n]+)"'
        if key then
            if key:match '^[%a_]%w*$' then
                luaStr = ('%s = %s'):format(key, luaStr)
            else
                luaStr = ('[%q] = %s'):format(key, luaStr)
            end
        end
    end
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
