# Proposal

## Why

`not <exp>`（值位置）由 coder 的 unary provider 包成 flow 里的 `{'not', ...}` 节点
（`script/vm/coder/exp.lua` 的 `tracer:openNode(source.op)`），但 walker 的
`W:traceUnit` **没有 `'not'` 分支**（只认 `var/ref/if/condition/link/cast/nonnil/seed/and/or/call`）
⇒ 它内部的操作数 `ref` 从来不被走，那些读点拿不到 `currentValue`，读值退化到
`getStaticValue()` / `getGuessValue()` 兜底（同 `narrowing.md` F27 的症状，但成因不同）。

用户看到的实例：目标工程 `script/plugins/astHelper.lua:72`

```lua
function _M.addClassDocAtParam(ast, classname, source, index)
    local arg = _M.removeArg(source, index)      -- parser.object?
    if arg then
        return not not _M.addClassDoc(ast, arg, classname), arg
        --                           ^^^ 报 Cannot assign `parser.object | nil` to parameter `parser.object`
    end
    return false
end
```

证据（探针）：
- 同一行的**返回值读** `var:arg@72:61-72:63`：`currentValue = parser.object` ✓（收窄了）
- **实参读** `var:arg@72:44-72:46`：`currentValue = nil`、`staticValue = parser.object | nil` ✗
- 插桩 `W:traceRef`：整轮**没有一次**以该别名进入（说明 flow 里那段 ref 没被走）
- flow 实际形状（`--probe-flow`）：`{'if', {'return', {'condition', ref arg@71}, {'not', {'not', {refs...}, {call...}}}}}` —— 实参 ref 嵌在 `'not'` 里
- 旁证：`test/node/tracer.lua` 里同样是值位置的 `and`/`or` 已有专门分支（注释写明「遍历内部 ref，
  使其获得正确的 currentValue，避免退化到 getGuessValue 引入 nil」），`not` 漏了

## What Changes

- `W:traceUnit` 的 `'and' / 'or'` 分支扩到 `'not'`：值位置的 `not` 也遍历内部 unit，
  让内部 ref 拿到 `currentValue`（不做真值收窄 —— 不是条件位置）。

## 基线（改前 → 改后）

- 目标工程 `d:\github\vscode-lua\server`：**156 → 154（移除 2 / 新增 0）**
  （基线 `tmp/scan-156.txt`，比对 `tmp/cmp-not-unit2.txt`；扫描耗时 10.41s，无回归）
  - `script/plugins/astHelper.lua:72`（`param-type-mismatch`，用户报的这条）
  - `script/core/diagnostics/undefined-doc-name.lua:26`（同族）

## 语义依据

- 值位置的 `not`/`and`/`or` **不做真值收窄**（`narrowing.md` F4 的既定语义），
  但它的操作数是**真实读取点**，必须被走一遍才能拿到该位置的值；漏走只会让读值退化成兜底值。
- 与 F27 的区别：F27 是「算过又被 flush 清掉」，本条是「压根没算」；
  两者症状相同（读值带 nil），修法互不相干。

## Capabilities

### Modified Capabilities

- `narrowing`: 新增要求 —— 值位置的 `not` 表达式节点，其内部读取点 SHALL 被走一遍
  （与 `and`/`or` 同待遇），SHALL NOT 因此对其操作数做真值收窄。

## Impact

- `script/node/tracer.lua`：`W:traceUnit` 一个分支。
- 测试：`test/node/tracer.lua` 加一条（`not not v` 里的读点在守卫内应得 `integer`；
  撤掉修法立刻变 `integer | nil`，已实测）。
