# 事实台账：type-check 类诊断（assign / param / return 的宽松规则）

格式同 `narrowing.md`：断言 / 证据 / 代码 / 状态。

## T1 `X | any` 等价于 any（三条类型检查必须同规则）

- 断言：实参 / 返回值 / 被赋值表达式的类型里**含 `any` 成员**（或本身是 `any`）时，
  assign / param / return 三条检查 SHALL 一律宽松放行；判定 SHALL 是同一份实现。
- 依据（本仓库自己的语义）：`any` 是赋值的顶类型，`X | any` 语义上就是 `any`；
  仓库在 assign 检查里早已这么定（见下「代码」的既有注释）。
- 证据：
  - `test/feature/diagnostic/param-type-mismatch.lua` 末两例（`---@field [integer] Node|any` 的
    `o[1]` 传给 `string` 参数不报 / 对照组 `Node` 不含 `any` 必报）
  - `test/feature/diagnostic/return-type-mismatch.lua` 末两例（同形状的返回值方向 + 对照）
  - 最小复现（发现时的对照实验）：同一 `Node|any` 字段 —— **赋给** `string` 不报、
    **传给** `string` 参数报 ⇒ 引擎内部不一致
- 代码：`script/feature/diagnostic/define.lua` 的 `hasAnyMember`（唯一实现）；
  `assign-type-mismatch.lua`（原规则，现改用共享实现）、`param-type-mismatch.lua` 的 `canAssign`、
  `return-type-mismatch.lua` 的返回值循环各调用一次
- 数字：目标工程 **154 → 130（移除 24 / 新增 0）**；其中分步为
  **仅 param 放宽 154 → 133（移除 21）**、再加 **return 154 → 130（移除 24）**
  （24 里含上一轮 F2 依赖边的 5 条：`compile.lua:3365(x2)/3375/3411/3417`）
- 试过但未采用：
  - 把 `Runtime` 的 `ANY.truthy` preset 从 `TRUTHY` 改成 `ANY`：只改消息文字
    （`parser.object | truthy` → `parser.object | any`），**误报仍在**（拦路成员是具体类），
    且属全局语义改动 ⇒ 回退
  - union 生成时吸收 `any`（`T|any` → `any`）：语义等价但影响 narrowing / 展示 / 缓存，未实测
  - 在 `Union.__getter.truthy/falsy` 里让 `any`/`unknown` 成员保持自身（想连「守卫后」的读取一起修）：
    实测 **154 → 129（移除 32 / 新增 7）**，新增的 7 条全是目标工程 `script/json-edit.lua` 的
    `t.v[k]` 一族 `need-check-nil` —— 保留 `any` 会让它**含 nil**，破坏「守卫已排除 nil」这条收窄，
    净变差 ⇒ 回退
- 已知未覆盖（下一步入口）：**联合里的 `any` 成员经过真值/假值收窄后**会被换成 `truthy`/`falsy` 标记
  （`X | any` → `X | truthy`），此时 `hasAnyMember` 判不出来、检查照旧报。
  要覆盖它得让「收窄保留宽松成员」且**不把 nil 放回来**（例如收窄结果取 `truthy` 的成员集合、
  但把 `any` 换成一个"非 nil 的未知"类型），目前没有这样的类型 ⇒ 留给后续轮次。
- 状态：成立（2026-10-08，change `any-member-relaxation`；未覆盖场景见上）

## T2 目标工程 `param-type-mismatch` 88 条的家族分诊

分诊时点：`tmp/scan-154.txt`（改前基线）。按消息形状分组：

| 家族（实参类型） | 条数 | 判定 |
| --- | --- | --- |
| 含 `any` 成员（`any \| nil`、`parser.object \| any`、`parser.object \| truthy` 等） | 16 | **引擎不一致** ⇒ 本轮按 T1 放宽后消失 |
| `parser.object[] \| parser.object`（`extends` 一族） | 21 | **目标侧注解**（已清，见 T3） |
| 裸 `parser.object` / `parser.object \| nil` / `parser.object[]` | 约 20 | 目标侧注解偏松：`parser.object` 声明了 `---@field node parser.object`、`---@field [integer] parser.object\|any` 这类「一把抓」类型，调用点直接当具体类型用；按目标自己的注解判定**成立**，不硬改引擎迎合 |
| `uri \| nil` / `false \| uri \| nil` | 约 9 | 目标侧：`furi.decode(scp.uri)` 前未判空（`files.lua:948` 一族） |
| 其它（`{ [string]: vm.node } \| nil`、`op.*` 怪物类型等） | 约 24 | 逐条看；多数是目标侧注解与实际推断不一致（含 operator 类型参与推断） |

