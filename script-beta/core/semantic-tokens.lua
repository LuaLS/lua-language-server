local files          = require 'files'
local guide          = require 'parser.guide'
local await          = require 'await'
local TokenTypes     = require 'define.TokenTypes'
local TokenModifiers = require 'define.TokenModifiers'
local vm             = require 'vm'

local Care = {}
Care['setglobal'] = function (source)
    return {
        start      = source.start,
        finish     = source.finish,
        type       = TokenTypes.namespace,
        modifieres = TokenModifiers.deprecated,
    }
end
Care['getglobal'] = function (source)
    local lib = vm.getLibrary(source, 'simple')
    if lib then
        if source[1] == '_G' then
            return
        else
            return {
                start      = source.start,
                finish     = source.finish,
                type       = TokenTypes.namespace,
                modifieres = TokenModifiers.static,
            }
        end
    else
        return {
            start      = source.start,
            finish     = source.finish,
            type       = TokenTypes.namespace,
            modifieres = TokenModifiers.deprecated,
        }
    end
end

local function buildTokens(results, lines)
    local tokens = {}
    local lastLine = 0
    local lastStartChar = 0
    for i, source in ipairs(results) do
        local row, col = guide.positionOf(lines, source.start)
        local line = row - 1
        local startChar = col - 1
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
    if not ast then
        return nil
    end

    local results = {}
    local index = 0
    guide.eachSource(ast.ast, function (source)
        local method = Care[source.type]
        if not method then
            return
        end
        if source.start > finish or source.finish < start then
            return
        end
        local result = method(source)
        if not result then
            return
        end
        index = index + 1
        results[index] = result
        if index % 100 == 0 then
            await.delay()
        end
    end)

    table.sort(results, function (a, b)
        return a.start < b.start
    end)

    local tokens = buildTokens(results, lines)

    return tokens
end
