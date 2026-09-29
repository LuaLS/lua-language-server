# Tasks

- [x] 停掉候选 ②（`tracer.lua:1053-1062` 的 `W:traceCallEqual` 间接窄化）并跑目标扫描
- [x] 实测：目标项 30/31 消失，但整体 移除 6 / 新增 7（218 → 219）⇒ 承重机制，不可整段停
- [x] 停掉 ② 后探针复现文件：`ret` 各位置回到 `repro.Obj` ⇒ 候选 ① 不是成因
- [x] 二分补丁回退（`git checkout -- script/node/tracer.lua`）
- [x] 目标侧试探：`vm/function.lua:291` 放宽参数注解 → 218 → 217（移除 2 / 新增 1）⇒ 未采用，手工回退
- [x] 回退后复扫：基线 218 → 218（移除 0 / 新增 0）
- [x] 台账 `facts/returns.md` F3 追加二分结论与归因更正，并跑 `--test tools.facts`
- [x] 纪要写进 `项目实践.md`（第十九轮）
- [x] `bin\lua-language-server.exe --test` 全量绿；面板 0
