local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[/\\]*[^/\\]-$', '')
loadfile(rootPath .. '\\platform.lua')('script-beta')
package.path  = package.path
      .. ';' .. rootPath .. '\\test-beta\\?.lua'
      .. ';' .. rootPath .. '\\test-beta\\?\\init.lua'
local fs = require 'bee.filesystem'
ROOT = fs.path(rootPath)
LANG = 'zh-CN'
TEST = true

collectgarbage 'generational'

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')
ac = {}

--dofile((ROOT / 'build_package.lua'):string())

local function loadAllLibs()
    assert(require 'bee.filesystem')
    assert(require 'bee.subprocess')
    assert(require 'bee.thread')
    assert(require 'bee.socket')
    assert(require 'lni')
    assert(require 'lpeglabel')
end

local function loadDocMetas()
    local files   = require 'files'
    local library = require 'library'
    local furi    = require 'file-uri'
    local fsu     = require 'fs-utility'
    for _, path in ipairs(library.metaPaths) do
        local uri = furi.encode(path)
        files.setText(uri, fsu.loadFile(path))
        files.setLibraryPath(uri, library.metaPath)
    end
end

local function main()
    debug.setcstacklimit(1000)
    require 'parser.guide'.debugMode = true
    local function test(name)
        local clock = os.clock()
        print(('测试[%s]...'):format(name))
        require(name)
        print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
    end

    local config = require 'config'
    config.config.runtime.version = 'Lua 5.4'
    config.config.intelliSense.searchDepth = 5
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
    test 'crossfile'
    test 'full'
    --test 'other'

    print('测试完成')
end

loadAllLibs()
main()

log.debug('测试完成')
