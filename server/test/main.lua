local fs = require 'bee.filesystem'

ROOT = fs.current_path()
LANG = 'en-US'

package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()
     .. ';' .. (ROOT / 'test' / '?.lua'):string()
     .. ';' .. (ROOT / 'test' / '?' / 'init.lua'):string()

log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.debug('测试开始')
ac = {}

require 'utility'
require 'global_protect'

local function convertLni()
    local function scan(path, callback)
        if fs.is_directory(path) then
            for child in path:list_directory() do
                scan(child, callback)
            end
        else
            callback(path)
        end
    end

    local function callback(path)
        local ext = path:extension()
        if ext:string() ~= '.lni' then
            return
        end
        local buf = io.load(path)
        local lines = {}
        local cur = 1
        while true do
            local pos = buf:find('[\r\n]', cur)
            if pos then
                lines[#lines+1] = buf:sub(cur, pos - 1)
                if buf:sub(pos, pos + 1) == '\r\n' then
                    cur = pos + 2
                else
                    cur = pos + 1
                end
            else
                lines[#lines+1] = buf:sub(cur)
                break
            end
        end
        local last = ''
        for i, line in ipairs(lines) do
            if line:sub(1, 1) == '[' and line:sub(-1, -1) == ']' then
                if line:sub(1, 2) == '[[' and line:sub(-2, -1) == ']]' then
                    if line == last then
                        lines[i] = '``````````'
                    end
                end
                last = line
            end
        end
        local newBuf = table.concat(lines, '\r\n')
        io.save(path, newBuf)
    end

    scan(ROOT / 'libs', callback)
    scan(ROOT / 'locale', callback)
end
--convertLni()

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

    print('测试完成')
end

main()

log.debug('测试完成')
