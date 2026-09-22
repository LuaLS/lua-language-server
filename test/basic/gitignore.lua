local glob = require 'glob'

local function ignored(patterns, path)
    return glob.gitignore(patterns)(path)
end

-- #3458: a whitespace-only gitignore pattern must not match every path
assert(ignored({ ' ' }, 'a.lua') == false)
assert(ignored({ ' ' }, 'foo/bar.lua') == false)
assert(ignored({ '\t' }, 'a.lua') == false)
assert(ignored({ '' }, 'a.lua') == false)

-- Real patterns in the same list still match; the blank line does not take over
assert(ignored({ ' ', '*.log' }, 'a.lua') == false)
assert(ignored({ ' ', '*.log' }, 'a.log') == true)

-- Intentional match-all and ordinary names are unchanged
assert(ignored({ '*' }, 'a.lua') == true)
assert(ignored({ 'foo' }, 'foo') == true)
assert(ignored({ 'foo' }, 'bar') == false)

-- Quoted trailing space is a real pattern (gitignore spec), not a blank line
assert(ignored({ '\\ ' }, 'a.lua') == false)
assert(ignored({ '\\ ' }, ' ') == true)

-- glob.glob shares the same matcher; empty patterns must not match everything
assert(glob.glob({ ' ' })('a.lua') == false)
assert(glob.glob({ ' ', 'foo' })('foo') == true)
assert(glob.glob({ ' ', 'foo' })('bar') == false)
assert(glob.glob({ '*' })('a.lua') == true)
