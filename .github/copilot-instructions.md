# Coding Instructions

## PowerShell 文件编码

- Windows PowerShell 默认编码为 GBK/UTF-16 LE，**严禁**写入项目文件时不指定编码（会导致 UTF8 文件乱码）
- `Set-Content`、`Out-File`、`echo >`、`Write-Output >` 等写入操作必须加 `-Encoding UTF8`
- 正确示例：`Set-Content -Path file.ts -Value "..." -Encoding UTF8`
- 项目所有源码文件统一 UTF-8（无 BOM），由 `.editorconfig` 和 ESLint 兜底
