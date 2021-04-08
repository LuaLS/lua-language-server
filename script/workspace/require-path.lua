local platform = require 'bee.platform'
local files    = require 'files'
local furi     = require 'file-uri'
local workspace = require "workspace"
local m = {}

m.cache = {}

--- `aaa/bbb/ccc.lua` 与 `?.lua` 将返回 `aaa.bbb.cccc`
local function getOnePath(path, searcher)
    local stemPath     = path
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\]+', '.')
    local stemSearcher = searcher
                        : gsub('%.[^%.]+$', '')
                        : gsub('[/\\]+', '.')
    local start        = stemSearcher:match '()%?' or 1
    for pos = start, #stemPath do
        local word = stemPath:sub(start, pos)
        local newSearcher = stemSearcher:gsub('%?', (word:gsub('%%', '%%%%')))
        if files.eq(newSearcher, stemPath) then
            return word
        end
    end
    return nil
end

function m.getVisiblePath(path, searchers, strict)
    path = path:gsub('^[/\\]+', '')
    local uri = furi.encode(path)
    local libraryPath = files.getLibraryPath(uri)
    if not m.cache[path] then
        local result = {}
        m.cache[path] = result
        if libraryPath then
            libraryPath = libraryPath:gsub('^[/\\]+', '')
        end
        for _, searcher in ipairs(searchers) do
            local isAbsolute = searcher:match '^[/\\]'
                            or searcher:match '^%a+%:'
            local cutedPath = path
            local head
            local pos = 1
            if not isAbsolute then
                if libraryPath then
                    pos = #libraryPath + 2
                else
                    path = workspace.getRelativePath(uri)
                end
            end
            repeat
                cutedPath = path:sub(pos)
                head = path:sub(1, pos - 1)
                pos = path:match('[/\\]+()', pos)
                if platform.OS == 'Windows' then
                    searcher = searcher :gsub('[/\\]+', '\\')
                                        :gsub('^[/\\]+', '')
                else
                    searcher = searcher :gsub('[/\\]+', '/')
                                        :gsub('^[/\\]+', '')
                end
                local expect = getOnePath(cutedPath, searcher)
                if expect then
                    local mySearcher = searcher
                    if head then
                        mySearcher = head .. searcher
                    end
                    result[#result+1] = {
                        searcher = mySearcher,
                        expect   = expect,
                    }
                end
            until not pos or strict
        end
    end
    return m.cache[path]
end

function m.flush()
    m.cache = {}
end

files.watch(function (ev)
    if ev == 'create'
    or ev == 'remove' then
        m.flush()
    end
end)

return m
