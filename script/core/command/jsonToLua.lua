local files     = require 'files'
local util      = require 'utility'
local proto     = require 'proto'
local define    = require 'proto.define'
local lang      = require 'language'
local converter = require 'proto.converter'
local guide     = require 'parser.guide'
local json      = require 'json'
local jsonc     = require 'jsonc'

---@async
return function (data)
    local state = files.getState(data.uri)
    local text  = files.getText(data.uri)
    if not text or not state then
        return
    end
    local start    = guide.positionToOffset(state, data.start)
    local finish   = guide.positionToOffset(state, data.finish)
    local jsonStr  = text:sub(start + 1, finish)
    local suc, res = pcall(jsonc.decode_jsonc, jsonStr:match '[%{%[].+')
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
                        range   = converter.packRange(state, data.start, data.finish),
                        newText = luaStr,
                    }
                }
            }
        }
    })
end
