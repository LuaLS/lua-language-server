local define       = require 'proto.define'
local files        = require 'files'
local matchKey     = require 'core.matchkey'
local vm           = require 'vm'
local getName      = require 'core.hover.name'
local getArgs      = require 'core.hover.args'
local getHover     = require 'core.hover'
local config       = require 'config'
local util         = require 'utility'
local markdown     = require 'provider.markdown'
local parser       = require 'parser'
local keyWordMap   = require 'core.completion.keyword'
local workspace    = require 'workspace'
local furi         = require 'file-uri'
local rpath        = require 'workspace.require-path'
local lang         = require 'language'
local lookBackward = require 'core.look-backward'
local guide        = require 'parser.guide'
local await        = require 'await'
local postfix      = require 'core.completion.postfix'
local diag         = require 'proto.diagnostic'
local wssymbol     = require 'core.workspace-symbol'
local findSource   = require 'core.find-source'
local diagnostic   = require 'provider.diagnostic'
local autoRequire  = require 'core.completion.auto-require'

local diagnosticModes = {
    'disable-next-line',
    'disable-line',
    'disable',
    'enable',
}

local stackID = 0
local stacks = {}

---@param callback async fun(newSource: parser.object): table
local function stack(oldSource, callback)
    stackID = stackID + 1
    local uri = guide.getUri(oldSource)
    local pos = oldSource.start
    local tp  = oldSource.type
    ---@async
    stacks[stackID] = function ()
        local state = files.getState(uri)
        if not state then
            return
        end
        local newSource = findSource(state, pos, { [tp] = true })
        if not newSource then
            return
        end
        return callback(newSource)
    end
    return stackID
end

local function clearStack()
    stacks = {}
end

---@async
local function resolveStack(id)
    local callback = stacks[id]
    if not callback then
        log.warn('Unknown resolved id', id)
        return nil
    end

    return callback()
end

local function trim(str)
    return str:match '^%s*(%S+)%s*$'
end

local function findNearestSource(state, position)
    ---@type parser.object
    local source
    guide.eachSourceContain(state.ast, position, function (src)
        source = src
    end)
    return source
end

local function findNearestTable(state, position)
    local uri  = state.uri
    local text = files.getText(uri)
    if not text then
        return nil
    end
    local offset  = guide.positionToOffset(state, position)
    local soffset = lookBackward.findAnyOffset(text, offset)
    if not soffset then
        return nil
    end
    local symbol = text:sub(soffset, soffset)
    if symbol == '}' then
        return nil
    end
    local sposition = guide.offsetToPosition(state, soffset)
    local source
    guide.eachSourceContain(state.ast, sposition, function (src)
        if src.type == 'table' then
            source = src
        end
    end)

    if not source then
        return nil
    end

    for _, field in ipairs(source) do
        if field.start <= position and (field.range or field.finish) >= position then
            if field.type == 'tableexp' then
                if field.value.type == 'getlocal'
                or field.value.type == 'getglobal' then
                    if field.finish >= position then
                        return source
                    else
                        return nil
                    end
                end
            end
            if field.type == 'tablefield' then
                if field.finish >= position then
                    return source
                else
                    return nil
                end
            end
            if field.type == 'tableindex' then
                if field.index and field.index.type == 'string' then
                    if field.index.finish >= position then
                        return source
                    else
                        return nil
                    end
                end
            end
            return nil
        end
    end

    return source
end

