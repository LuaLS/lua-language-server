local git_ref = '3.16.0'
local modrev = 'scm'
local specrev = '1'

rockspec_format = '3.0'
package = 'lua-language-server'
version = modrev .. '-' .. specrev

local repo_url = 'https://github.com/LuaLS/lua-language-server'

description = {
  summary = 'A language server that offers Lua language support - programmed in Lua',
  detailed =
  [[The Lua language server provides various language features for Lua to make development easier and faster. With nearly a million installs in Visual Studio Code, it is the most popular extension for Lua language support.]],
  labels = { 'lua', 'language-server', 'lpeg', 'hacktoberfest', 'lsp', 'lsp-server', 'lpeglabel' },
  homepage = repo_url,
  license = 'MIT'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

dependencies = { 'lpeglabel', 'EmmyLuaCodeStyle', 'bee.lua' }

build = {
  type = 'builtin',
  copy_directories = { 'meta', 'locale' },
  install = {
    bin = {
      [package] = package,
    },
    conf = {
      ['../main.lua'] = 'main.lua',
      ['../debugger.lua'] = 'debugger.lua',
    },
  }
}
