require 'filesystem'
ROOT = fs.current_path()
package.path = (ROOT / 'src' / '?.lua'):string()
     .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()

local log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
log.info('Lua 语言服务启动，路径为：', ROOT)

require 'utility'
require 'global_protect'
local service = require 'service'
local session = service()

session:listen()
