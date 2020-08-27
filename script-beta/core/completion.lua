local ckind      = require 'define.CompletionItemKind'
local files      = require 'files'
local guide      = require 'parser.guide'
local matchKey   = require 'core.matchKey'
local vm         = require 'vm'
local library    = require 'library'
local getLabel   = require 'core.hover.label'
local getName    = require 'core.hover.name'
local getArg     = require 'core.hover.arg'
local getDesc    = require 'core.hover.description'
local getHover   = require 'core.hover'
local config     = require 'config'
local util       = require 'utility'
local markdown   = require 'provider.markdown'
local findSource = require 'core.find-source'
local await      = require 'await'

local stackID = 0
local resolveID = 0
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
    -- 当进行新的 resolve 时，放弃当前的 resolve
    resolveID = resolveID + 1
    await.setDelayer(function ()
        return resolveID
    end)
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

local function skipSpace(text, offset)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if not isSpace(char) then
            return i
        end
    end
    return 0
end

local function findWord(text, offset)
    for i = offset, 1, -1 do
        if not text:sub(i, i):match '[%w_]' then
            if i == offset then
                return nil
            end
            return text:sub(i+1, offset), i+1
        end
    end
    return text:sub(1, offset), 1
end

local function findSymbol(text, offset)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if isSpace(char) then
            goto CONTINUE
        end
        if char == '.'
        or char == ':'
        or char == '#' then
            return char, i
        else
            return nil
        end
        ::CONTINUE::
    end
    return nil
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
    local args = vm.eachDef(source, function (src)
        if src.type == 'function' then
            local args = getArg(src)
            if args ~= '' then
                return args
            end
        end
    end) or ''
    local id = 0
    args = args:gsub('[^,]+', function (arg)
        id = id + 1
        return arg:gsub('^(%s*)(.+)', function (sp, word)
            return ('%s${%d:%s}'):format(sp, id, word)
        end)
    end)
    return ('%s(%s)'):format(name, args)
end

local function buildDetail(source)
    local types = vm.getInferType(source)
    return types
end

