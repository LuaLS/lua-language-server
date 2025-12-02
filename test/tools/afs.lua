print('正在测试 ls.afs ...')

local uri = ls.env.ROOT_URI / 'testfile'
local content = '--' .. math.random(1000, 9999) .. os.time()
ls.afs.remove(uri)
assert(ls.afs.read(uri) == nil)
ls.afs.write(uri, content)
assert(ls.afs.read(uri) == content)
