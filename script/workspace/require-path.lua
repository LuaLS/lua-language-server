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
        if newSearcher == stemPath then
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
        local pos = 1
        if libraryPath then
            libraryPath = libraryPath:gsub('^[/\\]+', '')
            pos = #libraryPath + 2
        else
            path = workspace.getRelativePath(uri)
        end
        repeat
            local cutedPath = path:sub(pos)
            local head
            if pos > 1 then
                head = path:sub(1, pos - 1)
            end
            pos = path:match('[/\\]+()', pos)
            for _, searcher in ipairs(searchers) do
                if platform.OS == 'Windows' then
                    searcher = searcher :gsub('[/\\]+', '\\')
                                        :gsub('^[/\\]+', '')
                else
                    searcher = searcher :gsub('[/\\]+', '/')
                                        :gsub('^[/\\]+', '')
                end
                local expect = getOnePath(cutedPath, searcher)
                if expect then
                    if head then
                        searcher = head .. searcher
                    end
                    result[#result+1] = {
                        searcher = searcher,
                        expect   = expect,
                    }
                end
            end
        until not pos or strict
    end
    return m.cache[path]
end

function m.flush()
    m.cache = {}
end

return m
