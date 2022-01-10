local files          = require 'files'
local searcher       = require 'core.searcher'
local await          = require 'await'
local define         = require 'proto.define'
local vm             = require 'vm'
local util           = require 'utility'
local guide          = require 'parser.guide'
local converter      = require 'proto.converter'
local infer          = require 'core.infer'
local config         = require 'config'
local linkedTable    = require 'linked-table'

local Care = util.switch()
    : case 'getglobal'
    : case 'setglobal'
    : call(function (source, options, results)
        local isLib = vm.isGlobalLibraryName(source[1])
        local isFunc = false
        local value = source.value

        if value and value.type == 'function' then
            isFunc = true
        elseif source.parent.type == 'call' then
            isFunc = true
        elseif options.isEnhanced then
            isFunc = infer.hasType(source, 'function')
        end

        local type = isFunc and define.TokenTypes['function'] or define.TokenTypes.variable
        local modifier = isLib and define.TokenModifiers.defaultLibrary or define.TokenModifiers.static

        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = type,
            modifieres = modifier,
        }
    end)
    : case 'getmethod'
    : case 'setmethod'
    : call(function (source, options, results)
        local method = source.method
        if method and method.type == 'method' then
            results[#results+1] = {
                start      = method.start,
                finish     = method.finish,
                type       = define.TokenTypes.method,
                modifieres = source.type == 'setmethod' and define.TokenModifiers.declaration or nil,
            }
        end
    end)
    : case 'field'
    : call(function (source, options, results)
        local modifiers = 0
        if source.parent and source.parent.type == 'tablefield' then
            modifiers = define.TokenModifiers.declaration
        end
        if source.parent then
            local value = source.parent.value
            if value and value.type == 'function' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.method,
                    modifieres = modifiers,
                }
                return
            end
        end
        if options.isEnhanced and infer.hasType(source, 'function') then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.method,
                modifieres = modifiers,
            }
            return
        end
        if source.parent.parent.type == 'call' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.method,
                modifieres = modifiers,
            }
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.property,
            modifieres = modifiers,
        }
    end)
    : case 'local'
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, options, results)
        if source.locPos then
            results[#results+1] = {
                start      = source.locPos,
                finish     = source.locPos + #'local',
                type       = define.TokenTypes.keyword,
                modifieres = define.TokenModifiers.declaration,
            }
        end
        local loc = source.node or source
        -- 1. 值为函数的局部变量 | Local variable whose value is a function
        if loc.refs then
            for _, ref in ipairs(loc.refs) do
                if ref.value and ref.value.type == 'function' then
                    results[#results+1] = {
                        start      = source.start,
                        finish     = source.finish,
                        type       = define.TokenTypes['function'],
                    }
                    return
                end
            end
        end
        -- 3. 特殊变量 | Special variableif source[1] == '_ENV' then
        if loc[1] == '_ENV' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.variable,
                modifieres = define.TokenModifiers.readonly,
            }
            return
        end
        if loc[1] == 'self' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.variable,
                modifieres = define.TokenModifiers.definition,
            }
            return
        end
        -- 4. 函数的参数 | Function parameters
        if source.parent and source.parent.type == 'funcargs' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.parameter,
                modifieres = define.TokenModifiers.declaration,
            }
            return
        end
        -- 5. References to other functions
        if options.isEnhanced and infer.hasType(loc, 'function') then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes['function'],
                modifieres = source.type == 'setlocal' and define.TokenModifiers.declaration or nil,
            }
            return
        end
        -- 6. Class declaration
        if options.isEnhanced then
            -- search all defs
            for _, def in ipairs(vm.getDefs(source)) do
                if def.bindDocs then
                    for _, doc in ipairs(def.bindDocs) do
                        if doc.type == "doc.class" and doc.bindSources then
                            for _, src in ipairs(doc.bindSources) do
                                if src == def then
                                    results[#results+1] = {
                                        start      = source.start,
                                        finish     = source.finish,
                                        type       = define.TokenTypes.class,
                                    }
                                    return
                                end
                            end
                        end
                    end
                end
            end
        else
            -- only search this local
            if loc.bindDocs then
                for i, doc in ipairs(loc.bindDocs) do
                    if doc.type == "doc.class" and doc.bindSources then
                        for _, src in ipairs(doc.bindSources) do
                            if src == loc then
                                results[#results+1] = {
                                    start      = source.start,
                                    finish     = source.finish,
                                    type       = define.TokenTypes.class,
                                }
                                return
                            end
                        end
                    end
                end
            end
        end
        -- 6. const 变量 | Const variable
        if loc.attrs then
            for _, attr in ipairs(loc.attrs) do
                local name = attr[1]
                if name == 'const' then
                    results[#results+1] = {
                        start      = source.start,
                        finish     = source.finish,
                        type       = define.TokenTypes.variable,
                        modifieres = define.TokenModifiers.readonly,
                    }
                    return
                elseif name == 'close' then
                    results[#results+1] = {
                        start      = source.start,
                        finish     = source.finish,
                        type       = define.TokenTypes.variable,
                        modifieres = define.TokenModifiers.abstract,
                    }
                    return
                end
            end
        end
        -- 7. 函数调用 | Function call
        if  source.parent.type == 'call'
        and source.parent.node == source then
            return
        end
        local mod
        if source.type == 'local' then
            mod = define.TokenModifiers.declaration
        end
        -- 8. 其他 | Other
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.variable,
            modifieres = mod,
        }
    end)
    : case 'function'
    : case 'ifblock'
    : case 'elseifblock'
    : case 'elseblock'
    : case 'do'
    : case 'for'
    : case 'loop'
    : case 'in'
    : case 'while'
    : case 'repeat'
    : call(function (source, options, results)
        local keyword = source.keyword
        if keyword then
            for i = 1, #keyword, 2 do
                results[#results+1] = {
                    start      = keyword[i],
                    finish     = keyword[i + 1],
                    type       = define.TokenTypes.keyword,
                }
            end
        end
    end)
    : case 'if'
    : call(function (source, options, results)
        local offset = guide.positionToOffset(options.state, source.finish)
        if options.text:sub(offset - 2, offset) == 'end' then
            results[#results+1] = {
                start      = source.finish - #'end',
                finish     = source.finish,
                type       = define.TokenTypes.keyword,
            }
        end
    end)
    : case 'return'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #'return',
            type       = define.TokenTypes.keyword,
        }
    end)
    : case 'binary'
    : case 'unary'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.op.start,
            finish     = source.op.finish,
            type       = define.TokenTypes.operator,
        }
    end)
    : case 'boolean'
    : case 'nil'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.keyword,
            modifieres = define.TokenModifiers.readonly,
        }
    end)
    : case 'string'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.string,
        }
        local escs = source.escs
        if escs then
            for i = 1, #escs, 3 do
                local mod
                if escs[i + 2] == 'err' then
                    mod = define.TokenModifiers.deprecated
                else
                    mod = define.TokenModifiers.modification
                end
                results[#results+1] = {
                    start      = escs[i],
                    finish     = escs[i + 1],
                    type       = define.TokenTypes.string,
                    modifieres = mod,
                }
            end
        end
    end)
    : case 'integer'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.number,
            modifieres = define.TokenModifiers.static,
        }
    end)
    : case 'number'
    : call(function (source, options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.number,
        }
    end)
    : case 'doc.return.name'
    : call(function (source, options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.parameter,
        }
    end)
    : case 'doc.tailcomment'
    : call(function (source, options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.comment,
        }
    end)
    : case 'doc.type.name'
    : call(function (source, options, results)
        if source.typeGeneric then
            results[#results+1] = {
                start  = source.start,
                finish = source.finish,
                type   = define.TokenTypes.macro,
            }
        end
    end)
    : case 'nonstandardSymbol.comment'
    : call(function (source, options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.comment,
        }
    end)
    : case 'nonstandardSymbol.continue'
    : call(function (source, options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.keyword,
        }
    end)
    : getMap()

