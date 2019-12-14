local vm    = require 'vm.vm'
local guide = require 'parser.guide'
local files = require 'files'

local function checkPath(source, info)
    if source.type == 'goto' then
        return true
    end
    local src = info.source
    local mode = guide.getPath(source, src)
    if not mode then
        return true
    end
    if mode == 'before' then
        return false
    end
    if mode == 'equal' then
        if src.type == 'field'
        or src.type == 'method'
        or src.type == 'local'
        or src.type == 'setglobal' then
            return true
        else
            return false
        end
    end
    return true
end

-- TODO
-- 只搜索本文件中的引用
-- 跨文件时，选确定入口（main的return)，然后递归搜索本文件中的引用
-- 如果类型为setfield等，要确定tbl相同
function vm.eachDef(source, callback)
    local results = {}
    local returns = {}
    local infoMap = {}
    local sourceUri = guide.getRoot(source).uri
    vm.eachRef(source, function (info)
        if info.mode == 'declare'
        or info.mode == 'set' then
            results[#results+1] = info
        end
        if info.mode == 'return' then
            results[#results+1] = info
            local root = guide.getParentBlock(info.source)
            if root.type == 'main' then
                returns[root.uri] = info
            end
        end
        infoMap[info.source] = info
    end)

    local function pushDef(info)
        local res = callback(info)
        if res ~= nil then
            return res
        end
        local value = info.source.value
        local vinfo = infoMap[value]
        if vinfo then
            res = callback(vinfo)
        end
        return res
    end

    local res
    local used = {}
    for _, info in ipairs(results) do
        local src = info.source
        local destUri
        if used[src] then
            goto CONTINUE
        end
        used[src] = true
        destUri = guide.getRoot(src).uri
        -- 如果是同一个文件，则检查位置关系后放行
        if sourceUri == destUri then
            if checkPath(source, info) then
                res = pushDef(info)
            end
            goto CONTINUE
        end
        -- 如果是global或field，则直接放行（因为无法确定顺序）
        if src.type == 'setindex'
        or src.type == 'setfield'
        or src.type == 'setmethod'
        or src.type == 'tablefield'
        or src.type == 'tableindex'
        or src.type == 'setglobal' then
            res = pushDef(info)
            goto CONTINUE
        end
        -- 如果不是同一个文件，则必须在该文件 return 后才放行
        if returns[destUri] then
            res = pushDef(info)
            goto CONTINUE
        end
        ::CONTINUE::
        if res ~= nil then
            return res
        end
    end
end
