-- 事实台账校验：`证据：` 里引用的 test/*.lua 必须真实存在
do
    local dir = ls.env.ROOT_URI / '.github/skills/luals-server-dev/references/facts'
    local childs = ls.afs.getChilds(dir)
    lt.assertNotEquals(#childs, 0)

    local checked = 0
    for _, uri in ipairs(childs) do
        local text = ls.afs.read(uri) or ''
        for line in text:gmatch('[^\r\n]+') do
            if line:find('证据：', 1, true) then
                for path in line:gmatch('(test/[%w_%-/%.]+%.lua)') do
                    checked = checked + 1
                    lt.assertNotEquals(ls.afs.read(ls.env.ROOT_URI / path), nil)
                end
            end
        end
    end
    lt.assertNotEquals(checked, 0)
end
