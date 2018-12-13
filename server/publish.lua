local fs = require 'bee.filesystem'
local subprocess = require 'bee.subprocess'

ROOT = fs.current_path()
EXTENSION = ROOT:parent_path()
package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()

require 'utility'
local json = require 'json'

local function loadVersion()
    local buf = io.load(EXTENSION / 'package.json')
    local package = json.decode(buf)
    return package.version
end

local function createDirectory(version)
    local out = EXTENSION / 'publish' / version / 'lua-language-server'
    fs.create_directories(out)
    return out
end

local function copyFiles(out)
    return function (dirs)
        local count = 0
        local function copy(relative, mode)
            local source = EXTENSION / relative
            local target = out / relative
            assert(fs.exists(source))
            if fs.is_directory(source) then
                fs.create_directory(target)
                if mode == true then
                    for path in source:list_directory() do
                        copy(relative / path:filename(), true)
                    end
                else
                    for name, v in pairs(mode) do
                        copy(relative / name, v)
                    end
                end
            else
                fs.copy_file(source, target)
                count = count + 1
            end
        end

        copy(fs.path '', dirs)
        return count
    end
end

local function runTest(root)
    local exe = root / 'bin' / 'lua.exe'
    local test = root / 'test' / 'main.lua'
    local lua = subprocess.spawn {
        exe,
        test,
        '-E',
        stdout = true,
        stderr = true,
    }
    while true do
        local out = lua.stdout:read 'l'
        if out then
            print(out)
        else
            break
        end
    end
    lua:wait()
    local err = lua.stderr:read 'a'
    if err ~= '' then
        error(err)
    end
end

local function removeFiles(out)
    return function (dirs)
        local function remove(relative, mode)
            local target = out / relative
            if not fs.exists(target) then
                return
            end
            if fs.is_directory(target) then
                if mode == true then
                    for path in target:list_directory() do
                        remove(relative / path:filename(), true)
                    end
                    fs.remove(target)
                else
                    for name, v in pairs(mode) do
                        remove(relative / name, v)
                    end
                end
            else
                fs.remove(target)
            end
        end

        remove(fs.path '', dirs)
    end
end

local version = loadVersion()
print('版本号为：' .. version)

local out = createDirectory(version)

print('清理目录...')
removeFiles(out)(true)

print('开始复制文件...')
local count = copyFiles(out) {
    ['client'] = {
        ['node_modules']      = true,
        ['out']               = true,
        ['package-lock.json'] = true,
        ['package.json']      = true,
        ['tsconfig.json']     = true,
    },
    ['server'] = {
        ['bin']      = true,
        ['libs']     = true,
        ['locale']   = true,
        ['src']      = true,
        ['test']     = true,
        ['main.lua'] = true,
    },
    ['package-lock.json'] = true,
    ['package.json']      = true,
    ['README.md']         = true,
    ['tsconfig.json']     = true,
}
print(('复制了[%d]个文件'):format(count))

print('开始测试...')
runTest(out / 'server')

print('删除多余文件...')
removeFiles(out) {
    ['server'] = {
        ['log']  = true,
        ['test'] = true,
        ['bin']  = {
            ['debugger.dll'] = true,
        },
    },
}

print('完成')
