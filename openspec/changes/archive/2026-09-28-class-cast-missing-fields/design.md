# Design

## 上游机制（查证结论，别重走）

1. **没有跨诊断的同位置优先级**：
   - `script/core/diagnostics/init.lua:117-129`：每个诊断名自己的 `mark[result.start]` 只留第一条
     （**单诊断内部**的位置去重）；
   - `script/provider/diagnostic.lua` 的 `mergeDiags` 只把各诊断结果拼接，不比较位置；
   - 禁用按代码名匹配：`core/diagnostics/init.lua:120`
     `vm.isDiagDisabledAt(uri, result.start, name)`。
2. **上游这里只出 `missing-fields`**：
   - `Lua.type.checkTableShape` 默认 `false`（`script/config/template.lua:432`）；
   - `vm.isSubType`（`script/vm/type.lua:572-581`）：`child` 是 `table`、`parent` 是非基础类型
     （类/别名）时，开着该配置才做 `checkTableShape`，否则直接 `return true`；
   - 于是「字面量 → 类」的实参在 `param-type-mismatch`/`assign-type-mismatch` 里不算转换失败，
     形状问题由 `missing-fields`（`script/proto/diagnostic.lua:57-70`，group `unbalanced`、
     Warning、status Any）单独报；用户把 `checkTableShape` 打开时两条会同时出现（上游也不去重）。

## 我们的修法（`script/node/type.lua` `M:onCanBeCast` 的类分支）

```lua
        ---@type Node.Table?
        local require = self.value
        if require and require.kind == 'table'
        and other.kind == 'table' then
            -- 有交集又有缺失才走宽限；字段齐全 / 无交集交回原判据
            local missed, overlap = false, false
            for _, key in ipairs(require.keys) do
                local _, exists = other:get(key)
                if exists then overlap = true else missed = true end
            end
            if not (missed and overlap) then
                return other:canCast(self.value)
            end
            if _classCastDepth >= CLASS_CAST_DEPTH_LIMIT then
                return true
            end
            _classCastDepth = _classCastDepth + 1
            local ok = true
            for _, key in ipairs(require.keys) do
                local v, exists = other:get(key)
                if exists then
                    local myType = require:get(key)
                    if not v:canCast(myType) then ok = false break end
                end
            end
            _classCastDepth = _classCastDepth - 1
            return ok
        end
```

要点：
- **只在「有交集 + 有缺失」时生效**：这样 `{ [1] = ... }` 这类索引构造的表（与类无同名交集）
  与「字段齐全但某个字段类型不匹配」都仍走原判据（保住 `return-type-mismatch` 的旧钉子）。
- **就地比较**：不新建节点 —— 试过拼一张「已出现字段」的表再 `canCast`，会因节点身份每次不同
  而绕开 cast 缓存，表与类互转的递归爆栈。
- **`_classCastDepth` 兜底**：自引用字段（`parser.object.node: parser.object`）在 `Union:get`
  每次新建节点的情况下认不出环，只能按深度封顶。

## 与「上游默认行为」的差别（有意保留）

上游 `checkTableShape = false` 时**整块跳过**形状检查（连已出现字段的类型也不比）；
我们只放宽「缺必填字段」这一项，已出现字段的类型照旧比 —— 这是用户挑的方案
（最小放宽，保住 `{ x = 'str' }` 这类真错误）。
