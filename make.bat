git submodule update --init --recursive
cd 3rd\luamake
call compile\install.bat
cd ..\..
call 3rd\luamake\luamake.exe rebuild
