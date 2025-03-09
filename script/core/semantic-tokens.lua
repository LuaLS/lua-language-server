local files          = require 'files'
local await          = require 'await'
local define         = require 'proto.define'
local vm             = require 'vm'
local util           = require 'utility'
local guide          = require 'parser.guide'
local converter      = require 'proto.converter'
local config         = require 'config'
local linkedTable    = require 'linked-table'
local client         = require 'client'

local Care = util.switch()
    : case 'getglobal'
    : case 'setglobal'
    : call(function (source, options, results)
        if not options.variable then
            return
        end

        local name = source[1]
        local isLib = options.libGlobals[name]
        if isLib == nil then
            isLib = false
            local global = vm.getGlobal('variable', name)
            if global then
                local uri = guide.getUri(source)
                for _, set in ipairs(global:getSets(uri)) do
                    if vm.isMetaFile(guide.getUri(set)) then
                        isLib = true
                        break
                    end
                end
            end
            options.libGlobals[name] = isLib
        end
        local isFunc = vm.getInfer(source):hasFunction(guide.getUri(source))

        local type = isFunc and define.TokenTypes['function'] or define.TokenTypes.variable
        local modifier = isLib and define.TokenModifiers.defaultLibrary or define.TokenModifiers.global

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
        if not options.variable then
            return
        end
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
        if not options.variable then
            return
        end
        if source.parent then
            if source.parent.type == 'tablefield' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.property,
                }
                return
            end
            local value = source.parent.value
            if value and value.type == 'function' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.method,
                }
                return
            end
        end
        if vm.getInfer(source):hasFunction(guide.getUri(source)) then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.method,
            }
            return
        end
        if source.parent.parent.type == 'call' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.method,
            }
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.property,
        }
    end)
    : case 'local'
    : case 'self'
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, options, results)
        if options.keyword then
            if source.locPos then
                results[#results+1] = {
                    start      = source.locPos,
                    finish     = source.locPos + #'local',
                    type       = define.TokenTypes.keyword,
                    modifieres = define.TokenModifiers.declaration,
                }
            end
            if source.attrs then
                for _, attr in ipairs(source.attrs) do
                    results[#results+1] = {
                        start      = attr.start,
                        finish     = attr.finish,
                        type       = define.TokenTypes.typeParameter,
                    }
                end
            end
        end
        if not options.variable then
            return
        end
        local loc = source.node or source
        local uri = guide.getUri(loc)
        -- 1. 值为函数的局部变量 | Local variable whose value is a function
        if vm.getInfer(source):hasFunction(uri) then
            if source.type == 'local' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes['function'],
                    modifieres = define.TokenModifiers.declaration,
                }
            else
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes['function'],
                }
            end
            return
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
        if loc.parent and loc.parent.type == 'funcargs' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.parameter,
                modifieres = loc == source and define.TokenModifiers.declaration or nil,
            }
            return
        end
        -- 5. Class declaration
            -- only search this local
        if loc.bindDocs then
            local isParam = source.parent.type == 'funcargs'
                         or source.parent.type == 'in'
            if not isParam then
                for _, doc in ipairs(loc.bindDocs) do
                    if doc.type == 'doc.class' then
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
        -- 6. References to other functions
        if vm.getInfer(loc):hasFunction(guide.getUri(source)) then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes['function'],
                modifieres = guide.isAssign(source) and define.TokenModifiers.declaration or nil,
            }
            return
        end
        -- 7. const 变量 | Const variable
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
        if not options.keyword then
            return
        end
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
        if not options.keyword then
            return
        end
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
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #'return',
            type       = define.TokenTypes.keyword,
        }
    end)
    : case 'break'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #'break',
            type       = define.TokenTypes.keyword,
        }
    end)
    : case 'goto'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.keyStart,
            finish     = source.keyStart + #'goto',
            type       = define.TokenTypes.keyword,
        }
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.struct,
        }
    end)
    : case 'label'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.struct,
            modifieres = define.TokenModifiers.declaration,
        }
    end)
    : case 'binary'
    : case 'unary'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.op.start,
            finish     = source.op.finish,
            type       = define.TokenTypes.operator,
        }
    end)
    : case 'boolean'
    : case 'nil'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.keyword,
            modifieres = define.TokenModifiers.readonly,
        }
    end)
    : case 'string'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
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
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.number,
            modifieres = define.TokenModifiers.static,
        }
    end)
    : case 'number'
    : call(function (source, options, results)
        if not options.keyword then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.number,
        }
    end)
    : case 'doc.class.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.class,
            modifieres = define.TokenModifiers.declaration,
        }
    end)
    : case 'doc.extends.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.class,
        }
    end)
    : case 'doc.type.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        if source.typeGeneric then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.type,
                modifieres = define.TokenModifiers.modification,
            }
        elseif source[1] == 'self' then
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes.type,
                modifieres = define.TokenModifiers.readonly,
            }
        else
            results[#results+1] = {
                start  = source.start,
                finish = source.finish,
                type   = define.TokenTypes.type,
            }
        end
    end)
    : case 'doc.alias.name'
    : case 'doc.enum.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.macro,
        }
    end)
    : case 'doc.param.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.parameter,
        }
    end)
    : case 'doc.field'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        if source.visible then
            results[#results+1] = {
                start      = source.start,
                finish     = source.start + #source.visible,
                type       = define.TokenTypes.keyword,
            }
        end
    end)
    : case 'doc.field.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.property,
            modifieres = define.TokenModifiers.declaration,
        }
    end)
    : case 'doc.return.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.parameter,
        }
    end)
    : case 'doc.generic.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.type,
            modifieres = define.TokenModifiers.modification,
        }
    end)
    : case 'doc.type.string'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.string,
            modifieres = define.TokenModifiers.static,
        }
    end)
    : case 'doc.type.function'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #'fun',
            type       = define.TokenTypes.keyword,
        }
        if source.async then
            results[#results+1] = {
                start      = source.asyncPos,
                finish     = source.asyncPos + #'async',
                type       = define.TokenTypes.keyword,
                modifieres = define.TokenModifiers.async,
            }
        end
    end)
    : case 'doc.type.table'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #'table',
            type       = define.TokenTypes.type,
        }
    end)
    : case 'doc.type.arg.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.parameter,
            modifieres = define.TokenModifiers.declaration,
        }
    end)
    : case 'doc.version.unit'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.enumMember,
        }
    end)
    : case 'doc.see.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.class,
        }
    end)
    : case 'doc.diagnostic'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.start + #source.mode,
            type       = define.TokenTypes.keyword,
        }
    end)
    : case 'doc.diagnostic.name'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.event,
            modifieres = define.TokenModifiers.static,
        }
    end)
    : case 'doc.module'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.string,
            modifieres = define.TokenModifiers.defaultLibrary,
        }
    end)
    : case 'doc.tailcomment'
    : call(function (source, options, results)
        if not options.annotation then
            return
        end
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.comment,
        }
    end)
    : case 'nonstandardSymbol.comment'
    : call(function (source, _options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.comment,
        }
    end)
    : case 'nonstandardSymbol.continue'
    : call(function (source, _options, results)
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.keyword,
        }
    end)
    : case 'doc.cast.block'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.keyword,
        }
    end)
    : case 'doc.cast.name'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.variable,
        }
    end)
    : case 'doc.type.code'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.string,
            modifieres = define.TokenModifiers.abstract,
        }
    end)
    : case 'doc.operator.name'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.operator,
        }
    end)
    : case 'doc.meta.name'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.namespace,
        }
    end)
    : case 'doc.attr'
    : call(function (source, _options, results)
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.decorator,
        }
    end)

