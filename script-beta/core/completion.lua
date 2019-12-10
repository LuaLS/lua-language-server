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

local stackID = 0
local stacks = {}
local function stack(callback)
    stackID = stackID + 1
    stacks[stackID] = callback
    return stackID
end

local function clearStack()
    stacks = {}
end

local function resolveStack(id)
    local callback = stacks[id]
    if not callback then
        return nil
    end
    return callback()
end

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

local function buildFunctionSnip(source)
    local name = getName(source):gsub('^.-[$.:]', '')
    local args = getArg(source)
    local id = 0
    args = args:gsub('[^,]+', function (arg)
        id = id + 1
        return arg:gsub('^(%s*)(.+)', function (sp, word)
            return ('%s${%d:%s}'):format(sp, id, word)
        end)
    end)
    return ('%s(%s)'):format(name, args)
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
        snipData.insertTextFormat = 2
        results[#results+1] = snipData
    end
end

local function buildDesc(source)
    if source.description then
        return source.description
    end
    local lib = vm.getLibrary(source)
    if lib then
        return lib.description
    end
end

local function checkLocal(ast, word, offset, results)
    local locals = guide.getVisibleLocals(ast.ast, offset)
    for name, source in pairs(locals) do
        if matchKey(word, name) then
            if vm.hasType(source, 'function') then
                buildFunction(results, source, false, {
                    label  = name,
                    kind   = ckind.Function,
                    id     = stack(function ()
                        return {
                            detail      = getLabel(source),
                            description = buildDesc(source),
                        }
                    end),
                })
            else
                results[#results+1] = {
                    label  = name,
                    kind   = ckind.Variable,
                    id     = stack(function ()
                        return {
                            detail      = getLabel(source),
                            description = buildDesc(source),
                        }
                    end),
                }
            end
        end
    end
end

local function isSameSource(source, pos)
    return source.start <= pos and source.finish >= pos
end

local function checkField(word, start, parent, oop, results)
    local used = {}
    vm.eachField(parent, function (info)
        local key = info.key
        if not key or key:sub(1, 1) ~= 's' then
            return
        end
        if isSameSource(info.source, start) then
            return
        end
        local name = key:sub(3)
        if used[name] then
            return
        end
        if not matchKey(word, name) then
            used[name] = true
            return
        end
        local kind = ckind.Field
        if vm.hasType(info.source, 'function') then
            if oop then
                kind = ckind.Method
            end
            used[name] = true
            buildFunction(results, info.source, oop, {
                label = name,
                kind  = kind,
                id    = stack(function ()
                    return {
                        detail      = getLabel(info.source),
                        description = buildDesc(info.source),
                    }
                end),
            })
        else
            if oop then
                return
            end
            used[name] = true
            local literal = vm.getLiteral(info.source)
            if literal ~= nil then
                kind = ckind.Enum
            end
            results[#results+1] = {
                label = name,
                kind  = kind,
                id    = stack(function ()
                    return {
                        detail      = getLabel(info.source),
                        description = buildDesc(info.source),
                    }
                end)
            }
        end
    end)
end

local function checkLibrary(word, results)
    for name, lib in pairs(library.global) do
        if matchKey(word, name) then
            if lib.type == 'function' then
                buildFunction(results, lib, false, {
                    label = name,
                    kind  = ckind.Function,
                    id    = stack(function ()
                        return {
                            detail        = getLabel(lib),
                            documentation = buildDesc(lib),
                        }
                    end),
                })
            end
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

local keyWordMap = {
{'and'},
{'break'},
{'do', function (ast, text, start, results)
    if config.config.completion.keywordSnippet then
        guide.eachSourceContain()
        results[#results+1] = {
            label = 'do .. end',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
do
    $0
end]],
        }
    end
end},
{'else'},
{'elseif', function (ast, text, start, results)
    if config.config.completion.keywordSnippet then
        results[#results+1] = {
            label = 'elseif .. then',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[elseif $1 then]],
        }
    end
end},
{'end'},
{'false'},
{'for', function (ast, text, start, results)
    if config.config.completion.keywordSnippet then
        results[#results+1] = {
            label = 'for .. in',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
for ${1:key, value} in ${2:pairs(t)} do
    $0
end]]
        }
        results[#results+1] = {
            label = 'for i = ..',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
for ${1:i} = ${2:1}, ${3:10, 2} do
    $0
end]]
        }
    end
end},
{'function', function (ast, text, start, results)

end},
{'goto'},
{'if'},
{'in'},
{'local', function (ast, text, start, results)
    if config.config.completion.keywordSnippet then
        results[#results+1] = {
            label = 'local function',
            kind  = ckind.Snippet,
        }
    end
end},
{'nil'},
{'not'},
{'or'},
{'repeat'},
{'return'},
{'then'},
{'true'},
{'until'},
{'while'},
}

local function checkKeyWord(ast, text, start, word, results)
    for _, data in ipairs(keyWordMap) do
        local key = data[1]
        if matchKey(word, key) then
            results[#results+1] = {
                label = key,
                kind  = ckind.Keyword,
            }
            local func = data[2]
            if func then
                func(ast, text, start, results)
            end
        end
    end
end

local function tryWord(ast, text, offset, results)
    local word = findWord(text, offset)
    if not word then
        return nil
    end
    local start = offset - #word + 1
    if not isInString(ast, offset) then
        local parent, oop = findParent(ast, text, start - 1)
        if parent then
            checkField(word, start, parent, oop, results)
        else
            checkLocal(ast, word, start, results)
            local env = guide.getLocal(ast.ast, '_ENV', start)
            checkField(word, start, env, false, results)
            checkLibrary(word, results)
            checkKeyWord(ast, text, start, word, results)
        end
    end
    checkCommon(word, text, results)
end

local function completion(uri, offset)
    local ast = files.getLastAst(uri)
    if not ast then
        return nil
    end
    clearStack()
    local text = files.getText(uri)
    local results = {}

    tryWord(ast, text, offset, results)

    if #results == 0 then
        return nil
    end
    return results
end

local function resolve(id)
    return resolveStack(id)
end

return {
    completion = completion,
    resolve    = resolve,
}