local function findParent(state, position)
    local text = state.lua
    local offset = guide.positionToOffset(state, position)
    for i = offset, 1, -1 do
        local char = text:sub(i, i)
        if lookBackward.isSpace(char) then
            goto CONTINUE
        end
        local oop
        if     char == '.' then
            -- `..` 的情况
            if text:sub(i - 1, i - 1) == '.' then
                return nil, nil
            end
            oop = false
        elseif char == ':' then
            oop = true
        else
            return nil, nil
        end
        local anyOffset = lookBackward.findAnyOffset(text, i - 1)
        if not anyOffset then
            return nil, nil
        end
        local anyPos = guide.offsetToPosition(state, anyOffset)
        local parent = guide.eachSourceContain(state.ast, anyPos, function (source)
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

local function findParentInStringIndex(state, position)
    local near, nearStart
    guide.eachSourceContain(state.ast, position, function (source)
        local start = guide.getStartFinish(source)
        if not start then
            return
        end
        if not nearStart or nearStart < start then
            near = source
            nearStart = start
        end
    end)
    if not near or near.type ~= 'string' then
        return
    end
    local parent = near.parent
    if not parent or parent.index ~= near then
        return
    end
    -- index不可能是oop模式
    return parent.node, false
end

local function buildFunctionSnip(source, value, oop)
    local name = (getName(source) or ''):gsub('^.+[$.:]', '')
    local args = getArgs(value)
    if oop then
        table.remove(args, 1)
    end

    local snipArgs = {}
    for id, arg in ipairs(args) do
        local str, count = arg:gsub('^(%s*)(%.%.%.)(.+)', function (sp, word)
            return ('%s${%d:%s}'):format(sp, id, word)
        end)
        if count == 0 then
            str = arg:gsub('^(%s*)([^:]+)(.+)', function (sp, word)
                return ('%s${%d:%s}'):format(sp, id, word)
            end)
        end
        table.insert(snipArgs, str)
    end
    return ('%s(%s)'):format(name, table.concat(snipArgs, ', '))
end

local function buildDetail(source)
    local types = vm.getInfer(source):view(guide.getUri(source))
    local literals = vm.getInfer(source):viewLiterals()
    if literals then
        return types .. ' = ' .. literals
    else
        return types
    end
end

local function getSnip(source)
    local context = config.get(guide.getUri(source), 'Lua.completion.displayContext')
    if context <= 0 then
        return nil
    end
    local defs = vm.getDefs(source)
    for _, def in ipairs(defs) do
        if def ~= source and def.type == 'function' then
            local uri = guide.getUri(def)
            local text = files.getText(uri)
            local state = files.getState(uri)
            if not state then
                goto CONTINUE
            end
            local lines = state.lines
            if not text then
                goto CONTINUE
            end
            if vm.isMetaFile(uri) then
                goto CONTINUE
            end
            local firstRow   = guide.rowColOf(def.start)
            local lastRow    = math.min(guide.rowColOf(def.finish) + 1, firstRow + context)
            local lastOffset = lines[lastRow] and (lines[lastRow] - 1) or #text
            local snip       = text:sub(lines[firstRow], lastOffset)
            return snip
        end
        ::CONTINUE::
    end
end

---@async
local function buildDesc(source)
    local desc = markdown()
    local hover = getHover.get(source)
    desc:add('md', hover)
    desc:splitLine()
    desc:add('lua', getSnip(source))
    return desc
end

local function buildFunction(results, source, value, oop, data)
    local snipType = config.get(guide.getUri(source), 'Lua.completion.callSnippet')
    if snipType == 'Disable' or snipType == 'Both' then
        results[#results+1] = data
    end
    if snipType == 'Both' or snipType == 'Replace' then
        local snipData = util.deepCopy(data)

        snipData.kind             = snipType == 'Both'
                                    and define.CompletionItemKind.Snippet
                                    or  data.kind
        snipData.insertText       = buildFunctionSnip(source, value, oop)
        snipData.insertTextFormat = 2
        snipData.command          = {
            title = 'trigger signature',
            command = 'editor.action.triggerParameterHints',
        }
        snipData.id               = stack(source, function (newSource) ---@async
            return {
                detail      = buildDetail(newSource),
                description = buildDesc(newSource),
            }
        end)

        results[#results+1] = snipData
    end
end

local function isSameSource(state, source, pos)
    if guide.getUri(source) ~= guide.getUri(state.ast) then
        return false
    end
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    return source.start <= pos and source.finish >= pos
end

local function getParams(func, oop)
    if not func.args then
        return '()'
    end
    local args = {}
    for _, arg in ipairs(func.args) do
        if     arg.type == '...' then
            args[#args+1] = '...'
        elseif arg.type == 'doc.type.arg' then
            args[#args+1] = arg.name[1]
        else
            args[#args+1] = arg[1]
        end
    end
    if oop and args[1] ~= '...' then
        table.remove(args, 1)
    end
    return '(' .. table.concat(args, ', ') .. ')'
end

local function checkLocal(state, word, position, results)
    local locals = guide.getVisibleLocals(state.ast, position)
    for name, source in util.sortPairs(locals) do
        if isSameSource(state, source, position) then
            goto CONTINUE
        end
        if not matchKey(word, name) then
            goto CONTINUE
        end
        if name:sub(1, 1) == '@' then
            goto CONTINUE
        end
        if vm.getInfer(source):hasFunction(state.uri) then
            local defs = vm.getDefs(source)
            -- make sure `function` is before `doc.type.function`
            local orders = {}
            for i, def in ipairs(defs) do
                if def.type == 'function' then
                    orders[def] = i - 20000
                elseif def.type == 'doc.type.function' then
                    orders[def] = i - 10000
                else
                    orders[def] = i
                end
            end
            table.sort(defs, function (a, b)
                return orders[a] < orders[b]
            end)
            for _, def in ipairs(defs) do
                if (def.type == 'function' and not vm.isVarargFunctionWithOverloads(def))
                or def.type == 'doc.type.function' then
                    local funcLabel = name .. getParams(def, false)
                    buildFunction(results, source, def, false, {
                        label      = funcLabel,
                        match      = name,
                        insertText = name,
                        kind       = define.CompletionItemKind.Function,
                        id         = stack(source, function (newSource) ---@async
                            return {
                                detail      = buildDetail(newSource),
                                description = buildDesc(newSource),
                            }
                        end),
                    })
                end
            end
        else
            results[#results+1] = {
                label  = name,
                kind   = define.CompletionItemKind.Variable,
                id     = stack(source, function (newSource) ---@async
                    return {
                        detail      = buildDetail(newSource),
                        description = buildDesc(newSource),
                    }
                end),
            }
        end
        ::CONTINUE::
    end
end

local function checkModule(state, word, position, results)
    if not config.get(state.uri, 'Lua.completion.autoRequire') then
        return
    end
    autoRequire.check(state, word, position, function (uri, stemName, targetSource)
        results[#results+1] = {
            label            = stemName,
            kind             = define.CompletionItemKind.Variable,
            commitCharacters = { '.' },
            command          = {
                title     = 'autoRequire',
                command   = 'lua.autoRequire',
                arguments = {
                    {
                        uri    = guide.getUri(state.ast),
                        target = uri,
                        name   = stemName,
                    },
                },
            },
            id               = stack(targetSource, function (newSource) ---@async
                local md = markdown()
                md:add('md', lang.script('COMPLETION_IMPORT_FROM', ('[%s](%s)'):format(
                    workspace.getRelativePath(uri),
                    uri
                )))
                md:add('md', buildDesc(newSource))
                return {
                    detail      = buildDetail(newSource),
                    description = md,
                    --additionalTextEdits = buildInsertRequire(state, originUri, stemName),
                }
            end)
        }
    end)
end

local function checkFieldFromFieldToIndex(state, name, src, parent, word, startPos, position)
    if name:match(guide.namePatternFull) then
        if not name:match '[\x80-\xff]'
        or config.get(state.uri, 'Lua.runtime.unicodeName') then
            return nil
        end
        name = ('%q'):format(name)
    end
    local textEdit, additionalTextEdits
    local startOffset = guide.positionToOffset(state, startPos)
    local offset      = guide.positionToOffset(state, position)
    local wordStartOffset
    if word == '' then
        wordStartOffset = state.lua:match('()%S', startOffset + 1)
        if wordStartOffset then
            wordStartOffset = wordStartOffset - 1
        else
            wordStartOffset = offset
        end
    else
        wordStartOffset = offset - #word
    end
    local wordStartPos = guide.offsetToPosition(state, wordStartOffset)
    local newText = ('[%s]'):format(name)
    textEdit = {
        start   = wordStartPos,
        finish  = position,
        newText = newText,
    }
    local nxt = parent.next
    if nxt then
        local dotStart, dotFinish
        if     nxt.type == 'setfield'
        or     nxt.type == 'getfield'
        or     nxt.type == 'tablefield' then
            dotStart = nxt.dot.start
            dotFinish = nxt.dot.finish
        elseif nxt.type == 'setmethod'
        or     nxt.type == 'getmethod' then
            dotStart = nxt.colon.start
            dotFinish = nxt.colon.finish
        end
        if dotStart then
            additionalTextEdits = {
                {
                    start   = dotStart,
                    finish  = dotFinish,
                    newText = '',
                }
            }
        end
    else
        if config.get(state.uri, 'Lua.runtime.version') == 'Lua 5.1'
        or config.get(state.uri, 'Lua.runtime.version') == 'LuaJIT' then
            textEdit.newText = '_G' .. textEdit.newText
        else
            textEdit.newText = '_ENV' .. textEdit.newText
        end
    end
    return textEdit, additionalTextEdits
end

local function checkFieldThen(state, name, src, word, startPos, position, parent, oop, results)
    local value = vm.getObjectFunctionValue(src) or src
    local kind = define.CompletionItemKind.Field
    if (value.type == 'function' and not vm.isVarargFunctionWithOverloads(value))
    or value.type == 'doc.type.function' then
        local isMethod = value.parent.type == 'setmethod'
        if isMethod then
            kind = define.CompletionItemKind.Method
        else
            kind = define.CompletionItemKind.Function
        end
        buildFunction(results, src, value, oop, {
            label      = name,
            kind       = kind,
            isMethod   = isMethod,
            match      = name:match '^[^(]+',
            insertText = name:match '^[^(]+',
            deprecated = vm.getDeprecated(src) and true or nil,
            id         = stack(src, function (newSrc) ---@async
                return {
                    detail      = buildDetail(newSrc),
                    description = buildDesc(newSrc),
                }
            end),
        })
        return
    end
    if oop and not vm.getInfer(src):hasFunction(state.uri) then
        return
    end
    local literal = guide.getLiteral(value)
    if literal ~= nil then
        kind = define.CompletionItemKind.Enum
    end
    local textEdit, additionalTextEdits
    if parent.next and parent.next.index then
        local str = parent.next.index
        textEdit = {
            start   = str.start + #str[2],
            finish  = position,
            newText = name:sub(#str[2] + 1, - #str[2] - 1),
        }
    else
        textEdit, additionalTextEdits = checkFieldFromFieldToIndex(state, name, src, parent, word, startPos, position)
    end
    results[#results+1] = {
        label      = name,
        kind       = kind,
        deprecated = vm.getDeprecated(src) and true or nil,
        textEdit   = textEdit,
        id         = stack(src, function (newSrc) ---@async
            return {
                detail      = buildDetail(newSrc),
                description = buildDesc(newSrc),
            }
        end),

        additionalTextEdits = additionalTextEdits,
    }
end

---@async
local function checkFieldOfRefs(refs, state, word, startPos, position, parent, oop, results, locals, isGlobal)
    local fields = {}
    local funcs  = {}
    local count  = 0
    for _, src in ipairs(refs) do
        if count > 100 then
            results.incomplete = true
            break
        end
        local _, name = vm.viewKey(src, state.uri)
        if not name then
            goto CONTINUE
        end
        if isSameSource(state, src, startPos) then
            goto CONTINUE
        end
        name = tostring(name)
        if isGlobal and locals and locals[name] then
            goto CONTINUE
        end
        if not matchKey(word, name:gsub([=[^['"]]=], ''), count >= 100) then
            goto CONTINUE
        end
        if not vm.isVisible(parent, src) then
            goto CONTINUE
        end
        local funcLabel
        if config.get(state.uri, 'Lua.completion.showParams') then
            --- TODO determine if getlocal should be a function here too
            local value = vm.getObjectFunctionValue(src) or src
            if value.type == 'function'
            or value.type == 'doc.type.function' then
                if not vm.isVarargFunctionWithOverloads(value) then
                    funcLabel = name .. getParams(value, oop)
                    fields[funcLabel] = src
                    count = count + 1
                end
                if value.type == 'function' and value.bindDocs then
                    for _, doc in ipairs(value.bindDocs) do
                        if doc.type == 'doc.overload' then
                            funcLabel = name .. getParams(doc.overload, oop)
                            fields[funcLabel] = doc.overload
                        end
                    end
                end
                funcs[name] = true
                if fields[name] and not guide.isAssign(fields[name]) then
                    fields[name] = nil
                end
                goto CONTINUE
            end
        end
        local last = fields[name]
        if last == nil and not funcs[name] then
            fields[name] = src
            count = count + 1
            goto CONTINUE
        end
        if vm.getDeprecated(src) then
            goto CONTINUE
        end
        if guide.isAssign(src) then
            fields[name] = src
            goto CONTINUE
        end
        ::CONTINUE::
    end

    local fieldResults = {}
    for name, src in util.sortPairs(fields) do
        if src then
            checkFieldThen(state, name, src, word, startPos, position, parent, oop, fieldResults)
            await.delay()
        end
    end

    local scoreMap = {}
    for i, res in ipairs(fieldResults) do
        scoreMap[res] = i
    end
    table.sort(fieldResults, function (a, b)
        local score1 = scoreMap[a]
        local score2 = scoreMap[b]
        if oop then
            if not a.isMethod then
                score1 = score1 + 10000
            end
            if not b.isMethod then
                score2 = score2 + 10000
            end
        else
            if a.isMethod then
                score1 = score1 + 10000
            end
            if b.isMethod then
                score2 = score2 + 10000
            end
        end
        return score1 < score2
    end)

    for _, res in ipairs(fieldResults) do
        results[#results+1] = res
    end
end

---@async
local function checkGlobal(state, word, startPos, position, parent, oop, results)
    local locals = guide.getVisibleLocals(state.ast, position)
    local globals = vm.getGlobalSets(state.uri, 'variable')
    checkFieldOfRefs(globals, state, word, startPos, position, parent, oop, results, locals, 'global')
end

---@async
local function checkField(state, word, start, position, parent, oop, results)
    if parent.tag == '_ENV' or parent.special == '_G' then
        local globals = vm.getGlobalSets(state.uri, 'variable')
        checkFieldOfRefs(globals, state, word, start, position, parent, oop, results)
    else
        local refs = vm.getFields(parent)
        checkFieldOfRefs(refs, state, word, start, position, parent, oop, results)
    end
end

local function checkTableField(state, word, start, results)
    local source = guide.eachSourceContain(state.ast, start, function (source)
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
    guide.eachSourceType(state.ast, 'tablefield', function (src)
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
                kind  = define.CompletionItemKind.Property,
            }
        end
    end)
end

local function checkCommon(state, word, position, results)
    local myUri = state.uri
    local showWord = config.get(state.uri, 'Lua.completion.showWord')
    if showWord == 'Disable' then
        return
    end
    results.enableCommon = true
    if showWord == 'Fallback' and #results ~= 0 then
        return
    end
    local used = {}
    for _, result in ipairs(results) do
        used[result.label:match '^[^(]*'] = true
    end
    for _, data in ipairs(keyWordMap) do
        used[data[1]] = true
    end
    if config.get(state.uri, 'Lua.completion.workspaceWord') and #word >= 2 then
        local myHead = word:sub(1, 2)
        for uri in files.eachFile(state.uri) do
            if #results >= 100 then
                results.incomplete = true
                break
            end
            if myUri == uri then
                goto CONTINUE
            end
            local words = files.getWordsOfHead(uri, myHead)
            if not words then
                goto CONTINUE
            end
            for _, str in ipairs(words) do
                if #results >= 100 then
                    break
                end
                if  not used[str]
                and str ~= word then
                    used[str] = true
                    if matchKey(word, str) then
                        results[#results+1] = {
                            label = str,
                            kind  = define.CompletionItemKind.Text,
                        }
                    end
                end
            end
            ::CONTINUE::
        end
        for uri in files.eachDll() do
            if #results >= 100 then
                break
            end
            local words = files.getDllWords(uri) or {}
            for _, str in ipairs(words) do
                if #results >= 100 then
                    break
                end
                if #str >= 3 and not used[str] and str ~= word then
                    used[str] = true
                    if matchKey(word, str) then
                        results[#results+1] = {
                            label = str,
                            kind  = define.CompletionItemKind.Text,
                        }
                    end
                end
            end
        end
    end
    for str, offset in state.lua:gmatch('(' .. guide.namePattern .. ')()') do
        if #results >= 100 then
            results.incomplete = true
            break
        end
        if  #str >= 3
        and not used[str]
        and guide.offsetToPosition(state, offset - 1) ~= position then
            used[str] = true
            if matchKey(word, str) then
                results[#results+1] = {
                    label = str,
                    kind  = define.CompletionItemKind.Text,
                }
            end
        end
    end
end

local function checkKeyWord(state, start, position, word, hasSpace, afterLocal, results)
    local text = state.lua
    local snipType = config.get(state.uri, 'Lua.completion.keywordSnippet')
    local symbol = lookBackward.findSymbol(text, guide.positionToOffset(state, start))
    local isExp = symbol == '(' or symbol == ',' or symbol == '=' or symbol == '[' or symbol == '{'
    local info = {
        hasSpace = hasSpace,
        isExp    = isExp,
        text     = text,
        start    = start,
        uri      = guide.getUri(state.ast),
        position = position,
        state    = state,
    }
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
        if not eq then
            goto CONTINUE
        end
        if isExp then
            if  key ~= 'nil'
            and key ~= 'true'
            and key ~= 'false'
            and key ~= 'function' then
                goto CONTINUE
            end
        end
        local replaced
        local extra
        if snipType == 'Both' or snipType == 'Replace' then
            local func = data[2]
            if func then
                replaced = func(info, results)
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
                    kind  = define.CompletionItemKind.Keyword,
                }
                if #results > 0 and extra then
                    table.insert(results, #results, item)
                else
                    results[#results+1] = item
                end
            end
        end
        local checkStop = data[3]
        if checkStop then
            local stop = checkStop(info)
            if stop then
                return true
            end
        end
        ::CONTINUE::
    end
end

local function checkProvideLocal(state, word, start, results)
    local block
    guide.eachSourceContain(state.ast, start, function (source)
        if source.type == 'function'
        or source.type == 'main' then
            block = source
        end
    end)
    if not block then
        return
    end
    local used = {}
    guide.eachSourceType(block, 'getglobal', function (source)
        if source.start > start
        and not used[source[1]]
        and matchKey(word, source[1]) then
            used[source[1]] = true
            results[#results+1] = {
                label = source[1],
                kind  = define.CompletionItemKind.Variable,
            }
        end
    end)
    guide.eachSourceType(block, 'getlocal', function (source)
        if source.start > start
        and not used[source[1]]
        and matchKey(word, source[1]) then
            used[source[1]] = true
            results[#results+1] = {
                label = source[1],
                kind  = define.CompletionItemKind.Variable,
            }
        end
    end)
end

local function checkFunctionArgByDocParam(state, word, startPos, results)
    local func = guide.eachSourceContain(state.ast, startPos, function (source)
        if source.type == 'function' then
            return source
        end
    end)
    if not func then
        return
    end
    local docs = func.bindDocs
    if not docs then
        return
    end
    local params = {}
    for _, doc in ipairs(docs) do
        if doc.type == 'doc.param' then
            params[#params+1] = doc
        end
    end
    local firstArg = func.args and func.args[1]
    if not firstArg
    or firstArg.start <= startPos and firstArg.finish >= startPos then
        local firstParam = params[1]
        if firstParam and matchKey(word, firstParam.param[1]) then
            local label = {}
            for _, param in ipairs(params) do
                label[#label+1] = param.param[1]
            end
            results[#results+1] = {
                label = table.concat(label, ', '),
                match = firstParam.param[1],
                kind  = define.CompletionItemKind.Snippet,
            }
        end
    end
    for _, doc in ipairs(params) do
        if matchKey(word, doc.param[1]) then
            results[#results+1] = {
                label = doc.param[1],
                kind  = define.CompletionItemKind.Interface,
            }
        end
    end
end

local function isAfterLocal(state, startPos)
    local text   = state.lua
    local offset = guide.positionToOffset(state, startPos)
    local pos    = lookBackward.skipSpace(text, offset)
    local word   = lookBackward.findWord(text, pos)
    return word == 'local'
end

local function collectRequireNames(mode, myUri, literal, source, smark, position, results)
    local collect = {}
    if mode == 'require' then
        for uri in files.eachFile(myUri) do
            if myUri == uri then
                goto CONTINUE
            end
            local path = furi.decode(uri)
            local infos = rpath.getVisiblePath(myUri, path)
            local relative = workspace.getRelativePath(path)
            for _, info in ipairs(infos) do
                if matchKey(literal, info.name) then
                    if not collect[info.name] then
                        collect[info.name] = {
                            textEdit = {
                                start   = smark and (source.start + #smark) or position,
                                finish  = smark and (source.finish - #smark) or position,
                                newText = smark and info.name or util.viewString(info.name),
                            },
                            path = relative,
                        }
                    end
                    if vm.isMetaFile(uri) then
                        collect[info.name][#collect[info.name]+1] = ('* [[meta]](%s)'):format(uri)
                    else
                        collect[info.name][#collect[info.name]+1] = ([=[* [%s](%s) %s]=]):format(
                            relative,
                            uri,
                            lang.script('HOVER_USE_LUA_PATH', info.searcher)
                        )
                    end
                end
            end
            ::CONTINUE::
        end
        for uri in files.eachDll() do
            local opens = files.getDllOpens(uri) or {}
            local path = workspace.getRelativePath(uri)
            for _, open in ipairs(opens) do
                if matchKey(literal, open) then
                    if not collect[open] then
                        collect[open] = {
                            textEdit = {
                                start   = smark and (source.start + #smark) or position,
                                finish  = smark and (source.finish - #smark) or position,
                                newText = smark and open or util.viewString(open),
                            },
                            path = path,
                        }
                    end
                    collect[open][#collect[open]+1] = ([=[* [%s](%s)]=]):format(
                        path,
                        uri
                    )
                end
            end
        end
    else
        for uri in files.eachFile(myUri) do
            if myUri == uri then
                goto CONTINUE
            end
            if vm.isMetaFile(uri) then
                goto CONTINUE
            end
            local path = workspace.getRelativePath(uri)
            path = path:gsub('\\', '/')
            if matchKey(literal, path) then
                if not collect[path] then
                    collect[path] = {
                        textEdit = {
                            start   = smark and (source.start + #smark) or position,
                            finish  = smark and (source.finish - #smark) or position,
                            newText = smark and path or util.viewString(path),
                        }
                    }
                end
                collect[path][#collect[path]+1] = ([=[[%s](%s)]=]):format(
                    path,
                    uri
                )
            end
            ::CONTINUE::
        end
    end
    for label, infos in util.sortPairs(collect) do
        local mark = {}
        local des  = {}
        for _, info in ipairs(infos) do
            if not mark[info] then
                mark[info] = true
                des[#des+1] = info
            end
        end
        results[#results+1] = {
            label       = label,
            detail      = infos.path,
            kind        = define.CompletionItemKind.File,
            description = table.concat(des, '\n'),
            textEdit    = infos.textEdit,
        }
    end
end

local function checkUri(state, position, results)
    local myUri = guide.getUri(state.ast)
    guide.eachSourceContain(state.ast, position, function (source)
        if source.type ~= 'string' then
            return
        end
        local callargs = source.parent
        if not callargs or callargs.type ~= 'callargs' then
            return
        end
        if callargs[1] ~= source then
            return
        end
        local call = callargs.parent
        local func = call.node
        local literal = guide.getLiteral(source)
        local libName = vm.getLibraryName(func)
        if not libName then
            return
        end
        if libName == 'require'
        or libName == 'dofile'
        or libName == 'loadfile' then
            collectRequireNames(libName, myUri, literal, source, source[2], position, results)
        end
    end)
end

local function checkLenPlusOne(state, position, results)
    local text = state.lua
    guide.eachSourceContain(state.ast, position, function (source)
        if source.type == 'getindex'
        or source.type == 'setindex' then
            local finish = guide.positionToOffset(state, source.node.finish)
            local _, offset = text:find('%s*%[%s*%#', finish)
            if not offset then
                return
            end
            local start = guide.positionToOffset(state, source.node.start) + 1
            local nodeText = text:sub(start, finish)
            local writingText = trim(text:sub(offset + 1, guide.positionToOffset(state, position))) or ''
            if not matchKey(writingText, nodeText) then
                return
            end
            local offsetPos = guide.offsetToPosition(state, offset) - 1
            if source.parent == guide.getParentBlock(source) then
                local sourceFinish = guide.positionToOffset(state, source.finish)
                -- state
                local label = text:match('%#[ \t]*', offset) .. nodeText .. '+1'
                local eq = text:find('^%s*%]?%s*%=', sourceFinish)
                local newText = label .. ']'
                if not eq then
                    newText = newText .. ' = '
                end
                results[#results+1] = {
                    label    = label,
                    match    = nodeText,
                    kind     = define.CompletionItemKind.Snippet,
                    textEdit = {
                        start   = offsetPos,
                        finish  = source.finish,
                        newText = newText,
                    },
                }
            else
                -- exp
                local label = text:match('%#[ \t]*', offset) .. nodeText
                local newText = label .. ']'
                results[#results+1] = {
                    label    = label,
                    kind     = define.CompletionItemKind.Snippet,
                    textEdit = {
                        start   = offsetPos,
                        finish  = source.finish,
                        newText = newText,
                    },
                }
            end
        end
    end)
end

local function tryLabelInString(label, source)
    if not source or source.type ~= 'string' then
        return label
    end
    local state = parser.compile(label, 'String')
    if not state or not state.ast then
        return label
    end
    if not matchKey(source[1], state.ast[1]--[[@as string]]) then
        return nil
    end
    return util.viewString(state.ast[1], source[2])
end

local function cleanEnums(enums, source)
    for i = #enums, 1, -1 do
        local enum = enums[i]
        local label = tryLabelInString(enum.label, source)
        if label then
            enum.label    = label
            enum.textEdit = source and {
                start   = source.start,
                finish  = source.finish,
                newText = enum.insertText or label,
            }
        end
    end
    return enums
end

---@param state     parser.state
---@param pos       integer
---@param doc       vm.node.object
---@param enums     table[]
---@return table[]?
local function insertDocEnum(state, pos, doc, enums)
    local tbl = doc.bindSource
    if not tbl then
        return nil
    end
    local parent = tbl.parent
    local parentName
    if vm.getGlobalNode(parent) then
        parentName = vm.getGlobalNode(parent):getCodeName()
    else
        local locals = guide.getVisibleLocals(state.ast, pos)
        for _, loc in pairs(locals) do
            if util.arrayHas(vm.getDefs(loc), tbl) then
                parentName = loc[1]
                break
            end
        end
    end
    local valueEnums = {}
    for _, field in ipairs(tbl) do
        if field.type == 'tablefield'
        or field.type == 'tableindex' then
            if not field.value then
                goto CONTINUE
            end
            local key = guide.getKeyName(field)
            if not key then
                goto CONTINUE
            end
            if parentName then
                enums[#enums+1] = {
                    label  = parentName .. '.' .. key,
                    kind   = define.CompletionItemKind.EnumMember,
                    id     = stack(field, function (newField) ---@async
                        return {
                            detail      = buildDetail(newField),
                            description = buildDesc(newField),
                        }
                    end),
                }
            end
            for nd in vm.compileNode(field.value):eachObject() do
                if nd.type == 'boolean'
                or nd.type == 'number'
                or nd.type == 'integer'
                or nd.type == 'string' then
                    valueEnums[#valueEnums+1] = {
                        label  = util.viewLiteral(nd[1]),
                        kind   = define.CompletionItemKind.EnumMember,
                        id     = stack(field, function (newField) ---@async
                            return {
                                detail      = buildDetail(newField),
                                description = buildDesc(newField),
                            }
                        end),
                    }
                end
            end
            ::CONTINUE::
        end
    end
    for _, enum in ipairs(valueEnums) do
        enums[#enums+1] = enum
    end
    return enums
end

---@param state     parser.state
---@param pos       integer
---@param doc       vm.node.object
---@param enums     table[]
---@return table[]?
local function insertDocEnumKey(state, pos, doc, enums)
    local tbl = doc.bindSource
    if not tbl then
        return nil
    end
    local keyEnums = {}
    for _, field in ipairs(tbl) do
        if field.type == 'tablefield'
        or field.type == 'tableindex' then
            if not field.value then
                goto CONTINUE
            end
            local key = guide.getKeyName(field)
            if not key then
                goto CONTINUE
            end
            enums[#enums+1] = {
                label  = ('%q'):format(key),
                kind   = define.CompletionItemKind.EnumMember,
                id     = stack(field, function (newField) ---@async
                    return {
                        detail      = buildDetail(newField),
                        description = buildDesc(newField),
                    }
                end),
            }
            ::CONTINUE::
        end
    end
    for _, enum in ipairs(keyEnums) do
        enums[#enums+1] = enum
    end
    return enums
end

local function buildInsertDocFunction(doc)
    local args = {}
    for i, arg in ipairs(doc.args) do
        args[i] = ('${%d:%s}'):format(i, arg.name[1])
    end
    return ("\z
function (%s)\
\t$0\
end"):format(table.concat(args, ', '))
end

---@param state     parser.state
---@param pos       integer
---@param src       vm.node.object
---@param enums     table[]
---@param isInArray boolean?
---@param mark      table?
local function insertEnum(state, pos, src, enums, isInArray, mark)
    mark = mark or {}
    if mark[src] then
        return
    end
    mark[src] = true
    if src.type == 'doc.type.string'
    or src.type == 'doc.type.integer'
    or src.type == 'doc.type.boolean' then
        ---@cast src parser.object
        enums[#enums+1] = {
            label       = vm.getInfer(src):view(state.uri),
            description = src.comment,
            kind        = define.CompletionItemKind.EnumMember,
        }
    elseif src.type == 'doc.type.code' then
        enums[#enums+1] = {
            label       = src[1],
            description = src.comment,
            kind        = define.CompletionItemKind.EnumMember,
        }
    elseif src.type == 'doc.type.function' then
        ---@cast src parser.object
        local insertText = buildInsertDocFunction(src)
        local description
        if src.comment then
            description = src.comment
        else
            local descText = insertText:gsub('%$%{%d+:([^}]+)%}', function (val)
                return val
            end):gsub('%$%{?%d+%}?', '')
            description = markdown()
                : add('lua', descText)
                : string()
        end
        enums[#enums+1] = {
            label       = vm.getInfer(src):view(state.uri),
            description = description,
            kind        = define.CompletionItemKind.Function,
            insertText  = insertText,
        }
    elseif isInArray and src.type == 'doc.type.array' then
        for i, d in ipairs(vm.getDefs(src.node)) do
            insertEnum(state, pos, d, enums, isInArray, mark)
        end
    elseif src.type == 'global' and src.cate == 'type' then
        for _, set in ipairs(src:getSets(state.uri)) do
            if set.type == 'doc.enum' then
                if vm.docHasAttr(set, 'key') then
                    insertDocEnumKey(state, pos, set, enums)
                else
                    insertDocEnum(state, pos, set, enums)
                end
            end
        end
    end
end

local function checkTypingEnum(state, position, defs, str, results, isInArray)
    local enums = {}
    for _, def in ipairs(defs) do
        insertEnum(state, position, def, enums, isInArray)
    end
    cleanEnums(enums, str)
    for _, res in ipairs(enums) do
        results[#results+1] = res
    end
end

local function checkEqualEnumLeft(state, position, source, results, isInArray)
    if not source then
        return
    end
    local str = guide.eachSourceContain(state.ast, position, function (src)
        if src.type == 'string' then
            return src
        end
    end)
    local defs = vm.getDefs(source)
    checkTypingEnum(state, position, defs, str, results, isInArray)
end

local function checkEqualEnum(state, position, results)
    local text  = state.lua
    local start = lookBackward.findTargetSymbol(text, guide.positionToOffset(state, position), '=')
    if not start then
        return
    end
    local eqOrNeq
    if text:sub(start - 1, start - 1) == '='
    or text:sub(start - 1, start - 1) == '~' then
        start = start - 1
        eqOrNeq = true
    end
    start = lookBackward.skipSpace(text, start - 1)
    local source = findNearestSource(state, guide.offsetToPosition(state, start))
    if not source then
        return
    end
    if source.type == 'callargs' then
        source = source.parent
    end
    if source.type == 'call' and not eqOrNeq then
        return
    end
    checkEqualEnumLeft(state, position, source, results)
end

local function checkEqualEnumInString(state, position, results)
    local source = findNearestSource(state, position)
    local parent = source.parent
    if parent.type == 'binary' then
        if source ~= parent[2] then
            return
        end
        if not parent.op then
            return
        end
        if parent.op.type ~= '==' and parent.op.type ~= '~=' then
            return
        end
        checkEqualEnumLeft(state, position, parent[1], results)
    end
    if (parent.type == 'tableexp') then
        checkEqualEnumLeft(state, position, parent.parent.parent, results, true)
        return
    end
    if parent.type == 'local' then
        checkEqualEnumLeft(state, position, parent, results)
    end

    if parent.type == 'setlocal'
    or parent.type == 'setglobal'
    or parent.type == 'setfield'
    or parent.type == 'setindex' then
        checkEqualEnumLeft(state, position, parent.node, results)
    end
    if parent.type == 'tablefield'
    or parent.type == 'tableindex' then
        checkEqualEnumLeft(state, position, parent, results)
    end
end

local function isFuncArg(state, position)
    return guide.eachSourceContain(state.ast, position, function (source)
        if source.type == 'funcargs' then
            return true
        end
    end)
end

local function trySpecial(state, position, results)
    if guide.isInString(state.ast, position) then
        checkUri(state, position, results)
        checkEqualEnumInString(state, position, results)
        return
    end
    -- x[#x+1]
    checkLenPlusOne(state, position, results)
    -- type(o) ==
    checkEqualEnum(state, position, results)
end

---@async
local function tryIndex(state, position, results)
    local parent, oop = findParentInStringIndex(state, position)
    if not parent then
        return
    end
    local word = parent.next and parent.next.index and parent.next.index[1]
    if not word then
        return
    end
    checkField(state, word, position, position, parent, oop, results)
end

---@async
local function tryWord(state, position, triggerCharacter, results)
    if triggerCharacter == '('
    or triggerCharacter == '#'
    or triggerCharacter == ','
    or triggerCharacter == '{' then
        return
    end
    local text = state.lua
    local offset = guide.positionToOffset(state, position)
    local finish = lookBackward.skipSpace(text, offset)
    local word, start = lookBackward.findWord(text, offset)
    local startPos
    if not word then
        word = ''
        startPos = position
    else
        startPos = guide.offsetToPosition(state, start - 1)
    end
    local hasSpace = triggerCharacter ~= nil and finish ~= offset
    if guide.isInString(state.ast, position) then
        if not hasSpace then
            if #results == 0 then
                checkCommon(state, word, position, results)
            end
        end
    else
        local parent, oop = findParent(state, startPos)
        if     parent then
            checkField(state, word, startPos, position, parent, oop, results)
        elseif isFuncArg(state, position) then
            checkProvideLocal(state, word, startPos, results)
            checkFunctionArgByDocParam(state, word, startPos, results)
        else
            local afterLocal = isAfterLocal(state, startPos)
            local stop = checkKeyWord(state, startPos, position, word, hasSpace, afterLocal, results)
            if stop then
                return
            end
            if not hasSpace then
                if afterLocal then
                    checkProvideLocal(state, word, startPos, results)
                else
                    checkLocal(state, word, startPos, results)
                    checkTableField(state, word, startPos, results)
                    local env = guide.getENV(state.ast, startPos)
                    checkGlobal(state, word, startPos, position, env, false, results)
                    checkModule(state, word, startPos, results)
                end
            end
        end
        if not hasSpace and (#results == 0 or word ~= '') then
            checkCommon(state, word, position, results)
        end
    end
end

---@async
local function trySymbol(state, position, results)
    local text = state.lua
    local symbol, start = lookBackward.findSymbol(text, guide.positionToOffset(state, position))
    if not symbol then
        return nil
    end
    if guide.isInString(state.ast, position) then
        return nil
    end
    local startPos = guide.offsetToPosition(state, start)
    --if symbol == '.'
    --or symbol == ':' then
    --    local parent, oop = findParent(state, startPos)
    --    if parent then
    --        tracy.ZoneBeginN 'completion.trySymbol'
    --        checkField(state, '', startPos, position, parent, oop, results)
    --        tracy.ZoneEnd()
    --    end
    --end
    if symbol == '(' then
        checkFunctionArgByDocParam(state, '', startPos, results)
    end
end

local function findCall(state, position)
    local call
    guide.eachSourceContain(state.ast, position, function (src)
        if src.type == 'call' then
            if not call or call.start < src.start then
                call = src
            end
        end
    end)
    return call
end

local function getCallArgInfo(call, position)
    if not call.args then
        return 1, nil
    end
    for index, arg in ipairs(call.args) do
        if arg.start <= position and arg.finish >= position then
            return index, arg
        end
    end
    return #call.args + 1, nil
end

local function checkTableLiteralField(state, position, tbl, fields, results)
    local text = state.lua
    local mark = {}
    for _, field in ipairs(tbl) do
        if field.type == 'tablefield'
        or field.type == 'tableindex'
        or field.type == 'tableexp' then
            local name = guide.getKeyName(field)
            if name then
                mark[name] = true
            end
        end
    end
    table.sort(fields, function (a, b)
        return tostring(guide.getKeyName(a)) < tostring(guide.getKeyName(b))
    end)
    -- {$}
    local left = lookBackward.findWord(text, guide.positionToOffset(state, position))
    if not left then
        local pos = lookBackward.findAnyOffset(text, guide.positionToOffset(state, position))
        local char = text:sub(pos, pos)
        if char == '{' or char == ',' or char == ';' then
            left = ''
        end
    end
    if left then
        local fieldResults = {}
        for _, field in ipairs(fields) do
            local name = guide.getKeyName(field)
            if  name
            and not mark[name]
            and matchKey(left, tostring(name)) then
                local res = {
                    label      = guide.getKeyName(field),
                    kind       = define.CompletionItemKind.Property,
                    id         = stack(field, function (newField) ---@async
                        return {
                            detail      = buildDetail(newField),
                            description = buildDesc(newField),
                        }
                    end),
                }
                if field.optional
                or vm.compileNode(field):isNullable() then
                    res.insertText = res.label
                    res.label      = res.label.. '?'
                end
                fieldResults[#fieldResults+1] = res
            end
        end
        util.sortByScore(fieldResults, {
            function (r) return r.insertText and 0 or 1 end,
            util.sortCallbackOfIndex(fieldResults),
        })
        util.arrayMerge(results, fieldResults)
        return #fieldResults > 0
    end
end

local function tryCallArg(state, position, results)
    local call = findCall(state, position)
    if not call then
        return
    end
    local argIndex, arg = getCallArgInfo(call, position)
    if arg and arg.type == 'function' then
        return
    end
    ---@diagnostic disable-next-line: missing-fields
    local node = vm.compileCallArg({ type = 'dummyarg', uri = state.uri }, call, argIndex)
    if not node then
        return
    end

    local enums = {}
    for src in node:eachObject() do
        insertEnum(state, position, src, enums, arg and arg.type == 'table')
    end
    cleanEnums(enums, arg)
    for _, enum in ipairs(enums) do
        results[#results+1] = enum
    end
end

local function tryTable(state, position, results)
    local tbl = findNearestTable(state, position)
    if not tbl then
        return false
    end
    if  tbl.type ~= 'table' then
        return
    end
    local mark = {}
    local fields = {}

    local defs = vm.getFields(tbl)
    for _, field in ipairs(defs) do
        local name = guide.getKeyName(field)
        if name and not mark[name] then
            mark[name] = true
            fields[#fields+1] = field
        end
    end
    if checkTableLiteralField(state, position, tbl, fields, results) then
        return true
    end
    return false
end

local function tryArray(state, position, results)
    local source = findNearestSource(state, position)
    if not source then
        return
    end
    if source.type ~= 'table' and (not source.parent or source.parent.type ~= 'table') then
        return
    end
    local tbl = source
    if source.type ~= 'table' then
        tbl = source.parent
    end
    if source.parent.type == 'callargs' and source.parent.parent.type == 'call' then
        return
    end
    -- {  } inside when enum
    checkEqualEnumLeft(state, position, tbl, results, true)
end

local function getComment(state, position)
    local offset = guide.positionToOffset(state, position)
    local symbolOffset = lookBackward.findAnyOffset(state.lua, offset, true)
    if not symbolOffset then
        return
    end
    local symbolPosition = guide.offsetToPosition(state, symbolOffset)
    for _, comm in ipairs(state.comms) do
        if symbolPosition > comm.start and symbolPosition <= comm.finish then
            return comm
        end
    end
    return nil
end

local function getLuaDoc(state, position)
    local offset = guide.positionToOffset(state, position)
    local symbolOffset = lookBackward.findAnyOffset(state.lua, offset, true)
    if not symbolOffset then
        return
    end
    local symbolPosition = guide.offsetToPosition(state, symbolOffset)
    for _, doc in ipairs(state.ast.docs) do
        if symbolPosition >= doc.start and symbolPosition <= doc.range then
            return doc
        end
    end
    return nil
end

local function tryluaDocCate(word, results)
    for _, docType in ipairs {
        'class',
        'type',
        'alias',
        'param',
        'return',
        'field',
        'generic',
        'vararg',
        'overload',
        'deprecated',
        'meta',
        'version',
        'see',
        'diagnostic',
        'module',
        'async',
        'nodiscard',
        'cast',
        'operator',
        'source',
        'enum',
        'package',
        'private',
        'protected'
    } do
        if matchKey(word, docType) then
            results[#results+1] = {
                label       = docType,
                kind        = define.CompletionItemKind.Event,
                description = lang.script('LUADOC_DESC_' .. docType:upper())
            }
        end
    end
end

local function getluaDocByContain(state, position)
    local result
    local range = math.huge
    guide.eachSourceContain(state.ast.docs, position, function (src)
        if not src.start then
            return
        end
        if  range >= position - src.start
        and position <= src.finish then
            range = position - src.start
            result = src
        end
    end)
    return result
end

local function getluaDocByErr(state, start, position)
    local targetError
    for _, err in ipairs(state.errs) do
        if  err.finish <= position
        and err.start >= start  then
            if not state.lua:sub(err.finish + 1, position):find '%S' then
                targetError = err
                break
            end
        end
    end
    if not targetError then
        return nil
    end
    local targetDoc
    for i = #state.ast.docs, 1, -1 do
        local doc = state.ast.docs[i]
        if doc.finish <= targetError.start then
            targetDoc = doc
            break
        end
    end
    return targetError, targetDoc
end

---@async
local function tryluaDocBySource(state, position, source, results)
    if     source.type == 'doc.extends.name' then
        if source.parent.type == 'doc.class' then
            local used = {}
            for _, doc in ipairs(vm.getDocSets(state.uri)) do
                local name = doc.type == 'doc.class' and doc.class[1]
                if  name
                and name ~= source.parent.class[1]
                and not used[name]
                and matchKey(source[1], name) then
                    used[name] = true
                    results[#results+1] = {
                        label       = name,
                        kind        = define.CompletionItemKind.Class,
                        textEdit    = name:find '[^%w_]' and {
                            start   = source.start,
                            finish  = position,
                            newText = name,
                        },
                    }
                end
            end
        end
        return true
    elseif source.type == 'doc.type.name' then
        local used = {}
        for _, doc in ipairs(vm.getDocSets(state.uri)) do
            local name = (doc.type == 'doc.class' and doc.class[1])
                    or   (doc.type == 'doc.alias' and doc.alias[1])
                    or   (doc.type == 'doc.enum'  and doc.enum[1])
            if  name
            and not used[name]
            and matchKey(source[1], name) then
                used[name] = true
                results[#results+1] = {
                    label       = name,
                    kind        = define.CompletionItemKind.Class,
                    textEdit    = name:find '[^%w_]' and {
                        start   = source.start,
                        finish  = position,
                        newText = name,
                    },
                }
            end
        end
        return true
    elseif source.type == 'doc.param.name' then
        local funcs = {}
        guide.eachSourceBetween(state.ast, position, math.huge, function (src)
            if src.type == 'function' and src.start > position then
                funcs[#funcs+1] = src
            end
        end)
        table.sort(funcs, function (a, b)
            return a.start < b.start
        end)
        local func = funcs[1]
        if not func or not func.args then
            return
        end
        for _, arg in ipairs(func.args) do
            if arg[1] and matchKey(source[1], arg[1]) then
                results[#results+1] = {
                    label  = arg[1],
                    kind   = define.CompletionItemKind.Interface,
                }
            end
        end
        return true
    elseif source.type == 'doc.diagnostic' then
        for _, mode in ipairs(diagnosticModes) do
            if matchKey(source.mode, mode) then
                results[#results+1] = {
                    label    = mode,
                    kind     = define.CompletionItemKind.Enum,
                    textEdit = {
                        start   = source.start,
                        finish  = source.start + #source.mode - 1,
                        newText = mode,
                    },
                }
            end
        end
        return true
    elseif source.type == 'doc.diagnostic.name' then
        for name in util.sortPairs(define.DiagnosticDefaultSeverity) do
            if matchKey(source[1], name) then
                results[#results+1] = {
                    label    = name,
                    kind     = define.CompletionItemKind.Value,
                    textEdit = {
                        start   = source.start,
                        finish  = source.start + #source[1] - 1,
                        newText = name,
                    },
                }
            end
        end
        return true
    elseif source.type == 'doc.module' then
        collectRequireNames('require', state.uri, source.module or '', source, source.smark, position, results)
        return true
    elseif source.type == 'doc.cast.name' then
        local locals = guide.getVisibleLocals(state.ast, position)
        for name, loc in util.sortPairs(locals) do
            if matchKey(source[1], name) then
                results[#results+1] = {
                    label = name,
                    kind  = define.CompletionItemKind.Variable,
                    id    = stack(loc, function (newLoc) ---@async
                        return {
                            detail      = buildDetail(newLoc),
                            description = buildDesc(newLoc),
                        }
                    end),
                }
            end
        end
        return true
    elseif source.type == 'doc.operator.name' then
        for _, name in ipairs(vm.UNARY_OP) do
            if matchKey(source[1], name) then
                results[#results+1] = {
                    label       = name,
                    kind        = define.CompletionItemKind.Operator,
                    description = ('```lua\n%s\n```'):format(vm.OP_UNARY_MAP[name]),
                }
            end
        end
        for _, name in ipairs(vm.BINARY_OP) do
            if matchKey(source[1], name) then
                results[#results+1] = {
                    label       = name,
                    kind        = define.CompletionItemKind.Operator,
                    description = ('```lua\n%s\n```'):format(vm.OP_BINARY_MAP[name]),
                }
            end
        end
        for _, name in ipairs(vm.OTHER_OP) do
            if matchKey(source[1], name) then
                results[#results+1] = {
                    label       = name,
                    kind        = define.CompletionItemKind.Operator,
                    description = ('```lua\n%s\n```'):format(vm.OP_OTHER_MAP[name]),
                }
            end
        end
        return true
    elseif source.type == 'doc.see.name' then
        local symbolds = wssymbol(source[1], state.uri)
        table.sort(symbolds, function (a, b)
            return a.name < b.name
        end)
        for _, symbol in ipairs(symbolds) do
            results[#results+1] = {
                label = symbol.name,
                kind  = symbol.ckind,
                id    = stack(symbol.source, function (newSource) ---@async
                    return {
                        detail      = buildDetail(newSource),
                        description = buildDesc(newSource),
                    }
                end),
                textEdit = {
                    start   = source.start,
                    finish  = source.finish,
                    newText = symbol.name,
                },
            }
        end
    end
    return false
end

---@async
local function tryluaDocByErr(state, position, err, docState, results)
    if     err.type == 'LUADOC_MISS_CLASS_EXTENDS_NAME' then
        local used = {}
        for _, doc in ipairs(vm.getDocSets(state.uri)) do
            if  doc.type == 'doc.class'
            and not used[doc.class[1]]
            and doc.class[1] ~= docState.class[1] then
                used[doc.class[1]] = true
                results[#results+1] = {
                    label       = doc.class[1],
                    kind        = define.CompletionItemKind.Class,
                }
            end
        end
    elseif err.type == 'LUADOC_MISS_TYPE_NAME' then
        local used = {}
        for _, doc in ipairs(vm.getDocSets(state.uri)) do
            if  doc.type == 'doc.class'
            and not used[doc.class[1]] then
                used[doc.class[1]] = true
                results[#results+1] = {
                    label       = doc.class[1],
                    kind        = define.CompletionItemKind.Class,
                }
            end
            if  doc.type == 'doc.alias'
            and not used[doc.alias[1]] then
                used[doc.alias[1]] = true
                results[#results+1] = {
                    label       = doc.alias[1],
                    kind        = define.CompletionItemKind.Class,
                }
            end
            if  doc.type == 'doc.enum'
            and not used[doc.enum[1]] then
                used[doc.enum[1]] = true
                results[#results+1] = {
                    label       = doc.enum[1],
                    kind        = define.CompletionItemKind.Enum,
                }
            end
        end
    elseif err.type == 'LUADOC_MISS_PARAM_NAME' then
        local funcs = {}
        guide.eachSourceBetween(state.ast, position, math.huge, function (src)
            if src.type == 'function' and src.start > position then
                funcs[#funcs+1] = src
            end
        end)
        table.sort(funcs, function (a, b)
            return a.start < b.start
        end)
        local func = funcs[1]
        if not func or not func.args then
            return
        end
        local label = {}
        local insertText = {}
        for i, arg in ipairs(func.args) do
            if arg[1] and arg.type ~= 'self' then
                label[#label+1] = arg[1]
                if #label == 1 then
                    insertText[#insertText+1] = ('%s ${%d:any}'):format(arg[1], #label)
                else
                    insertText[#insertText+1] = ('---@param %s ${%d:any}'):format(arg[1], #label)
                end
            end
        end
        results[#results+1] = {
            label            = table.concat(label, ', '),
            kind             = define.CompletionItemKind.Snippet,
            insertTextFormat = 2,
            insertText       = table.concat(insertText, '\n'),
        }
        for i, arg in ipairs(func.args) do
            if arg[1] then
                results[#results+1] = {
                    label  = arg[1],
                    kind   = define.CompletionItemKind.Interface,
                }
            end
        end
    elseif err.type == 'LUADOC_MISS_DIAG_MODE' then
        for _, mode in ipairs(diagnosticModes) do
            results[#results+1] = {
                label = mode,
                kind  = define.CompletionItemKind.Enum,
            }
        end
    elseif err.type == 'LUADOC_MISS_DIAG_NAME' then
        for name in util.sortPairs(diag.getDiagAndErrNameMap()) do
            results[#results+1] = {
                label = name,
                kind  = define.CompletionItemKind.Value,
            }
        end
    elseif err.type == 'LUADOC_MISS_MODULE_NAME' then
        collectRequireNames('require', state.uri, '', docState, nil, position, results)
    elseif err.type == 'LUADOC_MISS_LOCAL_NAME' then
        local locals = guide.getVisibleLocals(state.ast, position)
        for name, loc in util.sortPairs(locals) do
            if name ~= '_ENV' then
                results[#results+1] = {
                    label = name,
                    kind   = define.CompletionItemKind.Variable,
                    id     = stack(loc, function (newLoc) ---@async
                        return {
                            detail      = buildDetail(newLoc),
                            description = buildDesc(newLoc),
                        }
                    end),
                }
            end
        end
    elseif err.type == 'LUADOC_MISS_OPERATOR_NAME' then
        for _, name in ipairs(vm.UNARY_OP) do
            results[#results+1] = {
                label       = name,
                kind        = define.CompletionItemKind.Operator,
                description = ('```lua\n%s\n```'):format(vm.OP_UNARY_MAP[name]),
            }
        end
        for _, name in ipairs(vm.BINARY_OP) do
            results[#results+1] = {
                label       = name,
                kind        = define.CompletionItemKind.Operator,
                description = ('```lua\n%s\n```'):format(vm.OP_BINARY_MAP[name]),
            }
        end
        for _, name in ipairs(vm.OTHER_OP) do
            results[#results+1] = {
                label       = name,
                kind        = define.CompletionItemKind.Operator,
                description = ('```lua\n%s\n```'):format(vm.OP_OTHER_MAP[name]),
            }
        end
    elseif err.type == 'LUADOC_MISS_SEE_NAME' then
        local symbolds = wssymbol('', state.uri)
        table.sort(symbolds, function (a, b)
            return a.name < b.name
        end)
        for _, symbol in ipairs(symbolds) do
            results[#results+1] = {
                label = symbol.name,
                kind  = symbol.ckind,
                id    = stack(symbol.source, function (newSource) ---@async
                    return {
                        detail      = buildDetail(newSource),
                        description = buildDesc(newSource),
                    }
                end),
            }
        end
    end
end

local function buildluaDocOfFunction(func, pad)
    local index = 1
    local buf = {}
    buf[#buf+1] = '${1:comment}'
    local args = {}
    local returns = {}
    if func.args then
        for _, arg in ipairs(func.args) do
            args[#args+1] = vm.getInfer(arg):view(guide.getUri(func))
        end
    end
    if func.returns then
        for _, rtns in ipairs(func.returns) do
            for n = 1, #rtns do
                if not returns[n] then
                    returns[n] = vm.getInfer(rtns[n]):view(guide.getUri(func))
                end
            end
        end
    end
    for n, arg in ipairs(args) do
        local funcArg = func.args[n]
        if funcArg[1] and funcArg.type ~= 'self' then
            index = index + 1
            buf[#buf+1] = ('---%s@param %s ${%d:%s}'):format(
                pad and ' ' or '',
                funcArg[1],
                index,
                arg
            )
        end
    end
    for _, rtn in ipairs(returns) do
        index = index + 1
        buf[#buf+1] = ('---@return ${%d:%s}'):format(
            index,
            rtn
        )
    end
    local insertText = table.concat(buf, '\n')
    return insertText
end

local function tryluaDocOfFunction(doc, results, pad)
    if not doc.bindSource then
        return
    end
    local func = (doc.bindSource.type == 'function' and doc.bindSource)
              or (doc.bindSource.value and doc.bindSource.value.type == 'function' and doc.bindSource.value)
              or nil
    if not func then
        return
    end
    for _, otherDoc in ipairs(doc.bindGroup) do
        if otherDoc.type == 'doc.return' then
            return
        end
    end
    if func.args then
        for _, param in ipairs(func.args) do
            if param.bindDocs then
                return
            end
        end
    end
    local insertText = buildluaDocOfFunction(func, pad)
    results[#results+1] = {
        label            = '@param;@return',
        kind             = define.CompletionItemKind.Snippet,
        insertTextFormat = 2,
        filterText       = '---',
        insertText       = insertText
    }
end

---@async
local function tryLuaDoc(state, position, results)
    local doc = getLuaDoc(state, position)
    if not doc then
        return
    end
    if doc.type == 'doc.comment' then
        local line = doc.originalComment.text
        -- 尝试 '---$' or '--- $'
        if line == '-' or line == '- ' then
            tryluaDocOfFunction(doc, results, line == '- ')
            return
        end
        -- 尝试 ---@$
        local cate = line:match('^-+%s*@(%a*)$')
        if cate then
            tryluaDocCate(cate, results)
            return
        end
    end
    -- 根据输入中的source来补全
    local source = getluaDocByContain(state, position)
    if source then
        local suc = tryluaDocBySource(state, position, source, results)
        if suc then
            return
        end
    end
    -- 根据附近的错误消息来补全
    local err, expectDoc = getluaDocByErr(state, doc.start, position)
    if err then
        tryluaDocByErr(state, position, err, expectDoc, results)
        return
    end
end

local function tryComment(state, position, results)
    if #results > 0 then
        return
    end
    local word = lookBackward.findWord(state.lua, guide.positionToOffset(state, position))
    local doc  = getLuaDoc(state, position)
    if not word then
        local comment = getComment(state, position)
        if not comment then
            return
        end
        if comment.type == 'comment.short'
        or comment.type == 'comment.cshort' then
            if comment.text == '' then
                results[#results+1] = {
                    label = '#region',
                    kind  = define.CompletionItemKind.Snippet,
                }
                results[#results+1] = {
                    label = '#endregion',
                    kind  = define.CompletionItemKind.Snippet,
                }
            end
        end
        return
    end
    if doc and doc.type ~= 'doc.comment' then
        return
    end
    checkCommon(state, word, position, results)
end

---@async
local function tryCompletions(state, position, triggerCharacter, results)
    if getComment(state, position) then
        tryLuaDoc(state, position, results)
        tryComment(state, position, results)
        return
    end
    if postfix(state, position, results) then
        return
    end
    if tryTable(state, position, results) then
        return
    end
    trySpecial(state, position, results)
    tryCallArg(state, position, results)
    tryArray(state, position, results)
    tryWord(state, position, triggerCharacter, results)
    tryIndex(state, position, results)
    trySymbol(state, position, results)
end

---@async
local function completion(uri, position, triggerCharacter)
    local state = files.getLastState(uri) or files.getState(uri)
    if not state then
        return nil
    end
    clearStack()
    diagnostic.pause()
    local _ <close> = diagnostic.resume
    local results = {}
    tracy.ZoneBeginN 'completion #2'
    tryCompletions(state, position, triggerCharacter, results)
    tracy.ZoneEnd()

    if #results == 0 then
        return nil
    end

    return results
end

---@async
local function resolve(id)
    local item = resolveStack(id)
    return item
end

return {
    completion   = completion,
    resolve      = resolve,
}
