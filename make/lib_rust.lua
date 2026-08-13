-- Rust dynamic library (crates/rust).
--
-- cargo builds the whole workspace and we copy the produced shared library into
-- `bin/` so the server can `require 'rust'`. cargo names cdylibs `librust.so` /
-- `librust.dylib` on unix, but the server's package.cpath only searches for
-- `?.so` (and `?.dll` on windows), so the copy is renamed accordingly.
--
-- Environment:
--   RUST_TARGET    optional cargo target triple, e.g. `aarch64-unknown-linux-gnu`
--                  or `x86_64-unknown-linux-gnu.2.17` (with zigbuild). When unset
--                  no `--target` is passed and cargo builds for the host.
--   RUST_ZIGBUILD  when set, `cargo-zigbuild` is used instead of `cargo build`.
--                  On CI this links against an old glibc and avoids glibc-version
--                  incompatibilities on old distributions.
local lm = require 'luamake'

local rustName = lm.os == 'windows' and 'rust.dll'
    or lm.os == 'macos' and 'librust.dylib'
    or 'librust.so'
local rustBinName = lm.os == 'windows' and 'rust.dll' or 'rust.so'
local cargoProfile = lm.mode == 'debug' and 'debug' or 'release'

local rustTarget = os.getenv('RUST_TARGET')

-- cargo (and cargo-zigbuild) strip a glibc version suffix (e.g. `.2.17`) from
-- the target triple when naming the artifact directory, so the output lives
-- under `target/<base-triple>/` while `--target` still gets the full triple.
local rustTargetDir = rustTarget and rustTarget:match '^([^.]+)'
local targetDir  = rustTargetDir and ('target/' .. rustTargetDir) or 'target'
local rustOutput = targetDir .. '/' .. cargoProfile .. '/' .. rustName

local zigbuild = os.getenv('RUST_ZIGBUILD')
zigbuild = zigbuild and zigbuild ~= '0' and zigbuild ~= 'false'

local cargoArgs = {
    'cargo',
    zigbuild and 'zigbuild' or 'build',
    '--workspace',
    '--manifest-path', 'Cargo.toml',
}
if cargoProfile == 'release' then
    cargoArgs[#cargoArgs + 1] = '--release'
end
if rustTarget then
    cargoArgs[#cargoArgs + 1] = '--target'
    cargoArgs[#cargoArgs + 1] = rustTarget
end

lm:rule 'cargo-build' {
    args = cargoArgs,
    description = ('cargo %s rust'):format(zigbuild and 'zigbuild' or 'build'),
    pool = 'console',
}

lm:build 'build_rust' {
    rootdir = '..',
    rule = 'cargo-build',
    inputs = {
        'Cargo.toml',
        'Cargo.lock',
        'crates/**/Cargo.toml',
        'crates/**/*.rs',
    },
    outputs = { rustOutput },
}

lm:copy 'copy_rust' {
    rootdir = '..',
    inputs = { rustOutput },
    outputs = { 'bin/' .. rustBinName },
    deps = 'build_rust',
}
