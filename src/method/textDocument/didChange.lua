return function (lsp, params)
    -- TODO 支持差量更新
    lsp:saveText(params.url, params.version, params.text)
    return true
end
