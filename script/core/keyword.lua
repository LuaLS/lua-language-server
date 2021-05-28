local define     = require 'proto.define'
local files      = require 'files'
local guide      = require 'parser.guide'

local keyWordMap = {
    {'do', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'do .. end',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[$0 end]],
            }
        else
            results[#results+1] = {
                label = 'do .. end',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
do\
\t$0\
end",
            }
        end
        return true
    end, function (info)
        return guide.eachSourceContain(info.ast.ast, info.start, function (source)
            if source.type == 'while'
            or source.type == 'in'
            or source.type == 'loop' then
                for i = 1, #source.keyword do
                    if info.start == source.keyword[i] then
                        return true
                    end
                end
            end
        end)
    end},
    {'and'},
    {'break'},
    {'else'},
    {'elseif', function (info, results)
        if info.text:find('^%s*then', info.offset + 1)
        or info.text:find('^%s*do', info.offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label = 'elseif .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[$1 then]],
            }
        else
            results[#results+1] = {
                label = 'elseif .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[elseif $1 then]],
            }
        end
        return true
    end},
    {'end'},
    {'false'},
    {'for', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'for .. ipairs',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
${1:index}, ${2:value} in ipairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label = 'for .. pairs',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
${1:key}, ${2:value} in pairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label = 'for i = ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
${1:i} = ${2:1}, ${3:10, 1} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'for .. ipairs',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
for ${1:index}, ${2:value} in ipairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label = 'for .. pairs',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
for ${1:key}, ${2:value} in pairs(${3:t}) do\
\t$0\
end"
            }
            results[#results+1] = {
                label = 'for i = ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
for ${1:i} = ${2:1}, ${3:10, 1} do\
\t$0\
end"
            }
        end
        return true
    end},
    {'function', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'function ()',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = info.isExp and "\z
($1)\
\t$0\
end" or "\z
$1($2)\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'function ()',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = info.isExp and "\z
function ($1)\
\t$0\
end" or "\z
function $1($2)\
\t$0\
end"
            }
        end
        return true
    end},
    {'goto'},
    {'if', function (info, results)
        if info.text:find('^%s*then', info.offset + 1)
        or info.text:find('^%s*do', info.offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label = 'if .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
$1 then\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'if .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
if $1 then\
\t$0\
end"
            }
        end
        return true
    end},
    {'in', function (info, results)
        if info.text:find('^%s*then', info.offset + 1)
        or info.text:find('^%s*do', info.offset + 1) then
            return false
        end
        if info.hasSpace then
            results[#results+1] = {
                label = 'in ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
${1:pairs(${2:t})} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'in ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
in ${1:pairs(${2:t})} do\
\t$0\
end"
            }
        end
        return true
    end},
    {'local', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'local function',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
function $1($2)\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'local function',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
local function $1($2)\
\t$0\
end"
            }
        end
        return false
    end},
    {'nil'},
    {'not'},
    {'or'},
    {'repeat', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'repeat .. until',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[$0 until $1]]
            }
        else
            results[#results+1] = {
                label = 'repeat .. until',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
repeat\
\t$0\
until $1"
            }
        end
        return true
    end},
    {'return', function (info, results)
        if not info.hasSpace then
            results[#results+1] = {
                label = 'do return end',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[do return $1end]]
            }
        end
        return false
    end},
    {'then', function (info, results)
        local lines = files.getLines(info.uri)
        local pos, first = info.text:match('%S+%s+()(%S+)', info.start)
        if first == 'end'
        or first == 'else'
        or first == 'elseif' then
            local startRow  = guide.positionOf(lines, info.start)
            local finishRow = guide.positionOf(lines, pos)
            local startSp   = info.text:match('^%s*', lines[startRow].start)
            local finishSp  = info.text:match('^%s*', lines[finishRow].start)
            if startSp == finishSp then
                return false
            end
        end
        if not info.hasSpace then
            results[#results+1] = {
                label = 'then .. end',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = '\z
then\
\t$0\
end'
            }
        end
        return true
    end},
    {'true'},
    {'until'},
    {'while', function (info, results)
        if info.hasSpace then
            results[#results+1] = {
                label = 'while .. do',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
${1:true} do\
\t$0\
end"
            }
        else
            results[#results+1] = {
                label = 'while .. do',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = "\z
while ${1:true} do\
\t$0\
end"
            }
        end
        return true
    end},
}

return keyWordMap
