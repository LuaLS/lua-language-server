---@class Scope.WordIndex
local M = Class 'Scope.WordIndex'

---@param scope Scope
function M:__init(scope)
    self.scope = scope
    ---@type table<string, table<string, integer>>
    self.byChar = {}
    ---@type table<Uri, string[]>
    self.contributions = {}
    ---@type table<Uri, integer>
    self.versions = {}
    ---@type table<Uri, true>
    self.pending = {}
end

---@param word string
---@return string
local function getFirstChar(word)
    return word:sub(1, 1):lower()
end

---@param uri Uri
function M:_removeContribution(uri)
    local words = self.contributions[uri]
    if not words then
        return
    end
    self.contributions[uri] = nil
    self.versions[uri] = nil
    for _, word in ipairs(words) do
        local c = getFirstChar(word)
        local bucket = self.byChar[c]
        if bucket then
            local n = bucket[word]
            if n then
                n = n - 1
                if n <= 0 then
                    bucket[word] = nil
                else
                    bucket[word] = n
                end
            end
            if next(bucket) == nil then
                self.byChar[c] = nil
            end
        end
    end
end

---@param uri Uri
---@param words table<string, true>
function M:_addContribution(uri, words)
    ---@type string[]
    local list = {}
    self.contributions[uri] = list
    for word in pairs(words) do
        list[#list+1] = word
        local c = getFirstChar(word)
        local bucket = self.byChar[c]
        if not bucket then
            bucket = {}
            self.byChar[c] = bucket
        end
        bucket[word] = (bucket[word] or 0) + 1
    end
end

---@param uri Uri
function M:_collect(uri)
    self:_removeContribution(uri)
    local doc = self.scope:getDocument(uri)
    if not doc then
        return
    end
    self:_addContribution(uri, doc.words)
    self.versions[uri] = doc.version
end

---@param uri Uri
function M:markDirty(uri)
    self:_removeContribution(uri)
    self.pending[uri] = true
end

---@param uri Uri
function M:markRemoved(uri)
    self.pending[uri] = nil
    self:_removeContribution(uri)
end

function M:_ensurePendingAllDocuments()
    if self.scope.uris then
        for _, uri in ipairs(self.scope.uris) do
            if not self.contributions[uri] and not self.pending[uri] then
                self.pending[uri] = true
            end
        end
    end
    for uri in pairs(self.scope.documents) do
        if not self.contributions[uri] and not self.pending[uri] then
            self.pending[uri] = true
        end
    end

    for uri, doc in pairs(self.scope.documents) do
        if self.versions[uri] and self.versions[uri] ~= doc.version then
            self.pending[uri] = true
            self:_removeContribution(uri)
        end
    end
end

function M:_flushPending()
    self:_ensurePendingAllDocuments()
    ---@type Uri[]
    local uris = {}
    for uri in pairs(self.pending) do
        uris[#uris+1] = uri
    end
    for _, uri in ipairs(uris) do
        self.pending[uri] = nil
        self:_collect(uri)
    end
end

---@param prefix string
---@return string[]
function M:match(prefix)
    self:_flushPending()
    if prefix == '' then
        return {}
    end
    local lowerPrefix = prefix:lower()
    local bucket = self.byChar[getFirstChar(prefix)]
    if not bucket then
        return {}
    end
    ---@type string[]
    local results = {}
    for word in pairs(bucket) do
        if word:sub(1, #prefix):lower() == lowerPrefix then
            results[#results+1] = word
        end
    end
    table.sort(results, ls.util.stringLess)
    return results
end
