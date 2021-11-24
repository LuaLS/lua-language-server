local sp           = require 'bee.subprocess'
local define       = require 'proto.define'
local files        = require 'files'
local searcher     = require 'core.searcher'
local matchKey     = require 'core.matchkey'
local vm           = require 'vm'
local getName      = require 'core.hover.name'
local getArg       = require 'core.hover.arg'
local getHover     = require 'core.hover'
local config       = require 'config'
local util         = require 'utility'
local markdown     = require 'provider.markdown'
local parser       = require 'parser'
local keyWordMap   = require 'core.keyword'
local workspace    = require 'workspace'
local furi         = require 'file-uri'
local rpath        = require 'workspace.require-path'
local lang         = require 'language'
local lookBackward = require 'core.look-backward'
local guide        = require 'parser.guide'
local infer        = require 'core.infer'
local noder        = require 'core.noder'
local await        = require 'await'
local postfix      = require 'core.completion.postfix'

local DiagnosticModes = {
    'disable-next-line',
    'disable-line',
    'disable',
    'enable',
}

local stackID = 0
local stacks = {}

---@param callback async fun()
local function stack(callback)
    stackID = stackID + 1
    stacks[stackID] = callback
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
    local source
    guide.eachSourceContain(state.ast, position, function (src)
        source = src
    end)
    return source
end

local function findNearestTableField(state, position)
    local uri     = state.uri
    local text    = files.getText(uri)
    local offset  = guide.positionToOffset(state, position)
    local soffset = lookBackward.findAnyOffset(text, offset)
    if not soffset then
        return nil
    end
    local symbol  = text:sub(soffset, soffset)
    if symbol == '}' then
        return nil
    end
    local sposition = guide.offsetToPosition(state, soffset)
    local source
    guide.eachSourceContain(state.ast, sposition, function (src)
        if src.type == 'table'
        or src.type == 'tablefield'
        or src.type == 'tableindex'
        or src.type == 'tableexp' then
            source = src
        end
    end)
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
        if char == '.' then
            -- `..` 的情况
            if text:sub(i-1, i-1) == '.' then
                return nil, nil
            end
            oop = false
        elseif char == ':' then
            oop = true
        else
            return nil, nil
        end
        local anyOffset = lookBackward.findAnyOffset(text, i-1)
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
    local args = getArg(value, oop)
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
    if source.type == 'dummy' then
        return
    end
    local types = infer.searchAndViewInfers(source)
    local literals = infer.searchAndViewLiterals(source)
    if literals then
        return types .. ' = ' .. literals
    else
        return types
    end
end

local function getSnip(source)
    local context = config.get 'Lua.completion.displayContext'
    if context <= 0 then
        return nil
    end
    local defs = vm.getRefs(source)
    for _, def in ipairs(defs) do
        def = searcher.getObjectValue(def) or def
        if def ~= source and def.type == 'function' then
            local uri = guide.getUri(def)
            local text = files.getText(uri)
            local state = files.getState(uri)
            local lines = state.lines
            if not text then
                goto CONTINUE
            end
            if vm.isMetaFile(uri) then
                goto CONTINUE
            end
            local firstRow = guide.rowColOf(def.start)
            local lastRow  = firstRow + context
            local lastOffset = lines[lastRow] and (lines[lastRow] - 1) or #text
            local snip = text:sub(lines[firstRow], lastOffset)
            return snip
        end
        ::CONTINUE::
    end
end

---@async
local function buildDesc(source)
    if source.type == 'dummy' then
        return
    end
    local desc = markdown()
    local hover = getHover.get(source)
    desc:add('md', hover)
    desc:splitLine()
    desc:add('lua', getSnip(source))
    return desc
end

