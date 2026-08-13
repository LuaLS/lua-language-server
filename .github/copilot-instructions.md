# Coding Instructions

## PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底

## 长耗时命令轮询

- 后台运行的长时间命令（如 `test.lua` 完整测试、`build-doc.lua`）**不会自动通知完成**，必须主动轮询结果文件确认
- 完整测试：检查 `temp/test_full*.log` 是否出现 `test finish.`（无 error 即通过；full 阶段耗时较长，需多次轮询）
- build-doc：检查退出码 `DOC=0`
- 轮询方式：读取日志文件末尾或 `grep` 结束标记，间隔由命令耗时决定，不要依赖系统通知
