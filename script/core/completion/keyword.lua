local define     = require 'proto.define'
local files      = require 'files'
local guide      = require 'parser.guide'
local config     = require 'config'
local util       = require 'utility'
local lookback   = require 'core.look-backward'

local keyWordMap = {
    { 'do', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'do .. end',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = [[$0 end]],
            }
        else
            results[#results+1] = {
                label            = 'do .. end',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
do\
\t$0\
end",
            }
        end
        return true
    end, function(info)
        return guide.eachSourceContain(info.state.ast, info.start, function(source)
            if source.type == 'while'
            or source.type == 'in'
            or source.type == 'loop' then
                if source.finish - info.start <= 2 then
                    return true
                end
            end
        end)
    end },
    { 'and' },
    { 'break' },
    { 'else' },
    { 'elseif', function(info, results)
        local offset = guide.positionToOffset(info.state, info.position)
        if info.text:find('^%s*then', offset + 1)
        or info.text:find('^%s*do', offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label            = 'elseif .. then',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = [[$1 then]],
            }
        else
            results[#results+1] = {
                label            = 'elseif .. then',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = [[elseif $1 then]],
            }
        end
        return true
    end },
    { 'end' },
    { 'false' },
    { 'for', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'for .. ipairs',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
${1:index}, ${2:value} in ipairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label            = 'for .. pairs',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
${1:key}, ${2:value} in pairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label            = 'for i = ..',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
${1:i} = ${2:1}, ${3:10, 1} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'for .. ipairs',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
for ${1:index}, ${2:value} in ipairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label            = 'for .. pairs',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
for ${1:key}, ${2:value} in pairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label            = 'for i = ..',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
for ${1:i} = ${2:1}, ${3:10, 1} do\
\t$0\
end"
            }
        end
        return true
    end },
    { 'function', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'function ()',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = info.isExp and "\z
($1)\
\t$0\
end" or "\z
$1($2)\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'function ()',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = info.isExp and "\z
function ($1)\
\t$0\
end" or "\z
function $1($2)\
\t$0\
end"
            }
        end
        return true
    end },
    { 'goto' },
    { 'if', function(info, results)
        local offset = guide.positionToOffset(info.state, info.position)
        if info.text:find('^%s*then', offset + 1)
        or info.text:find('^%s*do', offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label            = 'if .. then',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
$1 then\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'if .. then',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
if $1 then\
\t$0\
end"
            }
        end
        return true
    end },
    { 'in', function(info, results)
        local offset = guide.positionToOffset(info.state, info.position)
        if info.text:find('^%s*then', offset + 1)
        or info.text:find('^%s*do', offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label            = 'in ..',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
${1:pairs(${2:t})} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'in ..',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
in ${1:pairs(${2:t})} do\
\t$0\
end"
            }
        end
        return true
    end },
    { 'local', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'local function',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
function $1($2)\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'local function',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
local function $1($2)\
\t$0\
end"
            }
        end
        return false
    end },
    { 'nil' },
    { 'not' },
    { 'or' },
    { 'repeat', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'repeat .. until',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = [[$0 until $1]]
            }
        else
            results[#results+1] = {
                label            = 'repeat .. until',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
repeat\
\t$0\
until $1"
            }
        end
        return true
    end },
    { 'return', function(info, results)
        if not info.hasSpace then
            results[#results+1] = {
                label            = 'do return end',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = [[do return $1end]]
            }
        end
        return false
    end },
    { 'then', function(info, results)
        local startOffset = guide.positionToOffset(info.state, info.start)
        local pos, first = info.text:match('%S+%s+()(%S+)', startOffset + 1)
        if first == 'end'
        or first == 'else'
        or first == 'elseif' then
            local startRow       = guide.rowColOf(info.start)
            local finishPosition = guide.offsetToPosition(info.state, pos)
            local finishRow      = guide.rowColOf(finishPosition)
            local startSp        = info.text:match('^%s*', info.state.lines[startRow])
            local finishSp       = info.text:match('^%s*', info.state.lines[finishRow])
            if startSp == finishSp then
                return false
            end
        end
        if not info.hasSpace then
            results[#results+1] = {
                label            = 'then .. end',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = '\z
then\
\t$0\
end'
            }
        end
        return true
    end },
    { 'true' },
    { 'until' },
    { 'while', function(info, results)
        if info.hasSpace then
            results[#results+1] = {
                label            = 'while .. do',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
${1:true} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label            = 'while .. do',
                kind             = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText       = "\z
while ${1:true} do\
\t$0\
end"
            }
        end
        return true
    end },
    { 'continue', function (info, results)
        local nonstandardSymbol = config.get(info.uri, 'Lua.runtime.nonstandardSymbol')
        if util.arrayHas(nonstandardSymbol, 'continue') then
            return
        end
        local version = config.get(info.uri, 'Lua.runtime.version')
        if version == 'Lua 5.1' then
            return
        end
        local mostInsideBlock
        guide.eachSourceContain(info.state.ast, info.start, function (src)
            if src.type == 'while'
            or src.type == 'in'
            or src.type == 'loop'
            or src.type == 'repeat' then
                mostInsideBlock = src
            end
        end)
        if not mostInsideBlock then
            return
        end
        -- 找一下 end 的位置
        local endPos
        if mostInsideBlock.type == 'while' then
            endPos = mostInsideBlock.keyword[5]
        elseif mostInsideBlock.type == 'in' then
            endPos = mostInsideBlock.keyword[7]
        elseif mostInsideBlock.type == 'loop' then
            endPos = mostInsideBlock.keyword[5]
        elseif mostInsideBlock.type == 'repeat' then
            endPos = mostInsideBlock.keyword[3]
        end
        if not endPos then
            return
        end
        local endLine     = guide.rowColOf(endPos)
        local tabStr = info.state.lua:sub(
            info.state.lines[endLine],
            guide.positionToOffset(info.state, endPos)
        )
        local newText
        if tabStr:match '^[\t ]*$' then
            newText = '    ::continue::\n' .. tabStr
        else
            newText = '::continue::'
        end
        local additional = {}

        local word = lookback.findWord(info.state.lua, guide.positionToOffset(info.state, info.start) - 1)
        if word ~= 'goto' then
            additional[#additional+1] = {
                start   = info.start,
                finish  = info.start,
                newText = 'goto ',
            }
        end

        local hasContinue = guide.eachSourceType(mostInsideBlock, 'label', function (src)
            if src[1] == 'continue' then
                return true
            end
        end)

        if not hasContinue then
            additional[#additional+1] = {
                start   = endPos,
                finish  = endPos,
                newText = newText,
            }
        end
        results[#results+1] = {
            label      = 'goto continue ..',
            kind       = define.CompletionItemKind.Snippet,
            insertText = "continue",
            additionalTextEdits = additional,
        }
        return true
    end }
}

return keyWordMap
