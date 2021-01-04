local define     = require 'proto.define'
local guide      = require 'parser.guide'

local keyWordMap = {
    {'do', function (hasSpace, isExp, results)
        if hasSpace then
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
    end, function (ast, start)
        return guide.eachSourceContain(ast.ast, start, function (source)
            if source.type == 'while'
            or source.type == 'in'
            or source.type == 'loop' then
                for i = 1, #source.keyword do
                    if start == source.keyword[i] then
                        return true
                    end
                end
            end
        end)
    end},
    {'and'},
    {'break'},
    {'else'},
    {'elseif', function (hasSpace, isExp, results)
        if hasSpace then
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
    {'for', function (hasSpace, isExp, results)
        if hasSpace then
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
${1:key}, ${2:value} in pairs(${3:t})}do\
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
    {'function', function (hasSpace, isExp, results)
        if hasSpace then
            results[#results+1] = {
                label = 'function ()',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = isExp and "\z
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
                insertText = isExp and "\z
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
    {'if', function (hasSpace, isExp, results)
        if hasSpace then
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
    {'in', function (hasSpace, isExp, results)
        if hasSpace then
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
    {'local', function (hasSpace, isExp, results)
        if hasSpace then
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
    {'repeat', function (hasSpace, isExp, results)
        if hasSpace then
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
    {'return', function (hasSpace, isExp, results)
        if not hasSpace then
            results[#results+1] = {
                label = 'do return end',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[do return $1end]]
            }
        end
        return false
    end},
    {'then'},
    {'true'},
    {'until'},
    {'while', function (hasSpace, isExp, results)
        if hasSpace then
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
