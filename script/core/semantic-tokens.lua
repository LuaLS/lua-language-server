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

local isEnhanced = config.get 'Lua.color.mode' == 'SemanticEnhanced'

local Care = {}
Care['getglobal'] = function (source, results)
    local isLib = vm.isGlobalLibraryName(source[1])
    local isFunc = false
    local value = source.value

    if value and value.type == 'function' then
        isFunc = true
    elseif source.parent.type == 'call' then
        isFunc = true
    elseif isEnhanced then
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
end
Care['setglobal'] = Care['getglobal']
Care['getmethod'] = function (source, results)
    local method = source.method
    if method and method.type == 'method' then
        results[#results+1] = {
            start      = method.start,
            finish     = method.finish,
            type       = define.TokenTypes.method,
            modifieres = source.type == 'setmethod' and define.TokenModifiers.declaration or nil,
        }
    end
end
Care['setmethod'] = Care['getmethod']
Care['field'] = function (source, results)
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
    if isEnhanced and infer.hasType(source, 'function') then
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
end
Care['getlocal'] = function (source, results)
    local loc = source.node
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
    -- 2. 对象 | Object
    if  source.parent.type == 'getmethod'
    or  source.parent.type == 'setmethod'
    and source.parent.node == source then
        return
    end
    -- 3. 特殊变量 | Special variable
    if source[1] == '_ENV'
    or source[1] == 'self' then
        return
    end
    -- 4. 函数的参数 | Function parameters
    if loc.parent and loc.parent.type == 'funcargs' then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.parameter,
            modifieres = define.TokenModifiers.declaration,
        }
        return
    end
    -- 5. References to other functions
    if isEnhanced and infer.hasType(loc, 'function') then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes['function'],
            modifieres = source.type == 'setlocal' and define.TokenModifiers.declaration or nil,
        }
        return
    end
    -- 6. Class declaration
    if isEnhanced then
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
                    modifieres = define.TokenModifiers.static,
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
    local isLocal = loc.parent ~= guide.getRoot(loc)
    -- 8. 其他 | Other
    results[#results+1] = {
        start      = source.start,
        finish     = source.finish,
        type       = define.TokenTypes.variable,
        modifieres = isLocal and define.TokenModifiers['local'] or nil,
    }
end
Care['setlocal'] = Care['getlocal']
Care['local'] = function (source, results) -- Local declaration, i.e. "local x", "local y = z", or "local function() end"
    if source[1] == '_ENV'
    or source[1] == 'self' then
        return
    end
    if source.parent and source.parent.type == 'funcargs' then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.parameter,
            modifieres = define.TokenModifiers.declaration,
        }
        return
    end
    if source.value then
        local isFunction = false

        if isEnhanced then
            isFunction = source.value.type == 'function' or infer.hasType(source.value, 'function')
        else
            isFunction = source.value.type == 'function'
        end

        if isFunction then
            -- Function declaration, either a new one or an alias for another one
            results[#results+1] = {
                start      = source.start,
                finish     = source.finish,
                type       = define.TokenTypes['function'],
                modifieres = define.TokenModifiers.declaration,
            }
            return
        end
    end
    if source.value and source.value.type == 'table' and source.bindDocs then
        for _, doc in ipairs(source.bindDocs) do
            if doc.type == "doc.class" then
                -- Class declaration (explicit)
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.class,
                    modifieres = define.TokenModifiers.declaration,
                }
                return
            end
        end
    end
    if source.attrs then
        for _, attr in ipairs(source.attrs) do
            local name = attr[1]
            if name == 'const' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.variable,
                    modifieres = define.TokenModifiers.declaration | define.TokenModifiers.static,
                }
                return
            elseif name == 'close' then
                results[#results+1] = {
                    start      = source.start,
                    finish     = source.finish,
                    type       = define.TokenTypes.variable,
                    modifieres = define.TokenModifiers.declaration | define.TokenModifiers.abstract,
                }
                return
            end
        end
    end

    local isLocal = source.parent ~= guide.getRoot(source)
    local modifiers = define.TokenModifiers.declaration

    if isLocal then
        modifiers = modifiers | define.TokenModifiers.definition
    end

    results[#results+1] = {
        start      = source.start,
        finish     = source.finish,
        type       = define.TokenTypes.variable,
        modifieres = modifiers,
    }
end
Care['doc.return.name'] = function (source, results)
    results[#results+1] = {
        start  = source.start,
        finish = source.finish,
        type   = define.TokenTypes.parameter,
    }
end
Care['doc.tailcomment'] = function (source, results)
    results[#results+1] = {
        start  = source.start,
        finish = source.finish,
        type   = define.TokenTypes.comment,
    }
end
Care['doc.type.name'] = function (source, results)
    if source.typeGeneric then
        results[#results+1] = {
            start  = source.start,
            finish = source.finish,
            type   = define.TokenTypes.macro,
        }
    end
end

Care['nonstandardSymbol.comment'] = function (source, results)
    results[#results+1] = {
        start  = source.start,
        finish = source.finish,
        type   = define.TokenTypes.comment,
    }
end
Care['nonstandardSymbol.continue'] = function (source, results)
    results[#results+1] = {
        start  = source.start,
        finish = source.finish,
        type   = define.TokenTypes.keyword,
    }
end

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

config.watch(function (key, value)
    if key == 'Lua.color.mode' then
        isEnhanced = value == 'SemanticEnhanced'
    end
end)

---@async
return function (uri, start, finish)
    local state = files.getState(uri)
    local text  = files.getText(uri)
    if not state then
        return nil
    end

    local results = {}
    guide.eachSourceBetween(state.ast, start, finish, function (source) ---@async
        local method = Care[source.type]
        if not method then
            return
        end
        method(source, results)
        await.delay()
    end)

    for _, comm in ipairs(state.comms) do
        if comm.type == 'comment.cshort' then
            results[#results+1] = {
                start  = comm.start,
                finish = comm.finish,
                type   = define.TokenTypes.comment,
            }
        end
    end

    table.sort(results, function (a, b)
        return a.start < b.start
    end)

    local tokens = buildTokens(uri, results)

    return tokens
end
