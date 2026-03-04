print(_VERSION)
local thread = require 'bee.thread'

collectgarbage('generational')
print(collectgarbage('param', 'minormul', 20))
print(collectgarbage('param', 'minormajor', 100))
print(collectgarbage('param', 'majorminor', 20))

package.path = package.path.. ';./?.lua;./?/init.lua'

---@class Test
test = {}

require 'luals'
require 'runtime'
ls.env.LOG_FILE = ls.util.expandPath('$LOG_PATH/test.log', ls.env)
require 'master'
require 'scope'
require 'config'
require 'filesystem'
require 'node'
require 'vm'
require 'custom'
require 'file'
require 'feature'

test.rootPath = ls.env.ROOT_PATH .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create('test', test.rootUri)

-- 支持命令行过滤：bin\lua-language-server.exe test.lua test/feature/definition/luadoc.lua
-- 将路径参数转换为 module 名，如 "test/feature/definition/luadoc.lua" -> "test.feature.definition.luadoc"
do
    local filterArg = arg and arg[1]
    if filterArg then
        -- 去掉 .lua 后缀，替换斜杠为点
        test.filter = filterArg:gsub('%.lua$', ''):gsub('[/\\]', '.')
        print('测试过滤器：' .. test.filter)
    end
end

--- 支持协程穿透的模块加载器（不经过 package.loaded 缓存）
--- 使用 package.searchpath 定位文件，io.open 读取，load 编译后执行
---@param modname string
---@return any
function test.dofile(modname)
    local path, err = package.searchpath(modname, package.path)
    if not path then
        error('module not found: ' .. modname .. '\n' .. (err or ''), 2)
    end
    local f, ferr = io.open(path, 'r')
    if not f then
        error('cannot open: ' .. path .. '\n' .. (ferr or ''), 2)
    end
    local src = f:read('*a')
    f:close()
    local chunk, lerr = load(src, '@' .. path, 't')
    if not chunk then
        error(lerr, 2)
    end
    return chunk()
end

--- 带过滤器的 require，只有 modname 匹配过滤器时才执行
---@param modname string
function test.require(modname)
    if test.filter then
        -- 只运行前缀匹配的模块（含子模块）或精确匹配
        if modname ~= test.filter
            and modname:sub(1, #test.filter + 1) ~= test.filter .. '.'
            and test.filter:sub(1, #modname + 1) ~= modname .. '.'
        then
            return
        end
    end
    test.dofile(modname)
end

---@async
ls.await.call(function ()
    -- 加载一些工具
    require 'test.include'
    test.catch = require 'test.catch'
    ---@diagnostic disable-next-line
    lt = require 'test.ltest'
    local suc, err = pcall(function ()
        print('开始测试')
        test.require 'test.tools'
        test.require 'test.parser'
        test.require 'test.node'
        test.require 'test.coder'
        test.require 'test.feature'
        test.require 'test.project'
    end)
    ls.await.sleep(1)
    ls.eventLoop.stop()
    if suc then
        print('测试完成')
    else
        print('测试失败：\n' .. err)
        if LAST_URI then
            print('最后处理的文件：' .. LAST_URI)
        end
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_CODE', LAST_CODE)
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_FLOW', LAST_FLOW)
        ls.fs.write(ls.env.ROOT_URI / 'tmp' / 'LAST_PMAP', LAST_PMAP)
    end
    thread.sleep(1000)
    os.exit(true)
end)

ls.eventLoop.start(function ()
    ls.timer.update(1000)
    thread.sleep(1)
end)
