local guide        = require 'parser.guide'
local lookback     = require 'core.look-backward'
local matchKey     = require 'core.matchkey'
local subString    = require 'core.substring'
local define       = require 'proto.define'
local markdown     = require 'provider.markdown'
local config       = require 'config'

local actions = {}

local function register(key)
    return function (data)
        actions[#actions+1] = {
            key  = key,
            data = data
        }
    end
end

local function hasNonFieldInNode(source)
    local block = guide.getParentBlock(source)
    while source ~= block do
        if source.type == 'call'
        or source.type == 'getindex'
        or source.type == 'getmethod' then
            return true
        end
        source = source.parent
    end
    return false
end

register 'function' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getlocal'
        and source.type ~= 'local' then
            return
        end
        if hasNonFieldInNode(source) then
            return
        end
        local subber = subString(state)
        callback(string.format('function %s($1)\n\t$0\nend'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'method' {
    function (state, source, callback)
        if  source.type == 'getfield' then
            if hasNonFieldInNode(source) then
                return
            end
            local subber = subString(state)
            callback(string.format('function %s:%s($1)\n\t$0\nend'
                , subber(source.start + 1, source.dot.start)
                , subber(source.dot .finish + 1, source.finish)
            ))
        end
        if  source.type == 'getmethod' then
            if hasNonFieldInNode(source.parent) then
                return
            end
            local subber = subString(state)
            callback(string.format('function %s:%s($1)\n\t$0\nend'
                , subber(source.start + 1, source.colon.start)
                , subber(source.colon.finish + 1, source.finish)
            ))
        end
    end
}

register 'pcall' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getmethod'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal'
        and source.type ~= 'call' then
            return
        end
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
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getmethod'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal'
        and source.type ~= 'call' then
            return
        end
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

register 'insert' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getmethod'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal'
        and source.type ~= 'call'
        and source.type ~= 'table' then
            return
        end
        local subber = subString(state)
        callback(string.format('table.insert(%s, $0)'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'remove' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getmethod'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal'
        and source.type ~= 'call'
        and source.type ~= 'table' then
            return
        end
        local subber = subString(state)
        callback(string.format('table.remove(%s, $0)'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'concat' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getmethod'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal'
        and source.type ~= 'call'
        and source.type ~= 'table' then
            return
        end
        local subber = subString(state)
        callback(string.format('table.concat(%s, $0)'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register '++' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal' then
            return
        end
        local subber = subString(state)
        callback(string.format('%s = %s + 1'
            , subber(source.start + 1, source.finish)
            , subber(source.start + 1, source.finish)
        ))
    end
}

register '++?' {
    function (state, source, callback)
        if  source.type ~= 'getglobal'
        and source.type ~= 'getfield'
        and source.type ~= 'getindex'
        and source.type ~= 'getlocal' then
            return
        end
        local subber = subString(state)
        callback(string.format('%s = (%s or 0) + 1'
            , subber(source.start + 1, source.finish)
            , subber(source.start + 1, source.finish)
        ))
    end
}

local accepts = {
    ['local']     = true,
    ['getlocal']  = true,
    ['getglobal'] = true,
    ['getfield']  = true,
    ['getindex']  = true,
    ['getmethod'] = true,
    ['call']      = true,
    ['table']     = true,
}

local function checkPostFix(state, word, wordPosition, position, results)
    local source = guide.eachSourceContain(state.ast, wordPosition, function (source)
        if accepts[source.type] then
            return source
        end
    end)
    if not source then
        return
    end
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
    if guide.isInString(state.ast, position) then
        return false
    end
    local text = state.lua
    local offset = guide.positionToOffset(state, position)
    local word, newOffset = lookback.findWord(text, offset)
    if newOffset then
        offset = newOffset - 1
    end
    local symbol = text:sub(offset, offset)
    if symbol == config.get 'Lua.completion.postfix' then
        local wordPosition = guide.offsetToPosition(state, offset - 1)
        checkPostFix(state, word or '', wordPosition, position, results)
        return symbol ~= '.' and symbol ~= ':'
    end
    if not word then
        if symbol == '+' then
            word = text:sub(offset - 1, offset)
            offset = offset - 2
        end
        if symbol == '?' then
            word = text:sub(offset - 2, offset)
            offset = offset - 3
        end
        if word then
            local wordPosition = guide.offsetToPosition(state, offset - 1)
            checkPostFix(state, word or '', wordPosition, position, results)
            return true
        end
    end
    return false
end
