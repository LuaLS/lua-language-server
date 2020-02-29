local api = {
    definition     = require 'core.definition',
    implementation = require 'core.implementation',
    references     = require 'core.references',
    rename         = require 'core.rename',
    hover          = require 'core.hover',
    diagnostics    = require 'core.diagnostics',
    findSource     = require 'core.find_source',
    findLib        = require 'core.find_lib',
    completion     = require 'core.completion',
    signature      = require 'core.signature',
    documentSymbol = require 'core.document_symbol',
    global         = require 'core.global',
    highlight      = require 'core.highlight',
    codeAction     = require 'core.code_action',
    foldingRange   = require 'core.folding_range',
}

return api
