@echo off
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
SetLocal EnableDelayedExpansion

SET CPP_FILES=
FOR /R "./src" %%f in (*.cpp) do (
    if "%%~xf"==".cpp" SET CPP_FILES=!CPP_FILES! %%f
)
echo Files:%CPP_FILES%

rmdir /s /Q bin
mkdir obj bin

SET CXX_FLAGS=/Fo.\obj\ -MTd /EHsc -WL -Od -FC -Zi
SET INCLUDE_DIR=/I %cd%\src\ /I %cd%\3dparty\
SET LD_FLAGS=/link /LIBPATH:"%cd%\lib" -incremental:no -opt:ref kernel32.lib ^
user32.lib ^
gdi32.lib ^
winspool.lib ^
comdlg32.lib ^
advapi32.lib ^
shell32.lib ^
ole32.lib ^
oleaut32.lib ^
uuid.lib ^
odbc32.lib ^
odbccp32.lib
:: write your project link libraries intoo LINK_LIBRARIES
SET LINK_LIBRARIES= 
SET LD_FLAGS=%LD_FLAGS% %LINK_LIBRARIES% /SUBSYSTEM:CONSOLE /out:.\bin\main.exe
SET DEFINE_FLAGS=-D_DEBUG -D_CRT_SECURE_NO_WARNINGS -D_CONSOLE
cl %CXX_FLAGS% %DEFINE_FLAGS% %CPP_FILES% %INCLUDE_DIR% /DEBUG %LD_FLAGS%
rmdir /s /Q obj
:: copy dll files into bin to be able to run it
IF EXIST ".\lib\*.dll" copy /Y ".\lib\*.dll" "./bin"
del *.pdb
echo Error: %ERRORLEVEL%
