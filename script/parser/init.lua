local api = {
    grammar    = require 'parser.grammar',
    parse      = require 'parser.parse',
    compile    = require 'parser.compile',
    split      = require 'parser.split',
    calcline   = require 'parser.calcline',
    lines      = require 'parser.lines',
    guide      = require 'parser.guide',
    luadoc     = require 'parser.luadoc',
    tokens     = require 'parser.tokens',
}

return api
