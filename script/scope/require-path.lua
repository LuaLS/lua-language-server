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
---@return Uri[] uris
---@return string[] hitSearchers 每个 uri 命中的搜索器模板，与 uris 一一对应
function Scope:searchFiles(modname, suri)
    if type(modname) ~= 'string' then
        return {}, {}
    end

    local configUri = suri or self.uri or ''
    local searchers = self.config:get(configUri, 'Lua.runtime.path')
    local strict    = self.config:get(configUri, 'Lua.runtime.pathStrict')
    local separator = self.config:get(configUri, 'Lua.completion.requireSeparator')

    local path = modname:gsub('%' .. separator, '/')

    local results      = {}
    local hitSearchers = {}
    local seen         = {}

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
                        hitSearchers[#hitSearchers+1] = searcher
                        seen[uri] = true
                    end
                end
            end
        end
    end

    if suri then
        -- 按距离排序，同时保持 hitSearchers 与 uris 一一对应
        local order = {}
        for i = 1, #results do
            order[i] = i
        end
        table.sort(order, function (a, b)
            local da = getDistance(suri, results[a])
            local db = getDistance(suri, results[b])
            if da ~= db then
                return da < db
            end
            return results[a] < results[b]
        end)
        local sortedResults  = {}
        local sortedSearchers = {}
        for i, idx in ipairs(order) do
            sortedResults[i]  = results[idx]
            sortedSearchers[i] = hitSearchers[idx]
        end
        results      = sortedResults
        hitSearchers = sortedSearchers
    end

    return results, hitSearchers
end

--- 从文件路径 + 搜索器反向推导可能的 require 名称
---@param path string 文件路径（已解码，相对 workspace root）
---@param searcher string 搜索器模板（如 `?.lua`、`?/init.lua`）
---@param configUri? Uri 读取配置的 uri
---@param stemSearcher? string 预计算的 stemSearcher（调用方批量预计算可省重复 gsub）
---@return string? name
function Scope:getRequireNameByPath(path, searcher, configUri, stemSearcher)
    local separator = self.config:get(configUri or self.uri or '', 'Lua.completion.requireSeparator')
    local stemPath = path
        : gsub('%.[^%.]+$', '')          -- 去掉扩展名
        : gsub('[/\\%.]+', separator)  -- 路径/点 转分隔符
    stemSearcher = stemSearcher or (searcher
        : gsub('%.[^%.]+$', '')          -- 去掉扩展名
        : gsub('[/\\]+', separator))   -- 路径 转分隔符
    local start = stemSearcher:match '()%?' or 1
    if stemPath:sub(1, start - 1) ~= stemSearcher:sub(1, start - 1) then
        return nil
    end
    for pos = #stemPath, start, -1 do
        local word = stemPath:sub(start, pos)
        local newSearcher = stemSearcher:gsub('%?', (word:gsub('%%', '%%%%')))
        if newSearcher == stemPath then
            return word
        end
    end
    return nil
end

--- 纯计算：从文件 uri 反向推导它可能被 require 的名称及命中搜索器。
--- pathStrict=false 时在相对 root 路径上多级尝试，返回所有可能的 require 名。
---@param uri Uri 文件 uri
---@param configUri Uri 读取配置的 uri
---@param searchers string[]
---@param strict boolean
---@param separator string
---@param stemSearchers? string[] 预计算的 stemSearcher，缺省时内部计算
---@return {name: string, searcher: string}[] results
function Scope:computeVisiblePath(uri, configUri, searchers, strict, separator, stemSearchers)
    local path = ls.uri.decode(uri):gsub('\\', '/')
    local rel = self:getRelativePath(uri)
    if rel then
        path = rel:gsub('\\', '/')
    end

    if not stemSearchers then
        stemSearchers = {}
        for i, searcher in ipairs(searchers) do
            stemSearchers[i] = searcher
                : gsub('%.[^%.]+$', '')
                : gsub('[/\\]+', separator)
        end
    end

    local results = {}
    local seen    = {}

    for i, searcher in ipairs(searchers) do
        local pos = 1
        repeat
            local cutedPath = path:sub(pos)
            local head      = path:sub(1, pos - 1)
            pos = path:match('[/\\]+()', pos)
            local name = self:getRequireNameByPath(cutedPath, searcher, configUri, stemSearchers[i])
            if name then
                local mySearcher = searcher
                if head ~= '' then
                    mySearcher = head .. searcher
                end
                if not seen[name] then
                    seen[name] = true
                    results[#results+1] = {
                        name     = name,
                        searcher = mySearcher,
                    }
                end
            end
        until not pos or strict
    end

    return results
end

--- 从文件 uri 反向推导它可能被 require 的名称及命中搜索器。
--- 结果按 uri 缓存；配置指纹变化或 flushCache（文件集变更）时自动重建
---@param uri Uri 文件 uri
---@param suri? Uri 当前文件 uri，用于读取配置
---@return {name: string, searcher: string}[] results
function Scope:getVisiblePath(uri, suri)
    local configUri = suri or self.uri or ''

    local searchers = self.config:get(configUri, 'Lua.runtime.path')
    local strict    = self.config:get(configUri, 'Lua.runtime.pathStrict')
    local separator = self.config:get(configUri, 'Lua.completion.requireSeparator')

    local cache = self.visiblePathCache
    local fingerprint = table.concat(searchers, '\0') .. '\0' .. tostring(strict) .. '\0' .. separator
    if cache.fingerprint ~= fingerprint then
        cache.fingerprint = fingerprint
        cache.data = {}
    end
    local data = cache.data
    local cached = data[uri]
    if cached then
        return cached
    end

    local stemSearchers = {}
    for i, searcher in ipairs(searchers) do
        stemSearchers[i] = searcher
            : gsub('%.[^%.]+$', '')
            : gsub('[/\\]+', separator)
    end

    local results = self:computeVisiblePath(uri, configUri, searchers, strict, separator, stemSearchers)
    data[uri] = results
    return results
end

--- 反向推导缓存：记录上次配置指纹与对应结果。
--- 注册为 __getter，scope:flushCache()（文件集变更）时自动清除；
--- 配置指纹变化时整体重建（只保留一份）
---@type {fingerprint: string?, data: table<Uri, {name: string, searcher: string}[]>}
Scope.visiblePathCache = nil

Scope.__getter.visiblePathCache = function (self)
    return { data = {} }, true
end

--- 根据已输入的部分 require 名，找出所有匹配的文件路径及命中搜索器。
--- 遍历所有文件，反向推导其可能的 require 名称，再做前缀匹配（大小写不敏感）。
--- 配置读取与指纹计算仅做一次，逐文件直接查 getVisiblePath 缓存。
---@param partial string 已输入的 require 名（部分）
---@param suri? Uri 当前文件 uri，用于排除自身并读取配置
---@return {name: string, uri: Uri, searcher: string}[] results
function Scope:searchFilesByPartial(partial, suri)
    if type(partial) ~= 'string' then
        return {}
    end

    local configUri = suri or self.uri or ''
    local searchers = self.config:get(configUri, 'Lua.runtime.path')
    local strict    = self.config:get(configUri, 'Lua.runtime.pathStrict')
    local separator = self.config:get(configUri, 'Lua.completion.requireSeparator')
    local cache = self.visiblePathCache
    local fingerprint = table.concat(searchers, '\0') .. '\0' .. tostring(strict) .. '\0' .. separator
    if cache.fingerprint ~= fingerprint then
        cache.fingerprint = fingerprint
        cache.data = {}
    end
    local data = cache.data

    local stemSearchers = {}
    for i, searcher in ipairs(searchers) do
        stemSearchers[i] = searcher
            : gsub('%.[^%.]+$', '')
            : gsub('[/\\]+', separator)
    end

    local lowerPartial = partial:lower()
    local results = {}
    local seen    = {}

    for _, root in ipairs(self.roots) do
        for uri in pairs(root.uriSet) do
            if uri ~= suri then
                local infos = data[uri]
                if not infos then
                    infos = self:computeVisiblePath(uri, configUri, searchers, strict, separator, stemSearchers)
                    data[uri] = infos
                end
                for _, info in ipairs(infos) do
                    if info.name:lower():sub(1, #lowerPartial) == lowerPartial then
                        if not seen[info.name] then
                            seen[info.name] = true
                            results[#results+1] = {
                                name     = info.name,
                                uri      = uri,
                                searcher = info.searcher,
                            }
                        end
                    end
                end
            end
        end
    end

    table.sort(results, function (a, b)
        return a.name < b.name
    end)

    return results
end
