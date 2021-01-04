local files          = require 'files'
local guide          = require 'parser.guide'
local await          = require 'await'
local define         = require 'proto.define'
local vm             = require 'vm'
local util           = require 'utility'

local Care = {}
Care['setglobal'] = function (source, results)
    local isLib = vm.isGlobalLibraryName(source[1])
    if not isLib then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.namespace,
            modifieres = define.TokenModifiers.deprecated,
        }
    end
end
Care['getglobal'] = function (source, results)
    local isLib = vm.isGlobalLibraryName(source[1])
    if not isLib then
        results[#results+1] =  {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.namespace,
            modifieres = define.TokenModifiers.deprecated,
        }
    end
end
Care['tablefield'] = function (source, results)
    local field = source.field
    if not field then
        return
    end
    results[#results+1] = {
        start      = field.start,
        finish     = field.finish,
        type       = define.TokenTypes.property,
        modifieres = define.TokenModifiers.declaration,
    }
end
Care['getlocal'] = function (source, results)
    local loc = source.node
    -- 1. 值为函数的局部变量
    local hasFunc
    local node = loc.node
    if node then
        for _, ref in ipairs(node.ref) do
            local def = ref.value
            if def.type == 'function' then
                hasFunc = true
                break
            end
        end
    end
    if hasFunc then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.interface,
            modifieres = define.TokenModifiers.declaration,
        }
        return
    end
    -- 2. 对象
    if  source.parent.type == 'getmethod'
    and source.parent.node == source then
        return
    end
    -- 3. 函数的参数
    if loc.parent and loc.parent.type == 'funcargs' then
        results[#results+1] = {
            start      = source.start,
            finish     = source.finish,
            type       = define.TokenTypes.parameter,
            modifieres = define.TokenModifiers.declaration,
        }
        return
    end
    -- 4. 特殊变量
    if source[1] == '_ENV'
    or source[1] == 'self' then
        return
    end
    -- 5. 函数调用
    if  source.parent.type == 'call'
    and source.parent.node == source then
        return
    end
    -- 6. 其他
    results[#results+1] = {
        start      = source.start,
        finish     = source.finish,
        type       = define.TokenTypes.variable,
    }
end
Care['setlocal'] = Care['getlocal']
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

local function buildTokens(results, text, lines)
    local tokens = {}
    local lastLine = 0
    local lastStartChar = 0
    for i, source in ipairs(results) do
        local row, col = guide.positionOf(lines, source.start)
        local start    = guide.lineRange(lines, row)
        local ucol     = util.utf8Len(text, start, start + col - 1)
        local line = row - 1
        local startChar = ucol - 1
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
        tokens[len + 3] = source.finish - source.start + 1 -- length
        tokens[len + 4] = source.type
        tokens[len + 5] = source.modifieres or 0
    end
    return tokens
end

return function (uri, start, finish)
    local ast   = files.getAst(uri)
    local lines = files.getLines(uri)
    local text  = files.getText(uri)
    if not ast then
        return nil
    end

    local results = {}
    local count = 0
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        local method = Care[source.type]
        if not method then
            return
        end
        method(source, results)
        count = count + 1
        if count % 100 == 0 then
            await.delay()
        end
    end)

    for _, comm in ipairs(ast.comms) do
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

    local tokens = buildTokens(results, text, lines)

    return tokens
end
