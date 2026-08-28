# 已知问题 / 待办

- **忽略 `meta/` 目录下的所有警告**（分析器自举自身的 meta 文件时产生的 `undefined-doc-name`、`duplicate-doc-field` 等属于正常现象，不必处理）。
- **类型求值无深度守卫**：`Node` 的 `value`/`matchedFuncs`/`allEquivalents` 等值链递归求值没有深度限制。childs 改为强表后节点常驻，值链完整，深类型链（如穿过 `VM.Vfile.coder → Node 全类层级` 的表达式）在全量求值时会触发 C stack overflow。`test/project/self.lua` 的全量遍历已按节点 pcall 兜底并统计溢出数；真实 LSP 请求命中同类深链时同样可能溢出，根治需要在求值器加深度计数或改迭代，属 node 层独立任务。
- **truthy/falsy 自引用环已修**（2026-08-28）：溢出真因是 `Intersection` 带 `otherParts`（如 `{} & function`，即 `setmetatable + __index` 模式）时 `value` getter 返回自身，而 `Intersection` 的 truthy/falsy getter 缺少基类同款的 `value == self` 短路 → 自引用无限递归（每层 2 个 C 帧，~993 层耗尽 C 栈）。已对齐基类短路，getter 保持项目统一的 `__getter` 惯例。**决策：不加深度守卫、不改显式方法**——未来若引入新的自引用环，应让它以 C stack overflow 显性暴露（配合 xpcall handler 抓完整栈定位），而非被兜底静默降级；`value`/`findValue` 等其他递归链目前无守卫，维持裸奔暴露。
