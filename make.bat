git submodule update --init --recursive
cd 3rd\luamake
call compile\build.bat
cd ..\..
IF "%~1"=="" (
    call 3rd\luamake\luamake.exe rebuild
) ELSE (
    call 3rd\luamake\luamake.exe rebuild --platform %1
)
