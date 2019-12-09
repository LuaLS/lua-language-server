local ckind    = require 'define.CompletionItemKind'
local files    = require 'files'
local guide    = require 'parser.guide'
local matchKey = require 'core.matchKey'

local function findWord(text, offset)
    for i = offset, 1, -1 do
        if not text:sub(i, i):match '[%w_]' then
            if i == offset then
                return nil
            end
            return text:sub(i+1, offset)
        end
    end
    return nil
end

local function checkLocal(ast, word, offset, results)
    guide.getVisibleLocalNames(ast.ast, offset, function (name)
        if matchKey(word, name) then
            results[#results+1] = {
                label = name,
                kind  = ckind.Variable,
            }
        end
    end)
end

local function tryWord(ast, text, offset, results)
    local word = findWord(text, offset)
    if not word then
        return nil
    end
    checkLocal(ast, word, offset, results)
end

return function (uri, offset)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local text = files.getText(uri)
    local results = {}

    tryWord(ast, text, offset, results)

    if #results == 0 then
        return nil
    end
    return results
end
