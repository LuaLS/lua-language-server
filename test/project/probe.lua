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
local varFilter  = ls.args.PROBE_VAR

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
        -- 过滤串里的 `/` 与 Windows 的 `\` 视为等价，`--probe-file=cli/doc/init.lua` 才命中
        local normalized = path:gsub('\\', '/')
        local matchFile = type(fileFilter) == 'string' and fileFilter ~= ''
            and normalized:find(fileFilter:gsub('\\', '/'), 1, true) ~= nil
        local vfile = scope.vm:getFile(uri)

        if matchFile and vfile then
            hit = hit + 1
            print('=== {} ===' % { path })
            vfile:dumpNodes(type(keyFilter) == 'string' and keyFilter or nil)
            if type(varFilter) == 'string' and varFilter ~= '' and vfile.coder and vfile.coder.map then
                for key, node in pairs(vfile.coder.map) do
                    if key:find(varFilter, 1, true) then
                        print('[varDump] === ' .. key .. ' kind=' .. tostring(node.kind) .. ' ===')
                        local function show(name, fn)
                            local ok, v = pcall(fn)
                            if not ok then
                                print('[varDump] ' .. name .. ' = ERR ' .. tostring(v))
                                return
                            end
                            local text = 'nil'
                            if v ~= nil then
                                local ok2, view = pcall(function ()
                                    return v:view()
                                end)
                                text = ok2 and view or ('<' .. tostring(v) .. '>')
                            end
                            print('[varDump] ' .. name .. ' = ' .. tostring(text))
                        end
                        show('key', function () return node.kind == 'variable' and node.key or nil end)
                        show('parent', function () return node.kind == 'variable' and node.parent or nil end)
                        show('master', function () return node.kind == 'variable' and node.masterVariable or nil end)
                        show('currentValue', function () return node.kind == 'variable' and node:getCurrentValue() or nil end)
                        show('expectValue', function () return node.kind == 'variable' and node:getExpectValue() or nil end)
                        show('guessValue', function () return node.kind == 'variable' and node:getGuessValue() or nil end)
                        show('staticValue', function () return node.kind == 'variable' and node:getStaticValue() or nil end)
                        show('parentFieldValue', function () return node.kind == 'variable' and node.parentFieldValue or nil end)
                        show('parentExpectValue', function () return node.kind == 'variable' and node.parentExpectValue or nil end)
                        show('equivalentValue', function () return node.kind == 'variable' and node.equivalentValue or nil end)
                        show('childsValue', function () return node.kind == 'variable' and node.childsValue or nil end)
                        show('assignValue', function () return node.kind == 'variable' and node.assignValue or nil end)
                        show('rawCurrent', function () return node.kind == 'variable' and node.currentValue or nil end)
                        show('rawStatic', function () return node.kind == 'variable' and node.staticValue or nil end)
                        local cur = node
                        for i = 1, 3 do                            if cur.kind ~= 'variable' or not cur.parent then
                                break
                            end
                            cur = cur.parent
                            print('[varDump]   ^ parent' .. i .. ' key=' .. tostring(cur.kind == 'variable' and type(cur.key) == 'table' and cur.key:view() or cur.key))
                            local function showP(name, fn)
                                local ok, v = pcall(fn)
                                local text = 'nil'
                                if ok and v ~= nil and v ~= false then
                                    local ok2, view = pcall(function () return v:view() end)
                                    text = ok2 and view or ('<' .. tostring(v) .. '>')
                                end
                                print('[varDump]     ' .. name .. ' = ' .. tostring(text))
                            end
                            showP('value', function () return cur.value end)
                            showP('currentValue', function () return cur:getCurrentValue() end)
                            showP('expectValue', function () return cur:getExpectValue() end)
                            showP('guessValue', function () return cur:getGuessValue() end)
                            showP('staticValue', function () return cur:getStaticValue() end)
                        end
                    end
                end
            end
            if type(ls.args.PROBE_CODE) == 'string' and ls.args.PROBE_CODE ~= '' and vfile.coder and vfile.coder.code then
                print('[codeDump] === ' .. path .. ' ===')
                for line in vfile.coder.code:gmatch('[^\r\n]+') do
                    if line:find(ls.args.PROBE_CODE, 1, true) then
                        print('[codeDump] ' .. line)
                    end
                end
            end
            if hit >= 3 then
                return
            end
        end

        -- flow 也受 --probe-file 约束：否则同一段 key 文本会在别的文件里先命中，吃满 3 次机会
        if type(flowFilter) == 'string' and flowFilter ~= '' and vfile and vfile.coder
        and (type(fileFilter) ~= 'string' or fileFilter == '' or matchFile) then
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