---@param results table
local function buildTokens(results)
    local tokens = {}
    local lastLine = 0
    local lastStartChar = 0
    local index = 0
    for i, source in ipairs(results) do
        local startPos  = source.start
        local finishPos = source.finish
        local line      = startPos.line
        local startChar = startPos.character
        local deltaLine = line - lastLine
        local deltaStartChar
        if deltaLine == 0 then
            deltaStartChar = startChar - lastStartChar
            if deltaStartChar == 0 and i > 1 then
                goto continue
            end
        else
            deltaStartChar = startChar
        end
        lastLine = line
        lastStartChar = startChar
        -- see https://microsoft.github.io/language-server-protocol/specifications/specification-3-16/#textDocument_semanticTokens
        index = index + 1
        local len = index * 5 - 5
        tokens[len + 1] = deltaLine
        tokens[len + 2] = deltaStartChar
        tokens[len + 3] = finishPos.character - startPos.character -- length
        tokens[len + 4] = source.type
        tokens[len + 5] = source.modifieres or 0
        ::continue::
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
        local startPos = converter.packPosition(state, token.start)
        local endPos   = converter.packPosition(state, token.finish)
        if  startPos.line == endPos.line
        and startPos.character == endPos.character then
            goto continue
        end
        if endPos.line == startPos.line
        or client.getAbility 'textDocument.semanticTokens.multilineTokenSupport' then
            new[#new+1] = {
                start      = startPos,
                finish     = endPos,
                type       = token.type,
                modifieres = token.modifieres,
            }
        else
            --LSP规范说客户端不支持token跨行的话，
            --token长度可以超出行的范围，客户端应该
            --将其视为在行的末尾结束。
            --正好可以测试（拷打）一下客户端的实现。
            new[#new+1] = {
                start      = startPos,
                finish     = converter.position(startPos.line, 9999),
                type       = token.type,
                modifieres = token.modifieres,
            }
            for i = startPos.line + 1, endPos.line - 1 do
                new[#new+1] = {
                    start      = converter.position(i, 0),
                    finish     = converter.position(i, 9999),
                    type       = token.type,
                    modifieres = token.modifieres,
                }
            end
            if endPos.character > 0 then
                new[#new+1] = {
                    start      = converter.position(endPos.line, 0),
                    finish     = converter.position(endPos.line, endPos.character),
                    type       = token.type,
                    modifieres = token.modifieres,
                }
            end
        end
        ::continue::
    end

    return new
