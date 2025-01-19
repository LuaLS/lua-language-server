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
        if source.type == 'getfield' then
            if hasNonFieldInNode(source) then
                return
            end
            local subber = subString(state)
            callback(string.format('function %s:%s($1)\n\t$0\nend'
                , subber(source.start + 1, source.dot.start)
                , subber(source.dot.finish + 1, source.finish)
            ))
        end
        if source.type == 'getmethod' then
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

register 'ifcall' {
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
                callback(string.format('if %s then %s(%s) end$0'
                    , subber(source.node.start + 1, source.node.finish)
                    , subber(source.node.start + 1, source.node.finish)
                    , subber(source.args[1].start + 1, source.args[#source.args].finish)
                ))
            else
                callback(string.format('if %s then %s() end$0'
                    , subber(source.node.start + 1, source.node.finish)
                    , subber(source.node.start + 1, source.node.finish)
                ))
            end
        else
            callback(string.format('if %s then %s($1) end$0'
                , subber(source.node.start + 1, source.node.finish)
                , subber(source.node.start + 1, source.node.finish)
            ))
        end
    end
}

register 'local' {
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
        callback(string.format('local $1 = %s$0'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'ipairs' {
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
        callback(string.format('for ${1:i}, ${2:v} in ipairs(%s) do\n\t$0\nend'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'pairs' {
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
        callback(string.format('for ${1:k}, ${2:v} in pairs(%s) do\n\t$0\nend'
            , subber(source.start + 1, source.finish)
        ))
    end
}

register 'unpack' {
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
        callback(string.format('unpack(%s)'
            , subber(source.start + 1, source.finish)
        ))
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

local function checkPostFix(state, word, wordPosition, position, symbol, results)
    local source = guide.eachSourceContain(state.ast, wordPosition, function (source)
        if  accepts[source.type]
        and source.finish == wordPosition then
            return source
        end
    end)
    if not source then
        return
    end
    for i, action in ipairs(actions) do
        if matchKey(word, action.key) then
            action.data[1](state, source, function (newText)
                local descText = newText:gsub('%$%{%d+:([^}]+)%}', function (val)
                    return val
                end):gsub('%$%{?%d+%}?', '')
                results[#results+1] = {
                    label       = action.key,
                    kind        = define.CompletionItemKind.Snippet,
                    description = markdown()
                                    : add('lua', descText)
                                    : string(),
                    textEdit    = {
                        start   = wordPosition + #symbol,
                        finish  = position,
                        newText = newText,
                    },
                    sortText    = ('postfix-%04d'):format(i),
                    insertTextFormat = 2,

                    additionalTextEdits = {
                        {
                            start   = source.start,
                            finish  = wordPosition + #symbol,
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
    if symbol == config.get(state.uri, 'Lua.completion.postfix') then
        local wordPosition = guide.offsetToPosition(state, offset - 1)
        checkPostFix(state, word or '', wordPosition, position, symbol, results)
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
            local wordPosition = guide.offsetToPosition(state, offset)
            checkPostFix(state, word or '', wordPosition, position, '', results)
            return true
        end
    end
    return false
end
