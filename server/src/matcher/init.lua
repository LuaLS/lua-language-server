local api = {
    definition     = require 'matcher.definition',
    implementation = require 'matcher.implementation',
    references     = require 'matcher.references',
    rename         = require 'matcher.rename',
    hover          = require 'matcher.hover',
    diagnostics    = require 'matcher.diagnostics',
    compile        = require 'matcher.compile',
    typeInference  = require 'matcher.type_inference',
    findResult     = require 'matcher.find_result',
    findLibFull    = require 'matcher.find_lib_full',
}

return api
