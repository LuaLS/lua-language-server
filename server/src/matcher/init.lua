local api = {
    definition     = require 'matcher.definition',
    implementation = require 'matcher.implementation',
    references     = require 'matcher.references',
    rename         = require 'matcher.rename',
    hover          = require 'matcher.hover',
    diagnostics    = require 'matcher.diagnostics',
    findResult     = require 'matcher.find_result',
    findLib        = require 'matcher.find_lib',
    completion     = require 'matcher.completion',
    vm             = require 'matcher.vm',
}

return api
