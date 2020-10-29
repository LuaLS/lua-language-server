local define     = require 'proto.define'
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
local parser     = require 'parser'
local keyWordMap = require 'core.keyword'
local workspace  = require 'workspace'
local furi       = require 'file-uri'
local rpath      = require 'workspace.require-path'
local lang       = require 'language'

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

    -- 当进行新的 resolve 时，放弃当前的 resolve
    await.close('completion.resove')
    return await.await(callback, 'completion.resove')
end

local function trim(str)
    return str:match '^%s*(%S+)%s*$'
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
        or char == ':' then
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

local function findParentInStringIndex(ast, text, offset)
    local near, nearStart
    guide.eachSourceContain(ast.ast, offset, function (source)
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

local function buildFunctionSnip(source, oop)
    local name = getName(source):gsub('^.-[$.:]', '')
    local defs = vm.getDefs(source, 'deep')
    local args = ''
    for _, def in ipairs(defs) do
        local defArgs = getArg(def, oop)
        if defArgs ~= '' then
            args = defArgs
            break
        end
    end
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
    local types = vm.getInferType(source, 'deep')
    local literals = vm.getInferLiteral(source, 'deep')
    if literals then
        return types .. ' = ' .. literals
    else
        return types
    end
end

local function getSnip(source)
    local context = config.config.completion.displayContext
    if context <= 0 then
        return nil
    end
    local defs = vm.getRefs(source, 'deep')
    for _, def in ipairs(defs) do
        if def ~= source and def.type == 'function' then
            local uri = guide.getUri(def)
            local text = files.getText(uri)
            local lines = files.getLines(uri)
            if not text then
                return nil
            end
            local row = guide.positionOf(lines, def.start)
            local firstRow = lines[row]
            local lastRow = lines[math.min(row + context - 1, #lines)]
            local snip = text:sub(firstRow.start, lastRow.finish)
            return snip
        end
    end
end

local function buildDesc(source)
    local hover = getHover.get(source)
    local md = markdown()
    md:add('lua', hover.label)
    md:add('md',  hover.description)
    local snip = getSnip(source)
    if snip then
        md:add('md', '-------------')
        md:add('lua', snip)
    end
    return md:string()
end

local function buildFunction(results, source, oop, data)
    local snipType = config.config.completion.callSnippet
    if snipType == 'Disable' or snipType == 'Both' then
        results[#results+1] = data
    end
    if snipType == 'Both' or snipType == 'Replace' then
        local snipData = util.deepCopy(data)
        snipData.kind = define.CompletionItemKind.Snippet
        snipData.label = snipData.label .. '()'
        snipData.insertText = buildFunctionSnip(source, oop)
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

local function isSameSource(ast, source, pos)
    if source.type == 'library' then
        return false
    end
    if not files.eq(guide.getUri(source), guide.getUri(ast.ast)) then
        return false
    end
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    return source.start <= pos and source.finish >= pos
end

local function checkLocal(ast, word, offset, results)
    local locals = guide.getVisibleLocals(ast.ast, offset)
    for name, source in pairs(locals) do
        if isSameSource(ast, source, offset) then
            goto CONTINUE
        end
        if not matchKey(word, name) then
            goto CONTINUE
        end
        if vm.hasType(source, 'function') then
            buildFunction(results, source, false, {
                label  = name,
                kind   = define.CompletionItemKind.Function,
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
                kind   = define.CompletionItemKind.Variable,
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

local function checkFieldFromFieldToIndex(name, parent, word, start, offset)
    if name:match '^[%a_][%w_]*$' then
        return nil
    end
    local textEdit, additionalTextEdits
    local uri = guide.getUri(parent)
    local text = files.getText(uri)
    local wordStart
    if word == '' then
        wordStart = text:match('()%S', start + 1) or (offset + 1)
    else
        wordStart = offset - #word + 1
    end
    textEdit = {
        start   = wordStart,
        finish  = offset,
        newText = ('[%q]'):format(name),
    }
    local nxt = parent.next
    if nxt then
        local dotStart
        if nxt.type == 'setfield'
        or nxt.type == 'getfield'
        or nxt.type == 'tablefield' then
            dotStart = nxt.dot.start
        elseif nxt.type == 'setmethod'
        or     nxt.type == 'getmethod' then
            dotStart = nxt.colon.start
        end
        if dotStart then
            additionalTextEdits = {
                {
                    start   = dotStart,
                    finish  = dotStart,
                    newText = '',
                }
            }
        end
    else
        if config.config.runtime.version == 'Lua 5.1'
        or config.config.runtime.version == 'LuaJIT' then
            textEdit.newText = '_G' .. textEdit.newText
        else
            textEdit.newText = '_ENV' .. textEdit.newText
        end
    end
    return textEdit, additionalTextEdits
end

local function checkFieldThen(name, src, word, start, offset, parent, oop, results)
    local value = guide.getObjectValue(src) or src
    local kind = define.CompletionItemKind.Field
    if value.type == 'function' then
        if oop then
            kind = define.CompletionItemKind.Method
        else
            kind = define.CompletionItemKind.Function
        end
        buildFunction(results, src, oop, {
            label      = name,
            kind       = kind,
            deprecated = value.deprecated,
            id         = stack(function ()
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
        kind = define.CompletionItemKind.Enum
    end
    local textEdit, additionalTextEdits
    if parent.next and parent.next.index then
        local str = parent.next.index
        textEdit = {
            start   = str.start + #str[2],
            finish  = offset,
            newText = name,
        }
    else
        textEdit, additionalTextEdits = checkFieldFromFieldToIndex(name, parent, word, start, offset)
    end
    results[#results+1] = {
        label      = name,
        kind       = kind,
        textEdit   = textEdit,
        additionalTextEdits = additionalTextEdits,
        id         = stack(function ()
            return {
                detail      = buildDetail(src),
                description = buildDesc(src),
            }
        end)
    }
end

local function checkField(ast, word, start, offset, parent, oop, results)
    local fields = {}
    for _, src in ipairs(vm.getFields(parent, 'deep')) do
        if src.type == 'library' then
            if src.name:sub(1, 1) == '@' then
                goto CONTINUE
            end
        end
        local key = vm.getKeyName(src)
        if not key or key:sub(1, 1) ~= 's' then
            goto CONTINUE
        end
        if isSameSource(ast, src, start) then
            goto CONTINUE
        end
        local name = key:sub(3)
        if not matchKey(word, name) then
            goto CONTINUE
        end
        local last = fields[name]
        if not last then
            fields[name] = src
            goto CONTINUE
        end
        if src.type == 'tablefield'
        or src.type == 'setfield'
        or src.type == 'tableindex'
        or src.type == 'setindex'
        or src.type == 'setmethod' then
            fields[name] = src
            goto CONTINUE
        end
        ::CONTINUE::
    end
    for name, src in util.sortPairs(fields) do
        checkFieldThen(name, src, word, start, offset, parent, oop, results)
    end
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
                kind  = define.CompletionItemKind.Property,
            }
        end
    end)
end

local function checkCommon(word, text, offset, results)
    local used = {}
    for _, result in ipairs(results) do
        used[result.label] = true
    end
    for _, data in ipairs(keyWordMap) do
        used[data[1]] = true
    end
    for str, pos in text:gmatch '([%a_][%w_]*)()' do
        if not used[str] and pos - 1 ~= offset then
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

local function isInString(ast, offset)
    return guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'string' then
            return true
        end
    end)
end

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
                        kind  = define.CompletionItemKind.Keyword,
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

local function isAfterLocal(text, start)
    local pos = skipSpace(text, start-1)
    local word = findWord(text, pos)
    return word == 'local'
end

local function checkUri(ast, text, offset, results)
    local collect = {}
    local myUri = guide.getUri(ast.ast)
    guide.eachSourceContain(ast.ast, offset, function (source)
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
        local lib = vm.getLibrary(func)
        if not lib then
            return
        end
        if     lib.name == 'require' then
            for uri in files.eachFile() do
                uri = files.getOriginUri(uri)
                if files.eq(myUri, uri) then
                    goto CONTINUE
                end
                local path = workspace.getRelativePath(uri)
                local infos = rpath.getVisiblePath(path, config.config.runtime.path)
                for _, info in ipairs(infos) do
                    if matchKey(literal, info.expect) then
                        if not collect[info.expect] then
                            collect[info.expect] = {
                                textEdit = {
                                    start  = source.start + #source[2],
                                    finish = source.finish - #source[2],
                                }
                            }
                        end
                        collect[info.expect][#collect[info.expect]+1] = ([=[* [%s](%s) %s]=]):format(
                            path,
                            uri,
                            lang.script('HOVER_USE_LUA_PATH', info.searcher)
                        )
                    end
                end
                ::CONTINUE::
            end
        elseif lib.name == 'dofile'
        or     lib.name == 'loadfile' then
            for uri in files.eachFile() do
                uri = files.getOriginUri(uri)
                if files.eq(myUri, uri) then
                    goto CONTINUE
                end
                local path = workspace.getRelativePath(uri)
                if matchKey(literal, path) then
                    if not collect[path] then
                        collect[path] = {
                            textEdit = {
                                start  = source.start + #source[2],
                                finish = source.finish - #source[2],
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
    end)
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

local function checkLenPlusOne(ast, text, offset, results)
    guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'getindex'
        or source.type == 'setindex' then
            local _, pos = text:find('%s*%[%s*%#', source.node.finish)
            if not pos then
                return
            end
            local nodeText = text:sub(source.node.start, source.node.finish)
            local writingText = trim(text:sub(pos + 1, offset - 1)) or ''
            if not matchKey(writingText, nodeText) then
                return
            end
            if source.parent == guide.getParentBlock(source) then
                -- state
                local label = text:match('%#[ \t]*', pos) .. nodeText .. '+1'
                local eq = text:find('^%s*%]?%s*%=', source.finish)
                local newText = label .. ']'
                if not eq then
                    newText = newText .. ' = '
                end
                results[#results+1] = {
                    label    = label,
                    kind     = define.CompletionItemKind.Snippet,
                    textEdit = {
                        start   = pos,
                        finish  = source.finish,
                        newText = newText,
                    },
                }
            else
                -- exp
                local label = text:match('%#[ \t]*', pos) .. nodeText
                local newText = label .. ']'
                results[#results+1] = {
                    label    = label,
                    kind     = define.CompletionItemKind.Snippet,
                    textEdit = {
                        start   = pos,
                        finish  = source.finish,
                        newText = newText,
                    },
                }
            end
        end
    end)
end

local function isFuncArg(ast, offset)
    return guide.eachSourceContain(ast.ast, offset, function (source)
        if source.type == 'funcargs' then
            return true
        end
    end)
end

local function trySpecial(ast, text, offset, results)
    if isInString(ast, offset) then
        checkUri(ast, text, offset, results)
        return
    end
    -- x[#x+1]
    checkLenPlusOne(ast, text, offset, results)
end

local function tryIndex(ast, text, offset, results)
    local parent, oop = findParentInStringIndex(ast, text, offset)
    if not parent then
        return
    end
    local word = parent.next.index[1]
    checkField(ast, word, offset, offset, parent, oop, results)
end

local function tryWord(ast, text, offset, results)
    local finish = skipSpace(text, offset)
    local word, start = findWord(text, finish)
    if not word then
        return nil
    end
    local hasSpace = finish ~= offset
    if isInString(ast, offset) then
    else
        local parent, oop = findParent(ast, text, start - 1)
        if parent then
            if not hasSpace then
                checkField(ast, word, start, offset, parent, oop, results)
            end
        elseif isFuncArg(ast, offset) then
            checkProvideLocal(ast, word, start, results)
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
                    local env = guide.getENV(ast.ast, start)
                    checkField(ast, word, start, offset, env, false, results)
                end
            end
        end
        if not hasSpace then
            checkCommon(word, text, offset, results)
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
            checkField(ast, '', start, offset, parent, oop, results)
        end
    end
end

local function getCallEnums(source, index)
    if source.type == 'library' and source.value.type == 'function' then
        local func = source.value
        if not func then
            return nil
        end
        if not func.args then
            return nil
        end
        if not func.enums then
            return nil
        end
        local arg = func.args[index]
        if not arg then
            return nil
        end
        local argName = arg.name
        if not argName then
            return nil
        end
        local enums = {}
        for _, enum in ipairs(func.enums) do
            if enum.name == argName then
                enums[#enums+1] = {
                    label       = enum.enum,
                    description = enum.description,
                    kind        = define.CompletionItemKind.EnumMember,
                }
            end
        end
        return enums
    end
end

local function tryLabelInString(label, arg)
    if not arg or arg.type ~= 'string' then
        return label
    end
    local str = parser:grammar(label, 'String')
    if not str then
        return label
    end
    if not matchKey(arg[1], str[1]) then
        return nil
    end
    return util.viewString(str[1], arg[2])
end

local function mergeEnums(a, b, text, arg)
    local mark = {}
    for _, enum in ipairs(a) do
        mark[enum.label] = true
    end
    for _, enum in ipairs(b) do
        local label = tryLabelInString(enum.label, arg)
        if label and not mark[label] then
            mark[label] = true
            local result = {
                label       = label,
                kind        = define.CompletionItemKind.EnumMember,
                description = enum.description,
                textEdit    = arg and {
                    start   = arg.start,
                    finish  = arg.finish,
                    newText = label,
                },
            }
            a[#a+1] = result
        end
    end
end

local function findCall(ast, text, offset)
    local call
    guide.eachSourceContain(ast.ast, offset, function (src)
        if src.type == 'call' then
            if not call or call.start < src.start then
                call = src
            end
        end
    end)
    return call
end

local function getCallArgInfo(call, text, offset)
    if not call.args then
        return 1, nil
    end
    for index, arg in ipairs(call.args) do
        if arg.start <= offset and arg.finish >= offset then
            return index, arg
        end
    end
    return #call.args + 1, nil
end

local function tryCallArg(ast, text, offset, results)
    local call = findCall(ast, text, offset)
    if not call then
        return
    end
    local myResults = {}
    local argIndex, arg = getCallArgInfo(call, text, offset)
    local defs = vm.getDefs(call.node, 'deep')
    for _, def in ipairs(defs) do
        local enums = getCallEnums(def, argIndex)
        if enums then
            mergeEnums(myResults, enums, text, arg)
        end
    end
    for _, enum in ipairs(myResults) do
        results[#results+1] = enum
    end
end

local function completion(uri, offset)
    local ast = files.getAst(uri)
    local text = files.getText(uri)
    local results = {}
    clearStack()
    vm.setSearchLevel(3)
    if ast then
        trySpecial(ast, text, offset, results)
        tryWord(ast, text, offset, results)
        tryIndex(ast, text, offset, results)
        trySymbol(ast, text, offset, results)
        tryCallArg(ast, text, offset, results)
    else
        local word = findWord(text, offset)
        if word then
            checkCommon(word, text, offset, results)
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
