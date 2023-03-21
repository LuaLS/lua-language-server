---@meta

---@alias bee.platform.os
---| '"windows"'
---| '"android"'
---| '"linux"'
---| '"netbsd"'
---| '"freebsd"'
---| '"openbsd"'
---| '"ios"'
---| '"macos"'
---| '"unknown"'

---@alias bee.platform.OS
---| '"Windows"'
---| '"Android"'
---| '"Linux"'
---| '"NetBSD"'
---| '"FreeBSD"'
---| '"OpenBSD"'
---| '"iOS"'
---| '"macOS"'
---| '"unknown"'

---@alias bee.platform.arch
---| '"x86"'
---| '"x86_64"'
---| '"arm"'
---| '"arm64"'
---| '"riscv"'
---| '"unknown"'

---@alias bee.platform.compiler
---| '"clang"'
---| '"gcc"'
---| '"msvc"'
---| '"unknown"'

---@alias bee.platform.crt
---| '"msvc"'
---| '"bionic"'
---| '"libstdc++"'
---| '"libc++"'
---| '"unknown"'

local m = {
    ---@type bee.platform.os
    os = "unknown",
    ---@type bee.platform.OS
    OS = "unknown",
    ---@type bee.platform.compiler
    Compiler = "clang",
    CompilerVersion = "",
    CRTVersion = "",
    ---@type bee.platform.crt
    CRT = "msvc",
    ---@type bee.platform.arch
    Arch = "x86",
    DEBUG = false,
}

return m
