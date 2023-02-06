git submodule update --init --recursive
cd 3rd\luamake
compile\install.bat
cd ..\..
3rd\luamake\luamake.exe rebuild
pause
