local providers = ls.tools.pqueue.create()

---@class Feature.Completion.Param
---@field uri Uri
---@field offset integer
---@field scope Scope

---@param uri Uri
---@param offset integer
function ls.feature.completion(uri, offset)
    local results = {}
    local skipPriorty = -1
end
