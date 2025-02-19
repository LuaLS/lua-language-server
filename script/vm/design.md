初始化
1. 遍历所有的meta文件，调用 `vfile:indexAst(ast, 'meta')`，提取 `class` `field` `alias` 全局变量等。内部会提交全局贡献。
2. 遍历所有的非meta文件，调用 `vfile:indexAst(ast, 'common')`，提取 `class` `field` `alias` 全局变量等。内部会提交全局贡献。
  这个过程不会进行语义分析，也就是说提取出来的类可能会缺少字段（比如在方法内定义的字段）
3. 按需执行runner（先检查是否绑定过语义或推测，然后检查是否分配过runner）
    1. 调用 `vfile:createRunner(block)` 为每个block分配一个runner，从上至下的遍历block，递归解析语义
    2. 调用 `runner:infer(source, node)` 绑定语义
    3. 调用 `runner:contribute(action)` 提交全局贡献
    4. 调用 `runner:guess(source, node)` 为无法推测的变量绑定猜测
4. 当文件发生变化时？
   1. 调用 `vfile:resetContribute()` 清空全局贡献
   2. 调用 `vfile:resetRunners()` 清空runner
   3. 重新提交全局贡献
