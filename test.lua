local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
if rootPath == '' then
    rootPath = './'
end
loadfile(rootPath .. 'platform.lua')('script')
package.path  = package.path
      .. ';' .. rootPath .. 'test/?.lua'
      .. ';' .. rootPath .. 'test/?/init.lua'
local fs = require 'bee.filesystem'
ROOT = fs.absolute(fs.path(rootPath):parent_path())
LANG = 'en-US'

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')
ac = {}

require 'utility'

local function loadAllLibs()
    assert(require 'bee.filesystem')
    assert(require 'bee.subprocess')
    assert(require 'bee.thread')
    assert(require 'bee.socket')
    assert(require 'lni')
    assert(require 'lpeglabel')
end

local function main()
    local function test(name)
        local clock = os.clock()
        print(('测试[%s]...'):format(name))
        require(name)
        print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
    end

    test 'core'
    test 'definition'
    test 'rename'
    test 'highlight'
    test 'references'
    test 'diagnostics'
    test 'type_inference'
    test 'find_lib'
    test 'hover'
    test 'completion'
    test 'signature'
    test 'document_symbol'
    test 'crossfile'
    test 'full'
    test 'other'

    print('测试完成')
end

loadAllLibs()
main()

log.debug('测试完成')
