package.path  = package.path
      .. ';./test/?.lua'
      .. ';./test/?/init.lua'
local fs = require 'bee.filesystem'
local rootPath = fs.exe_path():parent_path():parent_path():parent_path():string()
ROOT = fs.path(rootPath)
TEST = true
DEVELOP = true
--FOOTPRINT = true
--TRACE = true
LOGPATH  = LOGPATH  or (ROOT .. '/log')
METAPATH = METAPATH or (ROOT .. '/meta')

collectgarbage 'generational'

io.write = function () end

---@diagnostic disable-next-line: lowercase-global
log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')

--dofile((ROOT / 'build_package.lua'):string())
require 'tracy'

local function loadAllLibs()
    assert(require 'bee.filesystem')
    assert(require 'bee.subprocess')
    assert(require 'bee.thread')
    assert(require 'bee.socket')
    assert(require 'lpeglabel')
end

local function loadDocMetas()
    local files   = require 'files'
    local library = require 'library'
    local furi    = require 'file-uri'
    local fsu     = require 'fs-utility'
    local client  = require 'client'
    client.client 'vscode'
    for _, path in ipairs(library.metaPaths) do
        local uri = furi.encode(path)
        files.setText(uri, fsu.loadFile(path))
        files.setLibraryPath(uri, library.metaPath)
    end
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

local function main()
    require 'utility'.enableCloseFunction()
    require 'config'.init()
    require 'core.searcher'.debugMode = true
    require 'language' 'zh-cn'
    require 'library'.init()
    loadDocMetas()

    --config.Lua.intelliSense.searchDepth = 5
    --loadDocMetas()

    --test 'full';do return end

    require 'bee.platform'.OS = 'Windows'
    testAll()
    require 'bee.platform'.OS = 'Linux'
    testAll()
    require 'bee.platform'.OS = 'macOS'
    testAll()

    test 'full'

    print('测试完成')
end

loadAllLibs()
main()

log.debug('测试完成')
require 'bee.thread'.sleep(1)
os.exit()
