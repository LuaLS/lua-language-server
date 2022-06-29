local files   = require 'files'
local guide   = require 'parser.guide'
local vm      = require 'vm'
local define  = require 'proto.define'
local lang    = require 'language'
local await   = require 'await'
local client  = require 'client'

local function isToBeClosed(source)
    if not source.attrs then
        return false
    end
    for _, attr in ipairs(source.attrs) do
        if attr[1] == 'close' then
            return true
        end
    end
    return false
end

---@param source parser.object?
---@return boolean
local function isValidFunction(source)
    if not source then
        return false
    end
    if source.type == 'main' then
        return false
    end
    local parent = source.parent
    if not parent then
        return false
    end
    if  parent.type ~= 'local'
    and parent.type ~= 'setlocal' then
        return false
    end
    if isToBeClosed(parent) then
        return false
    end
    return true
end

---@async
local function collect(ast, white, roots, links)
    ---@async
    guide.eachSourceType(ast, 'function', function (src)
        await.delay()
        if not isValidFunction(src) then
            return
        end
        local loc = src.parent
        if loc.type == 'setlocal' then
            loc = loc.node
        end
        for _, ref in ipairs(loc.ref or {}) do
            if ref.type == 'getlocal' then
                local func = guide.getParentFunction(ref)
                if not func or not isValidFunction(func) or roots[func] then
                    roots[src] = true
                    return
                end
                if not links[func] then
                    links[func] = {}
                end
                links[func][#links[func]+1] = src
            end
        end
        white[src] = true
    end)

    return white, roots, links
end

local function turnBlack(source, black, white, links)
    if black[source] then
        return
    end
    black[source] = true
    white[source] = nil
    for _, link in ipairs(links[source] or {}) do
        turnBlack(link, black, white, links)
    end
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if vm.isMetaFile(uri) then
        return
    end

    local black = {}
    local white = {}
    local roots = {}
    local links = {}

    collect(state.ast, white, roots, links)

    for source in pairs(roots) do
        turnBlack(source, black, white, links)
    end

    for source in pairs(white) do
        if client.isVSCode() then
            callback {
                start   = source.start,
                finish  = source.finish,
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script.DIAG_UNUSED_FUNCTION,
            }
        else
            callback {
                start   = source.keyword[1],
                finish  = source.keyword[2],
                tags    = { define.DiagnosticTag.Unnecessary },
                message = lang.script.DIAG_UNUSED_FUNCTION,
            }
        end
    end
end