local function buildTokens(uri, results)
    local tokens = {}
    local lastLine = 0
    local lastStartChar = 0
    for i, source in ipairs(results) do
        local startPos  = converter.packPosition(uri, source.start)
        local finishPos = converter.packPosition(uri, source.finish)
        local line      = startPos.line
        local startChar = startPos.character
        local deltaLine = line - lastLine
        local deltaStartChar
        if deltaLine == 0 then
            deltaStartChar = startChar - lastStartChar
        else
            deltaStartChar = startChar
        end
        lastLine = line
        lastStartChar = startChar
        -- see https://microsoft.github.io/language-server-protocol/specifications/specification-3-16/#textDocument_semanticTokens
        local len = i * 5 - 5
        tokens[len + 1] = deltaLine
        tokens[len + 2] = deltaStartChar
        tokens[len + 3] = finishPos.character - startPos.character -- length
        tokens[len + 4] = source.type
        tokens[len + 5] = source.modifieres or 0
    end
    return tokens
end

---@async
local function solveMultilineAndOverlapping(state, results)
    table.sort(results, function (a, b)
        if a.start == b.start then
            return a.finish < b.finish
        else
            return a.start < b.start
        end
    end)

    await.delay()

    local tokens = linkedTable()

    local function findToken(pos)
        for token in tokens:pairs(nil ,true) do
            if token.start <= pos and token.finish >= pos then
                return token
            end
            if token.finish < pos then
                break
            end
        end
        return nil
    end

    for _, current in ipairs(results) do
        local left = findToken(current.start)
        if not left then
            tokens:pushTail(current)
            goto CONTINUE
        end
        local right = findToken(current.finish)
        tokens:pushAfter(current, left)
        tokens:pop(left)
        if left.start < current.start then
            tokens:pushBefore({
                start      = left.start,
                finish     = current.start,
                type       = left.type,
                modifieres = left.modifieres
            }, current)
        end
        if right and right.finish > current.finish then
            tokens:pushAfter({
                start      = current.finish,
                finish     = right.finish,
                type       = right.type,
                modifieres = right.modifieres
            }, current)
        end
        ::CONTINUE::
    end

    await.delay()

    local new = {}
    for token in tokens:pairs() do
        new[#new+1] = token
        local startRow,  startCol  = guide.rowColOf(token.start)
        local finishRow, finishCol = guide.rowColOf(token.finish)
        if finishRow > startRow then
            token.finish = guide.positionOf(startRow, guide.getLineRange(state, startRow))
        end
        for i = startRow + 1, finishRow - 1 do
            new[#new+1] = {
                start      = guide.positionOf(i, 0),
                finish     = guide.positionOf(i, guide.getLineRange(state, i)),
                type       = token.type,
                modifieres = token.modifieres,
            }
        end
        if finishCol > 0 then
            new[#new+1] = {
                start      = guide.positionOf(finishRow, 0),
                finish     = guide.positionOf(finishRow, finishCol),
                type       = token.type,
                modifieres = token.modifieres,
            }
        end
    end

    return new
end

---@async
return function (uri, start, finish)
    if config.get(uri, 'Lua.color.mode') == 'Grammar' then
        return nil
    end
    local state = files.getState(uri)
    if not state then
        return nil
    end

    local options = {
        uri        = uri,
        state      = state,
        text       = files.getText(uri),
        isEnhanced = config.get(uri, 'Lua.color.mode') == 'SemanticEnhanced',
    }

    local results = {}
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
        local method = Care[source.type]
        if not method then
            return
        end
        method(source, options, results)
        await.delay()
    end)

    for _, comm in ipairs(state.comms) do
        results[#results+1] = {
            start  = comm.start,
            finish = comm.finish,
            type   = define.TokenTypes.comment,
        }
    end

    if #results == 0 then
        return nil
    end

    results = solveMultilineAndOverlapping(state, results)

    local tokens = buildTokens(uri, results)

    return tokens
end
