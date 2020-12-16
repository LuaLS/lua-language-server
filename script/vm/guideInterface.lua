---@type vm
local vm      = require 'vm.vm'
local files   = require 'files'
local ws      = require 'workspace'
local guide   = require 'parser.guide'
local await   = require 'await'
local config  = require 'config'

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
    local reqName = args and args[1] and args[1][1]
    if not reqName then
        return nil
    end
    local results = {}
    local myUri = guide.getUri(args[1])
    local uris = ws.findUrisByRequirePath(reqName)
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
    local myUri = guide.getUri(args[1])
    local uris = ws.findUrisByFilePath(reqName)
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
    if func.special == 'require' and index == 1 then
        await.delay()
        return m.require(args, index)
    end
    if func.special == 'dofile' then
        await.delay()
        return m.dofile(args, index)
    end
end

function vm.interface.global(name)
    await.delay()
    return vm.getGlobals(name)
end

function vm.interface.docType(name)
    await.delay()
    return vm.getDocTypes(name)
end

function vm.interface.link(uri)
    await.delay()
    return vm.getLinksTo(uri)
end

function vm.interface.index(obj)
    return nil
end

function vm.interface.cache()
    await.delay()
    return vm.getCache('cache')
end

function vm.interface.getSearchDepth()
    return config.config.intelliSense.searchDepth
end
