do
    -- 增量编辑：正常路径
    local uri = 'file:///root/sync-a.lua'
    ls.file.create(uri)
    ls.file.setClientText(uri, 'abc', 1)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 1 }, ['end'] = { line = 0, character = 1 } },
        text = 'X',
    }}, 2, 'utf-16')
    lt.assertEquals(ls.file.get(uri):getText(), 'aXbc')
    ls.file.get(uri):removeByClient()
end

do
    -- 回归：didOpen 重发全文后 merger 必须重置，后续增量不能基于旧文本
    local uri = 'file:///root/sync-b.lua'
    ls.file.create(uri)
    ls.file.setClientText(uri, 'abc', 1)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 1 }, ['end'] = { line = 0, character = 1 } },
        text = 'X',
    }}, 2, 'utf-16')
    ls.file.setClientText(uri, 'hello', 3)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 5 }, ['end'] = { line = 0, character = 5 } },
        text = '!',
    }}, 4, 'utf-16')
    lt.assertEquals(ls.file.get(uri):getText(), 'hello!')
    ls.file.get(uri):removeByClient()
end

do
    -- 无 range 的全量替换
    local uri = 'file:///root/sync-c.lua'
    ls.file.create(uri)
    ls.file.setClientText(uri, 'abc', 1)
    ls.file.applyClientChanges(uri, {{
        text = 'xyz',
    }}, 2, 'utf-16')
    lt.assertEquals(ls.file.get(uri):getText(), 'xyz')
    ls.file.get(uri):removeByClient()
end

do
    -- 回归：会话重开（didClose+didOpen 全文）后 merger 必须重建，增量基于新全文
    local uri = 'file:///root/sync-d.lua'
    ls.file.create(uri)
    ls.file.setClientText(uri, 'line1', 1)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 5 }, ['end'] = { line = 0, character = 5 } },
        text = '!',
    }}, 2, 'utf-16')
    ls.file.get(uri):removeByClient()
    ls.file.setClientText(uri, 'brand new text', 10)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 14 }, ['end'] = { line = 0, character = 14 } },
        text = '?',
    }}, 11, 'utf-16')
    lt.assertEquals(ls.file.get(uri):getText(), 'brand new text?')
    ls.file.get(uri):removeByClient()
end

do
    -- 回归：merger 基态与 clientText 脱节时（外部直接重设 clientText），文本对比触发重建
    local uri = 'file:///root/sync-e.lua'
    ls.file.create(uri)
    ls.file.setClientText(uri, 'abc', 1)
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 1 }, ['end'] = { line = 0, character = 1 } },
        text = 'X',
    }}, 2, 'utf-16')
    -- merger 基态为 'aXbc'，但 clientText 被外部重设为 'zzz'（未清 merger）
    ls.file.get(uri).clientText = 'zzz'
    ls.file.applyClientChanges(uri, {{
        range = { start = { line = 0, character = 3 }, ['end'] = { line = 0, character = 3 } },
        text = 'Y',
    }}, 3, 'utf-16')
    lt.assertEquals(ls.file.get(uri):getText(), 'zzzY')
    ls.file.get(uri):removeByClient()
end