- 状态：T1 那一族已落地；其余家族的判定与「不硬改引擎迎合目标侧注解」的结论记在此处（2026-10-08）。
- 后续入口（若继续清）：T3 之外，`uri | nil`（约 9 条）、`parser.object` 一把抓（约 20 条）。

## T3 目标侧 `extends` 一族（21 条）：声明改成单节点 + 三处内联 cast

- 背景：`parser.object` 的 `extends` 字段在目标工程里被声明成 `parser.object[]|parser.object`
  （`script/parser/guide.lua`），于是所有「把 `X.extends` 当单个节点用」的调用点都按**联合**判：
  `vm.compileNode(X.extends)`、`containsGenericName(field.extends)`、`vm.getGeneric(set.extends)` 等，
  共 21 条 `param-type-mismatch` / `assign-type-mismatch`。
- 语义核查（目标工程自己的代码）：`extends` 只在 `doc.class`（类继承名单）里被当**列表**
  （`luadoc.lua` 的 `result.extends[#result.extends+1] = extend`）；其余（`doc.alias` / `doc.type.field` /
  `doc.type.function` 的 arg / `@operator`）都是**单个类型节点**，目标自己在 `vm/operator.lua` 也有
  「`extends` 运行时均为单个类型节点」的注释。列表消费方用 `ipairs(set.extends)`，而 `parser.object`
  本身声明了 `---@field [integer] parser.object|any`，索引/遍历不受影响。
- 实验（1 行声明改法）：
  - 改 `parser.object`（单节点）⇒ 移除 21 / **新增 1**（`compiler.lua:346` 的返回表字面量：
    `extends = vm.cloneObject(...)` 产出 `vm.object`（含 `vm.generic`），装不进 `parser.object` 字段）
  - 改 `vm.object`（别名 `parser.object|vm.generic`）⇒ **移除 18 / 新增 0** ⇒ 采用
- 落地（目标工程，3 文件 6 行）：
  - `script/parser/guide.lua`：`---@field extends parser.object[]|parser.object` → `vm.object`
  - `script/vm/compiler.lua`（2 处）+ `script/vm/sign.lua`（1 处）：`X.extends--[[@as parser.object]]`
    —— 内联 cast 是**注释**，零运行时影响；目标工程自己也在用这个惯用法（`core/completion/completion.lua`）
- 数字：目标工程 **130 → 109（移除 21 / 新增 0）**；基线存 `tmp/scan-109.txt`
- 状态：成立（2026-10-08）

## T4 目标侧 `uri | nil` 一族（9 条）：folder 作用域用子类给出必有的 uri

- 背景：`script/workspace/scope.lua` 的 `---@field uri? uri` 是给 override / fallback 作用域用的
  （它们确实没有 uri），但 `scope.folders` / `workspace.folders` 里全是 **folder** 作用域
  （只有 `scope.createFolder` 会建、且必然设 uri）⇒ `for _, scp in ipairs(scope.folders)` 里
  `scp.uri` 一律带 nil，9 条 `param-type-mismatch`（`furi.decode(scp.uri)` / `ws.isReady(scp.uri)` 一族）。
- 落地（目标工程 2 文件 12 行）：
  - 新增 `---@class scope.folder: scope` + `---@field uri uri`（注释写明只有 override/fallback 没有 uri）
  - `m.folders`（含 `workspace.m.folders`）改 `scope.folder[]`；`createFolder` 返回 `scope.folder`
    （函数尾 `return scope--[[@as scope.folder]]` —— 内联 cast 对 **return** 检查有效）
  - 顺带修正两处被暴露出来的注解不符（都零运行影响）：`scope._links` 声明 `table<uri, boolean>`
    → `table<uri, true>`（实际只写 `true`/nil）；`mt:eachLink` 的返回 `fun(): uri` → `next` 的真实形状
    `fun(t: table<uri, true>, i?: uri): uri?`（该方法在目标里没有调用方）
- 实验数字（逐步）：只加子类 ⇒ 109 → 106（移除 6 / **新增 3**：`createScope 'folder'` 赋值与两处注解不符）
  ⇒ 补掉那 3 条后 **109 → 103（移除 6 / 新增 0）**，基线存 `tmp/scan-104.txt`（内容即 103 条）
- 残留（**属引擎侧，另轮**）：5 条全是 F4「值位置 `and`/`or` 的右操作数拿不到左侧收窄」——
  `libUri and furi.decode(libUri)`、`uri and ('%08x'):format(...)`、`A and B` 形式；
  修法方向见 `narrowing.md` F4（把左侧真值收窄传给右操作数）。
- 状态：成立（2026-10-08）


