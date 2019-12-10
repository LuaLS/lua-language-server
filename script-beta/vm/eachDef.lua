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
    return true
end

function vm.eachDef(source, callback)
    local results = {}
    local valueUris = {}
    local valueInfos = {}
    local sourceUri = guide.getRoot(source).uri
    vm.eachRef(source, function (info)
        if info.mode == 'declare'
        or info.mode == 'set'
        or info.mode == 'return'
        or info.mode == 'value'
        or info.mode == 'library' then
            results[#results+1] = info
            valueInfos[info.source] = info
            local src = info.source
            if info.mode == 'return' then
                local uri = guide.getRoot(src).uri
                valueUris[uri] = info.source
            end
        end
    end)

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
        -- 如果是library，则直接放行
        if src.library then
            res = callback(info)
            goto CONTINUE
        end
        -- 如果是global或field，则直接放行（因为无法确定顺序）
        if src.type == 'setindex'
        or src.type == 'setfield'
        or src.type == 'setmethod'
        or src.type == 'tablefield'
        or src.type == 'tableindex'
        or src.type == 'setglobal' then
            res = callback(info)
            if src.value and valueInfos[src.value] then
                used[src.value] = true
                res = callback(valueInfos[src.value])
            end
            goto CONTINUE
        end
        -- 如果是同一个文件，则检查位置关系后放行
        if sourceUri == destUri then
            if checkPath(source, info) then
                res = callback(info)
            end
            goto CONTINUE
        end
        -- 如果不是同一个文件，则必须在该文件 return 后才放行
        if valueUris[destUri] then
            res = callback(info)
            goto CONTINUE
        end
        ::CONTINUE::
        if res ~= nil then
            return res
        end
    end
end
