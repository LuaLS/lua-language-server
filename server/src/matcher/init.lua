local api = {
    definition     = require 'matcher.definition',
    implementation = require 'matcher.implementation',
    references     = require 'matcher.references',
    rename         = require 'matcher.rename',
    hover          = require 'matcher.hover',
    compile        = require 'matcher.compile',
}

return api
