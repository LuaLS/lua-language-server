local guide        = require 'parser.guide'
local lookback     = require 'core.look-backward'
local matchKey     = require 'core.matchkey'
local subString    = require 'core.substring'
local define       = require 'proto.define'

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
        callback(('pcall(%s)'):format(subber(source.start + 1, source.finish)))
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
                    textEdit   = {
                        start   = wordPosition + 1,
                        finish  = position,
                        newText = '',
                    },
                    additionalTextEdits = {
                        {
                            start   = source.start,
                            finish  = wordPosition + 1,
                            newText = newText,
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
