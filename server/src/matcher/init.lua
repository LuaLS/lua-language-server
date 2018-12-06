local api = {
    definition     = require 'matcher.definition',
    implementation = require 'matcher.implementation',
    references     = require 'matcher.references',
    rename         = require 'matcher.rename',
    hover          = require 'matcher.hover',
    diagnostics    = require 'matcher.diagnostics',
    compile        = require 'matcher.compile',
}

return api
