local ckind    = require 'define.CompletionItemKind'
local files    = require 'files'
local guide    = require 'parser.guide'
local matchKey = require 'core.matchKey'
local vm       = require 'vm'
local library  = require 'library'
local getLabel = require 'core.hover.label'
local getName  = require 'core.hover.name'
local getArg   = require 'core.hover.arg'
local config   = require 'config'
local util     = require 'utility'

local function isSpace(char)
    if char == ' '
    or char == '\n'
    or char == '\r'
    or char == '\t' then
        return true
    end
    return false
end

local function findWord(text, offset)
    for i = offset, 1, -1 do
        if not text:sub(i, i):match '[%w_]' then
            if i == offset then
                return nil
            end
            return text:sub(i+1, offset)
        end
    end
    return text:sub(1, offset)
end

local function findAnyPos(text, offset)
    for i = offset, 1, -1 do
        if not isSpace(text:sub(i, i)) then
            return i
        end
    end
    return nil
end

local function findParent(ast, text, offset)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if isSpace(char) then
            goto CONTINUE
        end
        local oop
        if char == '.' then
            oop = false
        elseif char == ':' then
            oop = true
        else
            return nil, nil
        end
        local anyPos = findAnyPos(text, i-1)
        if not anyPos then
            return nil, nil
        end
        local parent = guide.eachSourceContain(ast.ast, anyPos, function (source)
            if source.finish == anyPos then
                return source
            end
        end)
        if parent then
            return parent, oop
        end
        ::CONTINUE::
    end
    return nil, nil
end

local function checkLocal(ast, word, offset, results)
    local locals = guide.getVisibleLocals(ast.ast, offset)
    for name in pairs(locals) do
        if matchKey(word, name) then
            results[#results+1] = {
                label = name,
                kind  = ckind.Variable,
            }
        end
    end
end

local function isSameSource(source, pos)
    return source.start <= pos and source.finish >= pos
end

local function checkField(ast, text, word, offset, results)
    local myStart = offset - #word + 1
    local parent, oop = findParent(ast, text, myStart - 1)
    if not parent then
        parent = guide.getLocal(ast.ast, '_ENV', offset)
        if not parent then
            return
        end
    end
    local used = {}
    vm.eachField(parent, function (info)
        local key = info.key
        if key
        and key:sub(1, 1) == 's'
        and not isSameSource(info.source, myStart) then
            local name = key:sub(3)
            if not used[name] and matchKey(word, name) then
                results[#results+1] = {
                    label = name,
                    kind  = ckind.Field,
                }
            end
            used[name] = true
        end
    end)
end

local function buildFunctionSnip(source)
    local name = getName(source)
    local arg  = getArg(source)
    return ('%s(%s)'):format(name, arg)
end

local function buildFunction(results, source, oop, data)
    local snipType = config.config.completion.callSnippet
    if snipType == 'Disable' or snipType == 'Both' then
        results[#results+1] = data
    end
    if snipType == 'Both' or snipType == 'Replace' then
        local snipData = util.deepCopy(data)
        snipData.kind = ckind.Snippet
        snipData.label = snipData.label .. '()'
        snipData.insertText = buildFunctionSnip(source)
        results[#results+1] = snipData
    end
end

local function checkLibrary(ast, text, word, offset, results)
    for name, lib in pairs(library.global) do
        if matchKey(word, name) then
            buildFunction(results, lib, false, {
                label = name,
                kind  = ckind.Function,
                documentation = lib.description,
                detail = getLabel(lib),
            })
        end
    end
end

local function checkCommon(word, text, results)
    local used = {}
    for _, result in ipairs(results) do
        used[result.label] = true
    end
    for str in text:gmatch '[%a_][%w_]*' do
        if not used[str] and str ~= word then
            used[str] = true
            if matchKey(word, str) then
                results[#results+1] = {
                    label = str,
                    kind  = ckind.Text,
                }
            end
        end
    end
end

local function isInString(ast, offset)
    return guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'string' then
            return true
        end
    end)
end

local function tryWord(ast, text, offset, results)
    local word = findWord(text, offset)
    if not word then
        return nil
    end
    if not isInString(ast, offset) then
        checkLocal(ast, word, offset, results)
        checkField(ast, text, word, offset, results)
        checkLibrary(ast, text, word, offset, results)
    end
    checkCommon(word, text, results)
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
