local guide = require 'parser.guide'

print('[parser.guide] 测试中...')

assert(guide.isLegalName 'abc')
assert(guide.isLegalName '_abc')
assert(guide.isLegalName 'a123')
assert(guide.isLegalName '_')
assert(not guide.isLegalName '1abc')
assert(not guide.isLegalName 'a b')
assert(not guide.isLegalName '')
assert(not guide.isLegalName 'a.b')

assert(not guide.isLegalName 'and')
assert(not guide.isLegalName 'end')
assert(not guide.isLegalName 'true')
assert(not guide.isLegalName 'false')
assert(not guide.isLegalName 'nil')

assert(guide.isLegalName 'continue')
assert(not guide.isLegalName('continue', nil, false))
assert(guide.isLegalName('continue', nil, true))

assert(guide.isLegalName 'goto')
assert(not guide.isLegalName('goto', nil, false))

assert(not guide.isLegalName '中文字段')
assert(guide.isLegalName('中文字段', true))
assert(not guide.isLegalName('1中文', true))
assert(guide.isLegalName('中_文2', true))

assert(guide.isWordChar '_')
assert(guide.isWordChar 'a')
assert(guide.isWordChar 'Z')
assert(guide.isWordChar '9')
assert(guide.isWordChar '中')
assert(not guide.isWordChar '.')
assert(not guide.isWordChar ' ')
assert(not guide.isWordChar '')

assert(ls.guide == guide)

print('[parser.guide] 测试完毕')