end

---@async
return function (uri, start, finish)
    local results = {}
    if not config.get(uri, 'Lua.semantic.enable') then
        return results
    end
    local state = files.getState(uri)
    if not state then
        return results
    end

    local options = {
        uri        = uri,
        state      = state,
        text       = files.getText(uri),
        libGlobals = {},
        variable   = config.get(uri, 'Lua.semantic.variable'),
        annotation = config.get(uri, 'Lua.semantic.annotation'),
        keyword    = config.get(uri, 'Lua.semantic.keyword'),
    }

    local n = 0
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
        -- skip virtual source
        if source.virtual then
            return
        end
        Care(source.type, source, options, results)
        n = n + 1
        if n % 100 == 0 then
            await.delay()
        end
    end)

    for _, comm in ipairs(state.comms) do
        -- skip virtual comment
        if comm.virtual then
            return
        end
        if start <= comm.start and comm.finish <= finish then
            -- the same logic as in buildLuaDoc
            local headPos = (comm.type == 'comment.short' and comm.text:match '^%-%s*[@|]()')
                         or (comm.type == 'comment.long'  and comm.text:match '^%s*@()')
            if headPos then
                -- absolute position of `@` symbol
                local startOffset = comm.start + headPos
                if comm.type == 'comment.long' then
                    startOffset = comm.start + headPos + #comm.mark - 2
                end
                results[#results+1] = {
                    start  = comm.start,
                    finish = startOffset,
                    type   = define.TokenTypes.comment,
                }
                results[#results+1] = {
                    start      = startOffset,
                    finish     = startOffset + #comm.text:match('%S*', headPos) + 1,
                    type       = define.TokenTypes.keyword,
                    modifieres = define.TokenModifiers.documentation,
                }
            else
                results[#results+1] = {
                    start  = comm.start,
                    finish = comm.finish,
                    type   = define.TokenTypes.comment,
                }
            end
        end
    end

    if #results == 0 then
        return results
    end

    results = solveMultilineAndOverlapping(state, results)

    local tokens = buildTokens(results)

    return tokens
end
