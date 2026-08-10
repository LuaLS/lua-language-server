--- 按 Lua 的 require 解析规则查找文件
--- 规则读取用户配置：Lua.runtime.path / Lua.runtime.pathStrict / Lua.completion.requireSeparator
---@class Scope
local Scope = Class 'Scope'

--- 计算目标文件到当前文件的目录距离（越小越近）
---@param suri Uri 当前文件
---@param uri Uri 目标文件
---@return number
local function getDistance(suri, uri)
    local dir = ls.fs.parent(suri)
    local rel = ls.uri.relativePath(uri, dir)
    if rel then
        -- 在当前目录（或子目录）下
        local depth = 1
        for _ in rel:gmatch('/') do
            depth = depth + 1
        end
        return depth
    end
    -- 不在当前目录下，向上寻找公共目录
    local up = 0
    local cur = dir
    while cur do
        local r = ls.uri.relativePath(uri, cur)
        if r then
            local depth = 1
            for _ in r:gmatch('/') do
                depth = depth + 1
            end
            return up + depth
        end
        local parent = ls.fs.parent(cur)
        if parent == cur then
            break
        end
        cur = parent
        up = up + 1
    end
    return math.huge
end

--- 根据 require 的模块名查找匹配的文件
--- 默认 searcher 为 `?.lua` 与 `?/init.lua`（与 Lua 的 require 规则一致）
---@param modname string
---@param suri? Uri 当前文件 uri，用于排除自身并按距离排序
---@return Uri[]
function Scope:searchFiles(modname, suri)
    if type(modname) ~= 'string' then
        return {}
    end

    local configUri = suri or self.uri or ''
    local searchers = self.config:get(configUri, 'Lua.runtime.path')
    if type(searchers) ~= 'table' then
        searchers = { '?.lua', '?/init.lua' }
    end

    local strict = self.config:get(configUri, 'Lua.runtime.pathStrict')
    if strict == nil then
        strict = false
    end

    local separator = self.config:get(configUri, 'Lua.completion.requireSeparator')
    if type(separator) ~= 'string' then
        separator = '.'
    end

    local path = modname:gsub('%' .. separator, '/')

    local results = {}
    local seen    = {}

    for _, searcher in ipairs(searchers) do
        local escaped = path:gsub('%%', '%%%%')
        local fspath  = searcher:gsub('%?', escaped)
        fspath = fspath:gsub('\\', '/')
        local tail = '/' .. ls.uri.encode(fspath):gsub('^file:[/]*', '')
        for _, root in ipairs(self.roots) do
            for uri in pairs(root.uriSet) do
                if not seen[uri]
                and uri ~= suri
                and ls.util.stringEndWith(uri, tail) then
                    local relative = uri:sub(#root.uri + 1):sub(1, -#tail)
                    if not strict
                    or relative == '/'
                    or relative == '' then
                        results[#results+1] = uri
                        seen[uri] = true
                    end
                end
            end
        end
    end

    if suri then
        table.sort(results, function (a, b)
            local da = getDistance(suri, a)
            local db = getDistance(suri, b)
            if da ~= db then
                return da < db
            end
            return a < b
        end)
    end

    return results
end
