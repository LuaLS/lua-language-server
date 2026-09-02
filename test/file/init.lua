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
