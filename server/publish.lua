local currentPath = debug.getinfo(1, 'S').source:sub(2)
local rootPath = currentPath:gsub('[^/\\]-$', '')
package.cpath = rootPath .. 'bin/?.so'
      .. ';' .. rootPath .. 'bin/?.dll'
package.path  = rootPath .. 'src/?.lua'
      .. ';' .. rootPath .. 'src/?/init.lua'

local fs = require 'bee.filesystem'
local subprocess = require 'bee.subprocess'
ROOT = fs.path(rootPath:gsub('[/\\]$', ''))
EXTENSION = ROOT:parent_path()

require 'utility'
local json = require 'json'

local function loadPackage()
    local buf = io.load(EXTENSION / 'package.json')
    local package = json.decode(buf)
    return package.version
end

local function updateNodeModules(out, postinstall)
    local current = fs.current_path()
    fs.current_path(out)
    local cmd = io.popen(postinstall)
    for line in cmd:lines 'l' do
        print(line)
    end
    local suc = cmd:close()
    if not suc then
        error('更新NodeModules失败！')
    end
    fs.current_path(current)
end

local function createDirectory(version)
    local out = EXTENSION / 'publish' / version
    fs.create_directories(out)
    return out
end

local function copyFiles(root, out)
    return function (dirs)
        local count = 0
        local function copy(relative, mode)
            local source = root / relative
            local target = out / relative
            if not fs.exists(source) then
                return
            end
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
    local is_macos = package.cpath:sub(-3) == '.so'
    local ext = is_macos and '' or '.exe'
    local exe = root / 'bin' / 'lua-language-server' .. ext
    local test = root / 'test' / 'main.lua'
    local lua = subprocess.spawn {
        exe,
        test,
        '-E',
        stdout = true,
        stderr = true,
    }
    for line in lua.stdout:lines 'l' do
        print(line)
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

local version = loadPackage()
print('版本号为：' .. version)

local out = createDirectory(version)

print('清理目录...')
removeFiles(out)(true)

print('开始复制文件...')
local count = copyFiles(EXTENSION , out) {
    ['client'] = {
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
    ['images'] = {
        ['logo.png'] = true,
    },
    ['syntaxes']               = true,
    ['package-lock.json']      = true,
    ['package.json']           = true,
    ['README.md']              = true,
    ['tsconfig.json']          = true,
    ['package.nls.json']       = true,
    ['package.nls.zh-cn.json'] = true,
}
print(('复制了[%d]个文件'):format(count))


print('更新NodeModules...')
updateNodeModules(out, 'cd client && npm install && cd ..')

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

local path = EXTENSION / 'publish' / 'lua-language-server'
print('清理发布目录...')
removeFiles(path)(true)

print('复制到发布目录...')
local count = copyFiles(out, path)(true)
print(('复制了[%d]个文件'):format(count))

print('完成')
