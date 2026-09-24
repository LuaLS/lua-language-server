# Tasks

（结论：不采用，见 proposal.md「实测结论」。以下为实做记录）

- [x] 存目标工程基线：`--save=tmp/scan-before-error-never.txt` → 278 条
- [x] 做法 A：`meta/template/basic.lua` + `meta/whimsical/basic.lua` 的 `error` 加 `---@return never`
- [x] 跑目标工程比对 → 278 → 278（移除 0 / 新增 0）：**惰性**，终止判定只看语法（`block.exits`）
- [x] 做法 B′：`script/node/tracer.lua` 增加 `traceCallStatement`（语句级调用返回 `never` ⇒ 该分支不落地），
      并让 `traceIfChild` 的 `terminated` 合并保留它（`terminated or stack.terminated`）
- [x] 跑全量 `--test`（绿）+ 目标工程比对 → 278 → **281**（移除 1 / 新增 4）
- [x] 判据比对：净变差（+3），且目标工程 meta 的 `error` 覆盖了我们的注解，`tools/lua51.lua:201-203` 未修掉
- [x] 回退全部实验改动（`git checkout -- meta script/node/tracer.lua`），目标工程回到 278
- [x] 把结论写进事实台账（F15 更新为「实测：A 惰性、A+B′ 净 +3，不采用」）
- [x] 归档本 change（`skip_specs: true`，不产生 spec 增量）
