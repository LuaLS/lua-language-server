require 'filelist'
ROOT = fs.current_path()
package.path = package.path .. ';' .. (ROOT / 'src' / '?.lua'):string()
                            .. ';' .. (ROOT / 'src' / '?' / 'init.lua'):string()

local log = require 'log'
log.init(ROOT, ROOT / 'log' / 'test.log')