local function buildFunction(results, source, value, oop, data)
    local snipType = config.get 'Lua.completion.callSnippet'
    if snipType == 'Disable' or snipType == 'Both' then
        results[#results+1] = data
    end
    if snipType == 'Both' or snipType == 'Replace' then
        local snipData = util.deepCopy(data)
        snipData.kind = define.CompletionItemKind.Snippet
        snipData.insertText = buildFunctionSnip(source, value, oop)
        snipData.insertTextFormat = 2
        snipData.command = {
            title = 'trigger signature',
            command = 'editor.action.triggerParameterHints',
        }
        snipData.id  = stack(function () ---@async
            return {
                detail      = buildDetail(source),
                description = buildDesc(source),
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
        if arg.type == '...' then
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
        if infer.hasType(source, 'function') then
            for _, def in ipairs(vm.getDefs(source)) do
                if def.type == 'function'
                or def.type == 'doc.type.function' then
                    local funcLabel = name .. getParams(def, false)
                    buildFunction(results, source, def, false, {
                        label  = funcLabel,
                        match  = name,
                        insertText = name,
                        kind   = define.CompletionItemKind.Function,
                        id     = stack(function () ---@async
                            return {
                                detail      = buildDetail(source),
                                description = buildDesc(source),
                            }
                        end),
                    })
                end
            end
        else
            results[#results+1] = {
                label  = name,
                kind   = define.CompletionItemKind.Variable,
                id     = stack(function () ---@async
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

local function checkModule(state, word, position, results)
    if not config.get 'Lua.completion.autoRequire' then
        return
    end
    local locals  = guide.getVisibleLocals(state.ast, position)
    for uri in files.eachFile() do
        if uri == guide.getUri(state.ast) then
            goto CONTINUE
        end
        local path = furi.decode(uri)
        local fileName = path:match '[^/\\]*$'
        local stemName = fileName:gsub('%..+', '')
        if  not locals[stemName]
        and not vm.hasGlobalSets(stemName)
        and not config.get 'Lua.diagnostics.globals'[stemName]
        and stemName:match '^[%a_][%w_]*$'
        and matchKey(word, stemName) then
            local targetState = files.getState(uri)
            if not targetState then
                goto CONTINUE
            end
            local targetReturns = targetState.ast.returns
            if not targetReturns then
                goto CONTINUE
            end
            local targetSource = targetReturns[1] and targetReturns[1][1]
            if not targetSource then
                goto CONTINUE
            end
            if  targetSource.type ~= 'getlocal'
            and targetSource.type ~= 'table'
            and targetSource.type ~= 'function' then
                goto CONTINUE
            end
            if  targetSource.type == 'getlocal'
            and vm.isDeprecated(targetSource.node) then
                goto CONTINUE
            end
            results[#results+1] = {
                label  = stemName,
                kind   = define.CompletionItemKind.Variable,
                commitCharacters = {'.'},
                command = {
                    title     = 'autoRequire',
                    command   = 'lua.autoRequire:' .. sp:get_id(),
                    arguments = {
                        {
                            uri    = guide.getUri(state.ast),
                            target = uri,
                            name   = stemName,
                        },
                    },
                },
                id     = stack(function () ---@async
                    local md = markdown()
                    md:add('md', lang.script('COMPLETION_IMPORT_FROM', ('[%s](%s)'):format(
                        workspace.getRelativePath(uri),
                        uri
                    )))
                    md:add('md', buildDesc(targetSource))
                    return {
                        detail      = buildDetail(targetSource),
                        description = md,
                        --additionalTextEdits = buildInsertRequire(state, originUri, stemName),
                    }
                end)
            }
        end
        ::CONTINUE::
    end
end

local function checkFieldFromFieldToIndex(state, name, src, parent, word, startPos, position)
    if name:match '^[%a_][%w_]*$' then
        return nil
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
    local newText
    if vm.getKeyType(src) == 'string' then
        newText = ('[%q]'):format(name)
    else
        newText = ('[%s]'):format(name)
    end
    textEdit = {
        start   = wordStartPos,
        finish  = position,
        newText = newText,
    }
    local nxt = parent.next
    if nxt then
        local dotStart, dotFinish
        if nxt.type == 'setfield'
        or nxt.type == 'getfield'
        or nxt.type == 'tablefield' then
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
        if config.get 'Lua.runtime.version' == 'lua 5.1'
        or config.get 'Lua.runtime.version' == 'luaJIT' then
            textEdit.newText = '_G' .. textEdit.newText
        else
            textEdit.newText = '_ENV' .. textEdit.newText
        end
    end
    return textEdit, additionalTextEdits
end

local function checkFieldThen(state, name, src, word, startPos, position, parent, oop, results)
    local value = searcher.getObjectValue(src) or src
    local kind = define.CompletionItemKind.Field
    if value.type == 'function'
    or value.type == 'doc.type.function' then
        if oop then
            kind = define.CompletionItemKind.Method
        else
            kind = define.CompletionItemKind.Function
        end
        buildFunction(results, src, value, oop, {
            label      = name,
            kind       = kind,
            match      = name:match '^[^(]+',
            insertText = name:match '^[^(]+',
            deprecated = vm.isDeprecated(src) or nil,
            id         = stack(function () ---@async
                return {
                    detail      = buildDetail(src),
                    description = buildDesc(src),
                }
            end),
        })
        return
    end
    if oop and not infer.hasType(src, 'function') then
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
            newText = name,
        }
    else
        textEdit, additionalTextEdits = checkFieldFromFieldToIndex(state, name, src, parent, word, startPos, position)
    end
    results[#results+1] = {
        label      = name,
        kind       = kind,
        deprecated = vm.isDeprecated(src) or nil,
        textEdit   = textEdit,
        additionalTextEdits = additionalTextEdits,
        id         = stack(function () ---@async
            return {
                detail      = buildDetail(src),
                description = buildDesc(src),
            }
        end)
    }
end

---@async
local function checkFieldOfRefs(refs, state, word, startPos, position, parent, oop, results, locals, isGlobal)
    local fields = {}
    local funcs  = {}
    local count = 0
    for _, src in ipairs(refs) do
        local name = vm.getKeyName(src)
        if not name then
            goto CONTINUE
        end
        if isSameSource(state, src, startPos) then
            goto CONTINUE
        end
        if isGlobal and locals and locals[name] then
            goto CONTINUE
        end
        if not matchKey(word, name, count >= 100) then
            goto CONTINUE
        end
        local funcLabel
        if config.get 'Lua.completion.showParams' then
            local value = searcher.getObjectValue(src) or src
            if value.type == 'function'
            or value.type == 'doc.type.function' then
                funcLabel = name .. getParams(value, oop)
                fields[funcLabel] = src
                count = count + 1
                if value.type == 'function' and value.bindDocs then
                    for _, doc in ipairs(value.bindDocs) do
                        if doc.type == 'doc.overload' then
                            funcLabel = name .. getParams(doc.overload, oop)
                            fields[funcLabel] = doc.overload
                        end
                    end
                end
                funcs[name] = true
                if fields[name] and not guide.isSet(fields[name]) then
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
        if vm.isDeprecated(src) then
            goto CONTINUE
        end
        if guide.isSet(src) then
            fields[name] = src
            goto CONTINUE
        end
        ::CONTINUE::
    end
    for name, src in util.sortPairs(fields) do
        if src then
            checkFieldThen(state, name, src, word, startPos, position, parent, oop, results)
            await.delay()
        end
    end
end

---@async
local function checkGlobal(state, word, startPos, position, parent, oop, results)
    local locals = guide.getVisibleLocals(state.ast, position)
    local globals = vm.getGlobalSets '*'
    checkFieldOfRefs(globals, state, word, startPos, position, parent, oop, results, locals, 'global')
end

---@async
local function checkField(state, word, start, position, parent, oop, results)
    if parent.tag == '_ENV' or parent.special == '_G' then
        local globals = vm.getGlobalSets '*'
        checkFieldOfRefs(globals, state, word, start, position, parent, oop, results)
    else
        local refs = vm.getRefs(parent, '*')
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
    local showWord = config.get 'Lua.completion.showWord'
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
    if config.get 'Lua.completion.workspaceWord' and #word >= 2 then
        results.complete = true
        local myHead = word:sub(1, 2)
        for uri in files.eachFile() do
            if #results >= 100 then
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
    for str, offset in state.lua:gmatch '([%a_][%w_]+)()' do
        if #results >= 100 then
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
    if #results >= 100 then
        results.complete = false
    end
end

local function checkKeyWord(state, start, position, word, hasSpace, afterLocal, results)
    local text = state.lua
    local snipType = config.get 'Lua.completion.keywordSnippet'
    local symbol = lookBackward.findSymbol(text, guide.positionToOffset(state, start))
    local isExp = symbol == '(' or symbol == ',' or symbol == '='
    local info = {
        hasSpace = hasSpace,
        isExp    = isExp,
        text     = text,
        start    = start,
        uri      = guide.getUri(state.ast),
        position   = position,
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
    local text = state.lua
    local offset = guide.positionToOffset(state, startPos)
    local pos    = lookBackward.skipSpace(text, offset)
    local word   = lookBackward.findWord(text, pos)
    return word == 'local'
end

local function collectRequireNames(mode, myUri, literal, source, smark, position, results)
    local collect = {}
    if mode == 'require' then
        for uri in files.eachFile() do
            if myUri == uri then
                goto CONTINUE
            end
            local path = workspace.getRelativePath(uri)
            local infos = rpath.getVisiblePath(path)
            for _, info in ipairs(infos) do
                if matchKey(literal, info.expect) then
                    if not collect[info.expect] then
                        collect[info.expect] = {
                            textEdit = {
                                start   = smark and (source.start + #smark) or position,
                                finish  = smark and (source.finish - #smark) or position,
                                newText = smark and info.expect or util.viewString(info.expect),
                            }
                        }
                    end
                    if vm.isMetaFile(uri) then
                        collect[info.expect][#collect[info.expect]+1] = ('* [[meta]](%s)'):format(uri)
                    else
                        collect[info.expect][#collect[info.expect]+1] = ([=[* [%s](%s) %s]=]):format(
                            path,
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
                            }
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
        for uri in files.eachFile() do
            if myUri == uri then
                goto CONTINUE
            end
            if vm.isMetaFile(uri) then
                goto CONTINUE
            end
            local path = workspace.getRelativePath(uri)
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
            label = label,
            kind  = define.CompletionItemKind.Reference,
            description = table.concat(des, '\n'),
            textEdit = infos.textEdit,
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
    local str = parser.grammar(label, 'String')
    if not str then
        return label
    end
    if not matchKey(source[1], str[1]) then
        return nil
    end
    return util.viewString(str[1], source[2])
end

local function mergeEnums(a, b, source)
    local mark = {}
    for _, enum in ipairs(a) do
        mark[enum.label] = true
    end
    for _, enum in ipairs(b) do
        local label = tryLabelInString(enum.label, source)
        if label and not mark[label] then
            mark[label] = true
            local result = {
                label       = label,
                kind        = enum.kind,
                description = enum.description,
                insertText  = enum.insertText,
                textEdit    = source and {
                    start   = source.start,
                    finish  = source.finish,
                    newText = enum.insertText or label,
                },
            }
            a[#a+1] = result
        end
    end
end

local function checkTypingEnum(state, position, defs, str, results)
    local enums = {}
    for _, def in ipairs(defs) do
        if def.type == 'doc.type.enum'
        or def.type == 'doc.resume' then
            enums[#enums+1] = {
                label       = def[1],
                description = def.comment and def.comment.text,
                kind        = define.CompletionItemKind.EnumMember,
            }
        end
    end
    local myResults = {}
    mergeEnums(myResults, enums, str)
    table.sort(myResults, function (a, b)
        return a.label < b.label
    end)
    for _, res in ipairs(myResults) do
        results[#results+1] = res
    end
end

local function checkEqualEnumLeft(state, position, source, results)
    if not source then
        return
    end
    local str = guide.eachSourceContain(state.ast, position, function (src)
        if src.type == 'string' then
            return src
        end
    end)
    local defs = vm.getDefs(source)
    checkTypingEnum(state, position, defs, str, results)
end

local function checkEqualEnum(state, position, results)
    local text = state.lua
    local start =  lookBackward.findTargetSymbol(text, guide.positionToOffset(state, position), '=')
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
    if parent.type == 'local' then
        checkEqualEnumLeft(state, position, parent, results)
    end
    if parent.type == 'setlocal'
    or parent.type == 'setglobal'
    or parent.type == 'setfield'
    or parent.type == 'setindex' then
        checkEqualEnumLeft(state, position, parent.node, results)
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
    local word = parent.next.index[1]
    checkField(state, word, position, position, parent, oop, results)
end

---@async
local function tryWord(state, position, triggerCharacter, results)
    local text = state.lua
    local offset = guide.positionToOffset(state, position)
    local finish = lookBackward.skipSpace(text, offset)
    local word, start = lookBackward.findWord(text, offset)
    local startPos
    if not word then
        return nil
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
        if parent then
            if not hasSpace then
                checkField(state, word, startPos, position, parent, oop, results)
            end
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
        if not hasSpace then
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
    if symbol == '.'
    or symbol == ':' then
        local parent, oop = findParent(state, startPos)
        if parent then
            tracy.ZoneBeginN 'completion.trySymbol'
            checkField(state, '', startPos, position, parent, oop, results)
            tracy.ZoneEnd()
        end
    end
    if symbol == '(' then
        checkFunctionArgByDocParam(state, '', startPos, results)
    end
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

local function pushCallEnumsAndFuncs(defs)
    local results = {}
    for _, def in ipairs(defs) do
        if def.type == 'doc.type.enum'
        or def.type == 'doc.resume' then
            results[#results+1] = {
                label       = def[1],
                description = def.comment,
                kind        = define.CompletionItemKind.EnumMember,
            }
        end
        if def.type == 'doc.type.function' then
            results[#results+1] = {
                label       = infer.viewDocFunction(def),
                description = def.comment,
                kind        = define.CompletionItemKind.Function,
                insertText  = buildInsertDocFunction(def),
            }
        end
    end
    return results
end

local function getCallEnumsAndFuncs(source, index, oop, call)
    if source.type == 'function' and source.bindDocs then
        if not source.args then
            return
        end
        local arg
        if index <= #source.args then
            arg = source.args[index]
        else
            local lastArg = source.args[#source.args]
            if lastArg.type == '...' then
                arg = lastArg
            else
                return
            end
        end
        for _, doc in ipairs(source.bindDocs) do
            if  doc.type == 'doc.param'
            and doc.param[1] == arg[1] then
                return pushCallEnumsAndFuncs(vm.getDefs(doc.extends))
            elseif doc.type == 'doc.vararg'
            and    arg.type == '...' then
                return pushCallEnumsAndFuncs(vm.getDefs(doc.vararg))
            end
        end
    end
    if source.type == 'doc.type.function' then
        --[[
        always use literal index, that is:
        ```
        ---@class Class
        ---@field f(x: number, y: boolean)
        local c

        c.f(1, true) -- correct
        c:f(1, true) -- also correct
        ```
        --]]
        if oop then
            index = index - 1
        end
        local arg = source.args[index]
        if arg and arg.extends then
            return pushCallEnumsAndFuncs(vm.getDefs(arg.extends))
        end
    end
    if source.type == 'doc.field.name' then
        local currentIndex = index
        if oop then
            currentIndex = index - 1
        end
        local class = source.parent.class
        if not class then
            return
        end
        local results = {}
        if currentIndex == 1 then
            for _, doc in ipairs(class.fields) do
                if  doc.field ~= source
                and doc.field[1] == source[1] then
                    local eventName = noder.getFieldEventName(doc)
                    if eventName then
                        results[#results+1] = {
                            label       = ('%q'):format(eventName),
                            description = doc.comment,
                            kind        = define.CompletionItemKind.EnumMember,
                        }
                    end
                end
            end
        elseif currentIndex == 2 then
            local myEventName = call.args[index - 1][1]
            for _, doc in ipairs(class.fields) do
                if  doc.field ~= source
                and doc.field[1] == source[1] then
                    local eventName = noder.getFieldEventName(doc)
                    if eventName and eventName == myEventName then
                        local docFunc = doc.extends.types[1].args[2].extends.types[1]
                        results[#results+1] = {
                            label       = infer.viewDocFunction(docFunc),
                            description = doc.comment,
                            kind        = define.CompletionItemKind.Function,
                            insertText  = buildInsertDocFunction(docFunc),
                        }
                    end
                end
            end
        end
        return results
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
        return 1, nil, nil
    end
    local oop = call.node.type == 'getmethod'
    for index, arg in ipairs(call.args) do
        if arg.start <= position and arg.finish >= position then
            return index, arg, oop
        end
    end
    return #call.args + 1, nil, oop
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
        return guide.getKeyName(a) < guide.getKeyName(b)
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
        for _, field in ipairs(fields) do
            local name = guide.getKeyName(field)
            if not mark[name] and matchKey(left, guide.getKeyName(field)) then
                results[#results+1] = {
                    label = guide.getKeyName(field),
                    kind  = define.CompletionItemKind.Property,
                    insertText = ('%s = $0'):format(guide.getKeyName(field)),
                    id    = stack(function () ---@async
                        return {
                            detail      = buildDetail(field),
                            description = buildDesc(field),
                        }
                    end),
                }
            end
        end
    end
end

local function tryCallArg(state, position, results)
    local call = findCall(state, position)
    if not call then
        return
    end
    local myResults = {}
    local argIndex, arg, oop = getCallArgInfo(call, position)
    if arg and arg.type == 'function' then
        return
    end
    local defs = vm.getDefs(call.node)
    for _, def in ipairs(defs) do
        def = searcher.getObjectValue(def) or def
        local enums = getCallEnumsAndFuncs(def, argIndex, oop, call)
        if enums then
            mergeEnums(myResults, enums, arg)
        end
    end
    for _, enum in ipairs(myResults) do
        results[#results+1] = enum
    end
end

local function tryTable(state, position, results)
    local source = findNearestTableField(state, position)
    if not source then
        return
    end
    if  source.type ~= 'table'
    and (not source.parent or source.parent.type ~= 'table') then
        return
    end
    local mark = {}
    local fields = {}
    local tbl = source
    if source.type ~= 'table' then
        tbl = source.parent
    end
    local defs = vm.getDefs(tbl, '*')
    for _, field in ipairs(defs) do
        local name = guide.getKeyName(field)
        if name and not mark[name] then
            mark[name] = true
            fields[#fields+1] = field
        end
    end
    checkTableLiteralField(state, position, tbl, fields, results)
end

local function getComment(state, position)
    for _, comm in ipairs(state.comms) do
        if position > comm.start and position <= comm.finish then
            return comm
        end
    end
    return nil
end

local function getluaDoc(state, position)
    for _, doc in ipairs(state.ast.docs) do
        if position >= doc.start and position <= doc.range then
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
    } do
        if matchKey(word, docType) then
            results[#results+1] = {
                label       = docType,
                kind        = define.CompletionItemKind.Event,
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
        if  range  >= position - src.start
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

local function tryluaDocBySource(state, position, source, results)
    if source.type == 'doc.extends.name' then
        if source.parent.type == 'doc.class' then
            local used = {}
            for _, doc in ipairs(vm.getDocDefines '*') do
                if  doc.type == 'doc.class.name'
                and doc.parent ~= source.parent
                and not used[doc[1]]
                and matchKey(source[1], doc[1]) then
                    used[doc[1]] = true
                    results[#results+1] = {
                        label       = doc[1],
                        kind        = define.CompletionItemKind.Class,
                        textEdit    = doc[1]:find '[^%w_]' and {
                            start   = source.start,
                            finish  = position,
                            newText = doc[1],
                        },
                    }
                end
            end
        end
        return true
    elseif source.type == 'doc.type.name' then
        local used = {}
        for _, doc in ipairs(vm.getDocDefines '*') do
            if  (doc.type == 'doc.class.name' or doc.type == 'doc.alias.name')
            and doc.parent ~= source.parent
            and not used[doc[1]]
            and matchKey(source[1], doc[1]) then
                used[doc[1]] = true
                results[#results+1] = {
                    label       = doc[1],
                    kind        = define.CompletionItemKind.Class,
                    textEdit    = doc[1]:find '[^%w_]' and {
                        start   = source.start,
                        finish  = position,
                        newText = doc[1],
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
        for _, mode in ipairs(DiagnosticModes) do
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
                    label = name,
                    kind  = define.CompletionItemKind.Value,
                    textEdit = {
                        start   = source.start,
                        finish  = source.start + #source[1] - 1,
                        newText = name,
                    },
                }
            end
        end
    elseif source.type == 'doc.module' then
        collectRequireNames('require', state.uri, source.module or '', source, source.smark, position, results)
    end
    return false
end

local function tryluaDocByErr(state, position, err, docState, results)
    if err.type == 'LUADOC_MISS_CLASS_EXTENDS_NAME' then
        for _, doc in ipairs(vm.getDocDefines '*') do
            if  doc.type == 'doc.class.name'
            and doc.parent ~= docState then
                results[#results+1] = {
                    label       = doc[1],
                    kind        = define.CompletionItemKind.Class,
                }
            end
        end
    elseif err.type == 'LUADOC_MISS_TYPE_NAME' then
        for _, doc in ipairs(vm.getDocDefines '*') do
            if  (doc.type == 'doc.class.name' or doc.type == 'doc.alias.name') then
                results[#results+1] = {
                    label       = doc[1],
                    kind        = define.CompletionItemKind.Class,
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
            if arg[1] and not arg.dummy then
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
        for _, mode in ipairs(DiagnosticModes) do
            results[#results+1] = {
                label = mode,
                kind  = define.CompletionItemKind.Enum,
            }
        end
    elseif err.type == 'LUADOC_MISS_DIAG_NAME' then
        for name in util.sortPairs(define.DiagnosticDefaultSeverity) do
            results[#results+1] = {
                label = name,
                kind  = define.CompletionItemKind.Value,
            }
        end
    elseif err.type == 'LUADOC_MISS_MODULE_NAME' then
        collectRequireNames('require', state.uri, '', docState, nil, position, results)
    end
end

local function buildluaDocOfFunction(func)
    local index = 1
    local buf = {}
    buf[#buf+1] = '${1:comment}'
    local args = {}
    local returns = {}
    if func.args then
        for _, arg in ipairs(func.args) do
            args[#args+1] = infer.searchAndViewInfers(arg)
        end
    end
    if func.returns then
        for _, rtns in ipairs(func.returns) do
            for n = 1, #rtns do
                if not returns[n] then
                    returns[n] = infer.searchAndViewInfers(rtns[n])
                end
            end
        end
    end
    for n, arg in ipairs(args) do
        local funcArg = func.args[n]
        if funcArg[1] and not funcArg.dummy then
            index = index + 1
            buf[#buf+1] = ('---@param %s ${%d:%s}'):format(
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

local function tryluaDocOfFunction(doc, results)
    if not doc.bindSources then
        return
    end
    local func
    for _, source in ipairs(doc.bindSources) do
        if source.type == 'function' then
            func = source
            break
        end
    end
    if not func then
        return
    end
    for _, otherDoc in ipairs(doc.bindGroup) do
        if otherDoc.type == 'doc.param'
        or otherDoc.type == 'doc.return' then
            return
        end
    end
    local insertText = buildluaDocOfFunction(func)
    results[#results+1] = {
        label   = '@param;@return',
        kind    = define.CompletionItemKind.Snippet,
        insertTextFormat = 2,
        filterText   = '---',
        insertText   = insertText
    }
end

local function tryluaDoc(state, position, results)
    local doc = getluaDoc(state, position)
    if not doc then
        return
    end
    if doc.type == 'doc.comment' then
        local line = doc.originalComment.text
        -- 尝试 ---$
        if line == '-' then
            tryluaDocOfFunction(doc, results)
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
    local doc  = getluaDoc(state, position)
    if not word then
        local comment = getComment(state, position)
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

local function makeCache(uri, position, results)
    local cache = workspace.getCache 'completion'
    if not uri then
        cache.results = nil
        return
    end
    local text  = files.getText(uri)
    local state = files.getState(uri)
    local word = lookBackward.findWord(text, guide.positionToOffset(state, position))
    if not word or #word < 2 then
        cache.results = nil
        return
    end
    cache.results = results
    cache.position= position
    cache.word    = word:lower()
    cache.length  = #word
end

local function isValidCache(word, result)
    if result.kind == define.CompletionItemKind.Text then
        return false
    end
    local match = result.match or result.label
    if matchKey(word, match) then
        return true
    end
    if result.textEdit then
        match = result.textEdit.newText:match '[%w_]+'
        if match and matchKey(word, match) then
            return true
        end
    end
    return false
end

local function getCache(uri, position)
    local cache = workspace.getCache 'completion'
    if not cache.results then
        return nil
    end
    local text  = files.getText(uri)
    local state = files.getState(uri)
    local word = lookBackward.findWord(text, guide.positionToOffset(state, position))
    if not word then
        return nil
    end
    if word:sub(1, #cache.word):lower() ~= cache.word then
        return nil
    end

    local ext = #word - cache.length
    cache.length = #word
    local results = cache.results
    for i = #results, 1, -1 do
        local result = results[i]
        if isValidCache(word, result) then
            if result.textEdit then
                result.textEdit.finish = result.textEdit.finish + ext
            end
        else
            results[i] = results[#results]
            results[#results] = nil
        end
    end

    if results.enableCommon then
        checkCommon(state, word, position, results)
    end

    return cache.results
end

local function clearCache()
    local cache = workspace.getCache 'completion'
    cache.results = nil
end

---@async
local function tryCompletions(state, position, triggerCharacter, results)
    local text = state.lua
    if not state then
        local word = lookBackward.findWord(text, guide.positionToOffset(state, position))
        if not word then
            return
        end
        checkCommon(nil, word, position, results)
        return
    end
    if getComment(state, position) then
        tryluaDoc(state, position, results)
        tryComment(state, position, results)
        return
    end
    if postfix(state, position, results) then
        return
    end
    trySpecial(state, position, results)
    tryCallArg(state, position, results)
    tryTable(state, position, results)
    tryWord(state, position, triggerCharacter, results)
    tryIndex(state, position, results)
    trySymbol(state, position, results)
end

---@async
local function completion(uri, position, triggerCharacter)
    tracy.ZoneBeginN 'completion cache'
    local results = getCache(uri, position)
    tracy.ZoneEnd()
    if results then
        return results
    end
    await.delay()
    tracy.ZoneBeginN 'completion #1'
    local state = files.getState(uri)
    results = {}
    clearStack()
    tracy.ZoneEnd()
    tracy.ZoneBeginN 'completion #2'
    tryCompletions(state, position, triggerCharacter, results)
    tracy.ZoneEnd()

    if #results == 0 then
        clearCache()
        return nil
    end

    tracy.ZoneBeginN 'completion #3'
    makeCache(uri, position, results)
    tracy.ZoneEnd()
    return results
end

---@async
local function resolve(id)
    local item = resolveStack(id)
    local cache = workspace.getCache 'completion'
    if item and cache.results then
        for _, res in ipairs(cache.results) do
            if res and res.id == id then
                for k, v in pairs(item) do
                    res[k] = v
                end
                res.id = nil
                break
            end
        end
    end
    return item
end

return {
    completion   = completion,
    resolve      = resolve,
    clearCache   = clearCache,
}
