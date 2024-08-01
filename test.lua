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

---@diagnostic disable-next-line: duplicate-set-field
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
    require = function (n)
        local v, p = originRequire(n)
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
    test 'definition'
    test 'type_inference'
    test 'implementation'
    test 'references'
    test 'hover'
    test 'completion'
    test 'diagnostics'
    test 'crossfile'
    test 'highlight'
    test 'rename'
    test 'signature'
    test 'command'
    test 'document_symbol'
    test 'code_action'
    test 'other'
end

local files = require "files"

local function main()
    require 'utility'.enableCloseFunction()
    require 'client' .client 'VSCode'

    local lclient = require 'lclient'
    local ws      = require 'workspace'
    local furi    = require 'file-uri'
    require 'vm'

    --log.print = true

    TESTROOT = ROOT:string() .. '/test_root/'
    TESTROOTURI = furi.encode(TESTROOT)
    TESTURI = furi.encode(TESTROOT .. 'unittest.lua')

    ---@async
    lclient():start(function (client)
        client:registerFakers()
        local rootUri = furi.encode(TESTROOT)
        client:initialize {
            rootUri = rootUri,
        }

        ws.awaitReady(rootUri)

        print('Loaded files in', os)
        for uri in files.eachFile() do
            print(uri)
        end
        print('===============')

        testAll()
    end)

    test 'tclient'
    test 'full'
    test 'plugins.test'
	test 'cli.test'
end

loadAllLibs()
main()

log.debug('test finish.')
require 'bee.thread'.sleep(1000)
os.exit()
