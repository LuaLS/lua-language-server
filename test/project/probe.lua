-- 目标工程探针：按文件/变量名 dump 节点视图与收窄 flow（取代临时往测试里塞调试块）
--   节点视图：--test project.probe --test-project=<dir> --probe-file=<文件名片段> --probe-filter=<key 片段>
--   收窄 flow：--test project.probe --test-project=<dir> --probe-flow=<flow key 片段>
local projectPath = ls.args.TEST_PROJECT
if projectPath == '' or type(projectPath) ~= 'string' then
    return
end

local fileFilter = ls.args.PROBE_FILE
local keyFilter  = ls.args.PROBE_FILTER
local flowFilter = ls.args.PROBE_FLOW

if  (type(fileFilter) ~= 'string' or fileFilter == '')
and (type(flowFilter) ~= 'string' or flowFilter == '') then
    print('用法：--probe-file=<文件名片段> [--probe-filter=<key 片段>] | --probe-flow=<key 片段>')
    return
end

do
    test.scope:remove()
    local rootUri = ls.uri.encode(projectPath)
    local scope <close> = ls.scope.create('external', rootUri, ls.afs)
    local result = scope:load({}, function () end)

    local hit = 0
    for _, uri in ipairs(result.uris) do
        local path = ls.uri.decode(uri)
        local matchFile = type(fileFilter) == 'string' and fileFilter ~= ''
            and path:find(fileFilter, 1, true) ~= nil
        local vfile = scope.vm:getFile(uri)

        if matchFile and vfile then
            hit = hit + 1
            print('=== {} ===' % { path })
            vfile:dumpNodes(type(keyFilter) == 'string' and keyFilter or nil)
            if hit >= 3 then
                return
            end
        end

        if type(flowFilter) == 'string' and flowFilter ~= '' and vfile and vfile.coder then
            for key, flow in pairs(vfile.coder.tracerFlowMap) do
                local text = ls.util.dump(flow, { noArrayKey = true })
                if key:find(flowFilter, 1, true) or text:find(flowFilter, 1, true) then
                    print('=== {} | {} ===' % { path, key })
                    print(text)
                    hit = hit + 1
                    if hit >= 3 then
                        return
                    end
                end
            end
        end
    end
    if hit == 0 then
        print('未命中（检查 --probe-file / --probe-filter 是否用文件名/key 的片段）')
    end
end
