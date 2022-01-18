package.path  = package.path
      .. ';./test/?.lua'
      .. ';./test/?/init.lua'
local fs = require 'bee.filesystem'
local rootPath = fs.exe_path():parent_path():parent_path():string()
ROOT = fs.path(rootPath)
TEST = true
DEVELOP = true
--FOOTPRINT = true
--TRACE = true
LOGPATH  = LOGPATH  or (ROOT:string() .. '/log')
METAPATH = METAPATH or (ROOT:string() .. '/meta')

collectgarbage 'generational'

io.write = function () end

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')

LOCALE = 'zh-cn'

--dofile((ROOT / 'build_package.lua'):string())
require 'tracy'

local function loadAllLibs()
    assert(require 'bee.filesystem')
    assert(require 'bee.subprocess')
    assert(require 'bee.thread')
    assert(require 'bee.socket')
    assert(require 'lpeglabel')
end

local function test(name)
    local clock = os.clock()
    print(('测试[%s]...'):format(name))
    local originRequire = require
    require = function (n, ...)
        local v, p = originRequire(n, ...)
        if p and p:find 'test/' then
            package.loaded[n] = nil
        end
        return v, p
    end
    require(name)
    require = originRequire
    print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
end

local function testAll()
    test 'basic'
    test 'references'
    test 'definition'
    test 'type_inference'
    test 'hover'
    test 'completion'
    test 'crossfile'
    test 'diagnostics'
    test 'highlight'
    test 'rename'
    test 'signature'
    test 'command'
    test 'document_symbol'
    test 'code_action'
    test 'type_formatting'
    --test 'other'
end

local files = require "files"

local function main()
    require 'utility'.enableCloseFunction()
    require 'client' .client 'VSCode'

    local lclient = require 'tclient.lclient'
    local ws      = require 'workspace'

    log.print = true

    for _, os in ipairs {'Windows', 'Linux', 'macOS'} do
        require 'bee.platform'.OS = os
        ---@async
        lclient():start(function (client)
            client:registerFakers()
            client:initialize()

            ws.awaitReady()

            print('Loaded files in', os)
            for uri in files.eachFile() do
                print(uri)
            end
            print('===============')

            testAll()
        end)
    end

    test 'tclient'
    test 'full'
end

loadAllLibs()
main()

log.debug('test finish.')
require 'bee.thread'.sleep(1)
os.exit()
