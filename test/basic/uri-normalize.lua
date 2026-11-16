local files     = require 'files'
local workspace = require 'workspace'

-- A virtual document may embed its whole content in the URI (some AI diff
-- views do), which produces a very long string without path separators.
local uri = 'genie-diff:promptbasic.lua?' .. string.rep('a', 100000)

local clock = os.clock()
local normalized = files.normalize(uri)
assert(os.clock() - clock < 2.0, 'files.normalize is too slow on a long URI')
assert(normalized == uri, 'a separator-free URI must be returned unchanged')

clock = os.clock()
assert(workspace.isIgnored(uri) == false)
assert(os.clock() - clock < 2.0, 'workspace.isIgnored is too slow on a non-file URI')

-- Ordinary paths still fold '..' segments
assert(not files.normalize('a/../b'):find('..', 1, true))
