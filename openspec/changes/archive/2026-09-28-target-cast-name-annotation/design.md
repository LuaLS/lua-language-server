# Design

## 判断链

1. 诊断：`matchKey(source[1], name)`，参数 `string`，实参 `parser.object | truthy`。
2. 读目标工程代码：`name = doc.type == 'doc.class' and doc.class[1]`（1861 处）/ 三选一（1884 处）；
   `source` 是 `doc.extends.name` / `doc.type.name` 这类 **luadoc 构造**节点。
3. 读构造点：`script/parser/luadoc.lua` 的 `parseName`（226-240）用 `[1] = nameText` 建节点
   ⇒ 运行期 `[1]` 是**字符串**。
4. 读注解：`script/parser/guide.lua:80` `---@field [integer] parser.object|any`
   ⇒ 对所有 parser 对象都太宽，`doc.class[1]` / `doc.extends.name[1]` 这类读到 `parser.object | any`。
5. 目标工程自己的先例：1166 行 `matchKey(source[1], state.ast[1]--[[@as string]])`。
6. 结论：**目标工程侧的正解**是加内联 cast；本仓库引擎在该形状上行为正确
   （`test/project/repro/inline-cast-index.lua` 验证 `t[i]--[[@as T]]` 在 `return` 与 `if` 两种位置都生效）。

## 修法与健全性

```lua
and matchKey(source[1], name--[[@as string]])
```

该处 `name` 位于 `if name and name ~= … and not used[name] and matchKey(…)` 的条件链里，
即进入调用时 `name` 必为**真值**；`name` 的取值域是 `string | false | nil`（`and` 短路）
⇒ 真值成员只有 `string`，所以断言 `string` 是健全的。

## 排查教训（写进 `facts/casts.md` F2）

诊断的 **range（列）** 才指出哪一个实参出问题：
用户给的 1861:41–45 正是第 2 个实参 `name`（第 1 个 `source[1]` 在第 30–38 列）。
我第一次把 cast 加在 `source[1]` 上 ⇒ 220 → 220（移除 2 / 新增 2，位置平移），
探针（`call(...)(string, parser.object | truthy)`）才把两个实参区分开。
