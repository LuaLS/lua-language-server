---@class LuaLS.Scope
ls.scope = {}

ls.scope.onDidLoad  = ls.sevent.create()
ls.scope.onDidReady = ls.sevent.create()

require 'scope.scope'
require 'scope.load'
require 'scope.require-path'
require 'scope.document'
require 'scope.word-index'
require 'scope.scope-LSPConverter'
require 'scope.document-LSPConverter'
