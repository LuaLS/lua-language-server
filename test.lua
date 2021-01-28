local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
rootPath = rootPath == '' and '.' or rootPath
loadfile(rootPath .. '/platform.lua')('script')
package.path  = package.path
      .. ';' .. rootPath .. '/test/?.lua'
      .. ';' .. rootPath .. '/test/?/init.lua'
local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)
TEST = true
DEVELOP = true
LOGPATH  = LOGPATH  or (ROOT .. '/log')
METAPATH = METAPATH or (ROOT .. '/meta')

collectgarbage 'generational'

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
    local client  = require 'provider.client'
    client.client 'vscode'
    library.init()
    for _, path in ipairs(library.metaPaths) do
        local uri = furi.encode(path)
        files.setText(uri, fsu.loadFile(path))
        files.setLibraryPath(uri, library.metaPath)
    end
end

local function main()
    debug.setcstacklimit(1000)
    require 'parser.guide'.debugMode = true
    require 'language' 'zh-cn'
    require 'utility'.enableCloseFunction()
    local function test(name)
        local clock = os.clock()
        print(('测试[%s]...'):format(name))
        require(name)
        print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
    end

    local config = require 'config'
    config.config.runtime.version = 'Lua 5.4'
    --config.config.intelliSense.searchDepth = 5
    loadDocMetas()

    test 'references'
    test 'definition'
    test 'type_inference'
    test 'diagnostics'
    test 'highlight'
    test 'rename'
    test 'hover'
    test 'completion'
    test 'signature'
    test 'document_symbol'
    test 'code_action'
    test 'crossfile'
    test 'full'
    --test 'other'

    print('测试完成')
end

loadAllLibs()
main()

log.debug('测试完成')
require 'bee.thread'.sleep(1)
os.exit()
