local define     = require 'proto.define'
local guide      = require 'parser.guide'

local keyWordMap = {
    {'do', function (hasSpace, results)
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
                insertText = [[
do
    $0
end]],
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
    {'elseif', function (hasSpace, results)
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
    {'for', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'for .. in',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
${1:key, value} in ${2:pairs(${3:t})} do
    $0
end]]
            }
            results[#results+1] = {
                label = 'for i = ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
${1:i} = ${2:1}, ${3:10, 1} do
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'for .. in',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
for ${1:key, value} in ${2:pairs(${3:t})} do
    $0
end]]
            }
            results[#results+1] = {
                label = 'for i = ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
for ${1:i} = ${2:1}, ${3:10, 1} do
    $0
end]]
            }
        end
        return true
    end},
    {'function', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'function ()',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
$1($2)
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'function ()',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
function $1($2)
    $0
end]]
            }
        end
        return true
    end},
    {'goto'},
    {'if', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'if .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
$1 then
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'if .. then',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
if $1 then
    $0
end]]
            }
        end
        return true
    end},
    {'in', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'in ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
${1:pairs(${2:t})} do
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'in ..',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
in ${1:pairs(${2:t})} do
    $0
end]]
            }
        end
        return true
    end},
    {'local', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'local function',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
function $1($2)
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'local function',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
local function $1($2)
    $0
end]]
            }
        end
        return false
    end},
    {'nil'},
    {'not'},
    {'or'},
    {'repeat', function (hasSpace, results)
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
                insertText = [[
repeat
    $0
until $1]]
            }
        end
        return true
    end},
    {'return', function (hasSpace, results)
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
    {'while', function (hasSpace, results)
        if hasSpace then
            results[#results+1] = {
                label = 'while .. do',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
${1:true} do
    $0
end]]
            }
        else
            results[#results+1] = {
                label = 'while .. do',
                kind  = define.CompletionItemKind.Snippet,
                insertTextFormat = 2,
                insertText = [[
while ${1:true} do
    $0
end]]
            }
        end
        return true
    end},
}

return keyWordMap
