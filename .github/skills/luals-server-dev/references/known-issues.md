# 已知问题 / 待办

- **忽略 `meta/` 目录下的所有警告**（分析器自举自身的 meta 文件时产生的 `undefined-doc-name`、`duplicate-doc-field` 等属于正常现象，不必处理）。
- **类型求值无深度守卫**：`Node` 的 `value`/`matchedFuncs`/`allEquivalents` 等值链递归求值没有深度限制。childs 改为强表后节点常驻，值链完整，深类型链（如穿过 `VM.Vfile.coder → Node 全类层级` 的表达式）在全量求值时会触发 C stack overflow。`test/project/self.lua` 的全量遍历已按节点 pcall 兜底并统计溢出数；真实 LSP 请求命中同类深链时同样可能溢出，根治需要在求值器加深度计数或改迭代，属 node 层独立任务。
