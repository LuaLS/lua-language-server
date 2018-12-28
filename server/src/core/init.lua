local api = {
    definition     = require 'core.definition',
    implementation = require 'core.implementation',
    references     = require 'core.references',
    rename         = require 'core.rename',
    hover          = require 'core.hover',
    diagnostics    = require 'core.diagnostics',
    findResult     = require 'core.find_result',
    findLib        = require 'core.find_lib',
    completion     = require 'core.completion',
    signature      = require 'core.signature',
    documentSymbol = require 'core.document_symbol',
    vm             = require 'core.vm',
}

return api
