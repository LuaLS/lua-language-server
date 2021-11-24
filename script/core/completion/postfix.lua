local guide        = require 'parser.guide'
local lookback     = require 'core.look-backward'
local matchKey     = require 'core.matchkey'
local subString    = require 'core.substring'
local define       = require 'proto.define'
local markdown     = require 'provider.markdown'

local actions = {}

local function register(key)
    return function (data)
        actions[#actions+1] = {
            key  = key,
            data = data
        }
    end
end

register 'pcall' {
    function (state, source, callback)
        local subber = subString(state)
        if source.type == 'call' then
            if source.args and #source.args > 0 then
                callback(string.format('pcall(%s, %s)'
                    , subber(source.node.start + 1, source.node.finish)
                    , subber(source.args[1].start + 1, source.args[#source.args].finish)
                ))
            else
                callback(string.format('pcall(%s)'
                    , subber(source.node.start + 1, source.node.finish)
                ))
            end
        else
            callback(string.format('pcall(%s$1)$0'
                , subber(source.start + 1, source.finish)
            ))
        end
    end
}

register 'xpcall' {
    function (state, source, callback)
        local subber = subString(state)
        if source.type == 'call' then
            if source.args and #source.args > 0 then
                callback(string.format('xpcall(%s, ${1:debug.traceback}, %s)$0'
                    , subber(source.node.start + 1, source.node.finish)
                    , subber(source.args[1].start + 1, source.args[#source.args].finish)
                ))
            else
                callback(string.format('xpcall(%s, ${1:debug.traceback})$0'
                    , subber(source.node.start + 1, source.node.finish)
                ))
            end
        else
            callback(string.format('xpcall(%s, ${1:debug.traceback}$2)$0'
                , subber(source.start + 1, source.finish)
            ))
        end
    end
}

local accepts = {
    ['getglobal'] = true,
    ['getfield']  = true,
    ['getindex']  = true,
    ['getmethod'] = true,
    ['call']      = true,
}

local function checkPostFix(state, word, wordPosition, position, results)
    local source = guide.eachSourceContain(state.ast, wordPosition, function (source)
        if accepts[source.type] then
            return source
        end
    end)
    for _, action in ipairs(actions) do
        if matchKey(word, action.key) then
            action.data[1](state, source, function (newText)
                results[#results+1] = {
                    label      = action.key,
                    kind       = define.CompletionItemKind.Event,
                    description= markdown()
                                    : add('lua', newText)
                                    : string(),
                    textEdit   = {
                        start   = wordPosition + 1,
                        finish  = position,
                        newText = newText,
                    },
                    additionalTextEdits = {
                        {
                            start   = source.start,
                            finish  = wordPosition + 1,
                            newText = '',
                        },
                    },
                }
            end)
        end
    end
end

return function (state, position, results)
    local text = state.lua
    local offset = guide.positionToOffset(state, position)
    local word, newOffset = lookback.findWord(text, offset)
    if newOffset then
        offset = newOffset - 1
    end
    local symbol = text:sub(offset, offset)
    if symbol == '@' then
        local wordPosition = guide.offsetToPosition(state, offset - 1)
        checkPostFix(state, word or '', wordPosition, position, results)
        return true
    end
    return false
end