local function buildDesc(source)
    local hover = getHover.get(source)
    local md = markdown()
    md:add('lua', hover.label)
    md:add('md',  hover.description)
    return md:string()
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
        snipData.id  = stack(function ()
            return {
                detail      = buildDetail(source),
                description = buildDesc(source),
            }
        end)
        results[#results+1] = snipData
    end
end

local function isSameSource(source, pos)
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    return source.start <= pos and source.finish >= pos
end

local function checkLocal(ast, word, offset, results)
    local locals = guide.getVisibleLocals(ast.ast, offset)
    for name, source in pairs(locals) do
        if isSameSource(source, offset) then
            goto CONTINUE
        end
        if not matchKey(word, name) then
            goto CONTINUE
        end
        if vm.hasType(source, 'function') then
            buildFunction(results, source, false, {
                label  = name,
                kind   = ckind.Function,
                id     = stack(function ()
                    return {
                        detail      = buildDetail(source),
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
                        detail      = buildDetail(source),
                        description = buildDesc(source),
                    }
                end),
            }
        end
        ::CONTINUE::
    end
end

local function checkFieldThen(src, word, start, parent, oop, results, used)
    local key = vm.getKeyName(src)
    if not key or key:sub(1, 1) ~= 's' then
        return
    end
    if isSameSource(src, start) then
        return
    end
    if used[key] then
        return
    end
    used[key] = true
    local name = key:sub(3)
    if not matchKey(word, name) then
        return
    end
    local value = guide.getObjectValue(src) or src
    local kind = ckind.Field
    if value.type == 'function' then
        if oop then
            kind = ckind.Method
        else
            kind = ckind.Function
        end
        buildFunction(results, src, oop, {
            label = name,
            kind  = kind,
            id    = stack(function ()
                return {
                    detail      = buildDetail(src),
                    description = buildDesc(src),
                }
            end),
        })
        return
    end
    if oop then
        return
    end
    local literal = guide.getLiteral(value)
    if literal ~= nil then
        kind = ckind.Enum
    end
    results[#results+1] = {
        label = name,
        kind  = kind,
        id    = stack(function ()
            return {
                detail      = buildDetail(src),
                description = buildDesc(src),
            }
        end)
    }
end

local function checkField(word, start, parent, oop, results)
    local used = {}
    vm.eachField(parent, function (src)
        checkFieldThen(src, word, start, parent, oop, results, used)
    end)
end

local function checkTableField(ast, word, start, results)
    local source = guide.eachSourceContain(ast.ast, start, function (source)
        if  source.start == start
        and source.parent
        and source.parent.type == 'table' then
            return source
        end
    end)
    if not source then
        return
    end
    local used = {}
    guide.eachSourceType(ast.ast, 'tablefield', function (src)
        if not src.field then
            return
        end
        local key = src.field[1]
        if  not used[key]
        and matchKey(word, key)
        and src ~= source then
            used[key] = true
            results[#results+1] = {
                label = key,
                kind  = ckind.Property,
            }
        end
    end)
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
{'do', function (hasSpace, results)
    if hasSpace then
        results[#results+1] = {
            label = 'do .. end',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[$0 end]],
        }
    else
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[$1 then]],
        }
    else
        results[#results+1] = {
            label = 'elseif .. then',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
${1:key, value} in ${2:pairs(${3:t})} do
    $0
end]]
        }
        results[#results+1] = {
            label = 'for i = ..',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
${1:i} = ${2:1}, ${3:10, 1} do
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'for .. in',
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
for ${1:key, value} in ${2:pairs(${3:t})} do
    $0
end]]
        }
        results[#results+1] = {
            label = 'for i = ..',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
$1($2)
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'function ()',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
$1 then
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'if .. then',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
${1:pairs(${2:t})} do
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'in ..',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
function $1($2)
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'local function',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[$0 until $1]]
        }
    else
        results[#results+1] = {
            label = 'repeat .. until',
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
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
            kind  = ckind.Snippet,
            insertTextFormat = 2,
            insertText = [[
${1:true} do
    $0
end]]
        }
    else
        results[#results+1] = {
            label = 'while .. do',
            kind  = ckind.Snippet,
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

local function checkKeyWord(ast, text, start, word, hasSpace, afterLocal, results)
    local snipType = config.config.completion.keywordSnippet
    for _, data in ipairs(keyWordMap) do
        local key = data[1]
        local eq
        if hasSpace then
            eq = word == key
        else
            eq = matchKey(word, key)
        end
        if afterLocal and key ~= 'function' then
            eq = false
        end
        if eq then
            local replaced
            local extra
            if snipType == 'Both' or snipType == 'Replace' then
                local func = data[2]
                if func then
                    replaced = func(hasSpace, results)
                    extra = true
                end
            end
            if snipType == 'Both' then
                replaced = false
            end
            if not replaced then
                if not hasSpace then
                    local item = {
                        label = key,
                        kind  = ckind.Keyword,
                    }
                    if extra then
                        table.insert(results, #results, item)
                    else
                        results[#results+1] = item
                    end
                end
            end
            local checkStop = data[3]
            if checkStop then
                local stop = checkStop(ast, start)
                if stop then
                    return true
                end
            end
        end
    end
end

local function checkProvideLocal(ast, word, start, results)
    local block
    guide.eachSourceContain(ast.ast, start, function (source)
        if source.type == 'function'
        or source.type == 'main' then
            block = source
        end
    end)
    if not block then
        return
    end
    guide.eachSourceType(block, 'getglobal', function (source)
        if source.start > start
        and matchKey(word, source[1]) then
            results[#results+1] = {
                label = source[1],
                kind  = ckind.Variable,
            }
        end
    end)
end

local function isAfterLocal(text, start)
    local pos = skipSpace(text, start-1)
    local word = findWord(text, pos)
    return word == 'local'
end

local function checkUri(word, text, results)
    
end

local function tryWord(ast, text, offset, results)
    local finish = skipSpace(text, offset)
    local word, start = findWord(text, finish)
    if not word then
        return nil
    end
    local hasSpace = finish ~= offset
    if isInString(ast, offset) then
        if not hasSpace then
            checkUri(word, text, results)
        end
    else
        local parent, oop = findParent(ast, text, start - 1)
        if parent then
            if not hasSpace then
                checkField(word, start, parent, oop, results)
            end
        else
            local afterLocal = isAfterLocal(text, start)
            local stop = checkKeyWord(ast, text, start, word, hasSpace, afterLocal, results)
            if stop then
                return
            end
            if not hasSpace then
                if afterLocal then
                    checkProvideLocal(ast, word, start, results)
                else
                    checkLocal(ast, word, start, results)
                    checkTableField(ast, word, start, results)
                    local env = guide.getLocal(ast.ast, '_ENV', start)
                    checkField(word, start, env, false, results)
                end
            end
        end
        if not hasSpace then
            checkCommon(word, text, results)
        end
    end
end

local function trySymbol(ast, text, offset, results)
    local symbol, start = findSymbol(text, offset)
    if not symbol then
        return nil
    end
    if isInString(ast, offset) then
        return nil
    end
    if symbol == '.'
    or symbol == ':' then
        local parent, oop = findParent(ast, text, start)
        if parent then
            checkField('', start, parent, oop, results)
        end
    end
end

local function tryCallArg(ast, text, offset, results)
    local parent, oop = findParent(ast, text, offset)

end

local function completion(uri, offset)
    local ast = files.getAst(uri)
    local text = files.getText(uri)
    local results = {}
    clearStack()
    vm.setSearchLevel(3)
    if ast then
        tryWord(ast, text, offset, results)
        trySymbol(ast, text, offset, results)
        tryCallArg(ast, text, offset, results)
    else
        local word = findWord(text, offset)
        if word then
            checkCommon(word, text, results)
        end
    end

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
