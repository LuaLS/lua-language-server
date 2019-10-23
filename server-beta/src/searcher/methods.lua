local methods = {}

methods['local']      = require 'searcher.local'
methods['getlocal']   = require 'searcher.getlocal'
methods['setlocal']   = methods['getlocal']
methods['getglobal']  = require 'searcher.getglobal'
methods['setglobal']  = methods['getglobal']
methods['getfield']   = require 'searcher.getfield'
methods['setfield']   = methods['getfield']
methods['tablefield'] = require 'searcher.tablefield'
methods['getmethod']  = methods['getfield']
methods['setmethod']  = methods['getfield']
methods['getindex']   = methods['getfield']
methods['setindex']   = methods['getfield']
methods['field']      = require 'searcher.field'
methods['method']     = require 'searcher.method'
methods['index']      = require 'searcher.index'
methods['number']     = require 'searcher.number'
methods['boolean']    = require 'searcher.boolean'
methods['string']     = require 'searcher.string'
methods['table']      = require 'searcher.table'
methods['select']     = require 'searcher.select'
methods['goto']       = require 'searcher.goto'
methods['label']      = require 'searcher.label'

return methods
