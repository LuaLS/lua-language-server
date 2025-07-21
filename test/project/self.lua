do
    local root = ls.runtime.rootUri
    local scope = ls.scope.create(root)

    local uris = scope:scan()

    print('已加载 {} 个路径' % { #uris })
end
