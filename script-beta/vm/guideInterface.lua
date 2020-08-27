local vm    = require 'vm.vm'
local files = require 'files'
local ws    = require 'workspace'
local guide = require 'parser.guide'
local await = require 'await'

local m = {}

function m.searchFileReturn(results, ast, index)
    local returns = ast.returns
    if not returns then
        return
    end
    for _, ret in ipairs(returns) do
        local exp = ret[index]
        if exp then
            vm.mergeResults(results, { exp })
        end
    end
end

function m.require(args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return nil
    end
    local results = {}
    local myUri = guide.getRoot(args[1]).uri
    local uris = ws.findUrisByRequirePath(reqName, true)
    for _, uri in ipairs(uris) do
        if not files.eq(myUri, uri) then
            local ast = files.getAst(uri)
            if ast then
                m.searchFileReturn(results, ast.ast, index)
            end
        end
    end
    return results
end

function m.dofile(args, index)
    local reqName = args[1] and args[1][1]
    if not reqName then
        return
    end
    local results = {}
    local myUri = guide.getRoot(args[1]).uri
    local uris = ws.findUrisByFilePath(reqName, true)
    for _, uri in ipairs(uris) do
        if not files.eq(myUri, uri) then
            local ast = files.getAst(uri)
            if ast then
                m.searchFileReturn(results, ast.ast, index)
            end
        end
    end
    return results
end

vm.interface = {}

-- 向前寻找引用的层数限制，一般情况下都为0
-- 在自动完成/漂浮提示等情况时设置为5（需要清空缓存）
-- 在查找引用时设置为10（需要清空缓存）
vm.interface.searchLevel = 0

function vm.interface.call(func, args, index)
    await.delay()
    if func.special == 'require' and index == 1 then
        return m.require(args, index)
    end
    if func.special == 'dofile' then
        return m.dofile(args, index)
    end
end

function vm.interface.global(name)
    await.delay()
    return vm.getGlobals(name)
end

function vm.interface.link(uri)
    await.delay()
    return vm.getLinksTo(uri)
end

function vm.interface.cache(source, mode)
    await.delay()
    local cache = vm.getCache('cache')
    if not cache[mode] then
        cache[mode] = {}
    end
    local sourceCache = cache[mode][source]
    if sourceCache then
        return sourceCache
    end
    sourceCache = {}
    cache[mode][source] = sourceCache
    return nil, function (results)
        for i = 1, #results do
            sourceCache[i] = results[i]
        end
    end
end

function vm.interface.library(source)
    await.delay()
    return vm.getLibrary(source)
end

function vm.setSearchLevel(n)
    -- 只有在搜索等级由低变高时，才需要清空缓存
    if n > vm.interface.searchLevel then
        --vm.flushCache()
    end
    vm.interface.searchLevel = n
end
