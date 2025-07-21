do
    local root = ls.runtime.rootUri
    local scope = ls.scope.create(root)

    local uris = scope:scan()

    print(#uris)
end
