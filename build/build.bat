@echo off
setlocal enableextensions enabledelayedexpansion
set RAYLIB_LIB=..\external\raylib\build\raylib\Debug
set target_src_dir=..\src
set target=main
set target_include=-I..\external\raylib\build\raylib\include\ -I..\external\raygui\src -I..\external\raygui\examples\styles
set target_src=
@REM set target_lib=gdi32.lib raylib.lib winmm.lib /libpath:..\raylib\build\raylib\Debug
set target_lib=/libpath:%RAYLIB_LIB% raylib.lib winmm.lib gdi32.lib opengl32.lib user32.lib kernel32.lib shell32.lib /NODEFAULTLIB:libcmt
set target_flags=
set compiler=cl
set configuration=debug
REM  set verbose=/VERBOSE
set verbose=

for %%a in (%*) do (
    set target=%%a
)

set target_c=!target_src_dir!\!target!.c
set target_exe=!target!.exe

if not exist bin mkdir bin

echo -------------------------------------------------
echo - Compiler:      %compiler%
echo - Include:       %include_dirs%
echo - Configuration: %configuration%
echo - Target C:      %target%.c
echo - Output:        bin\%target_exe%
echo -------------------------------------------------

rem MT for statically linked CRT, MD for dynamically linked CRT
set win_runtime_lib=MDd
set common_c=!target_c! !target_tests! !target_src! /Fe!target_exe! -nologo !target_flags! -FC -EHa- !target_include!
set common_l=!verbose! !target_lib!

echo.
echo Compiling...
pushd bin
    cl !common_c! -!win_runtime_lib! -Od /Z7 /link !common_l!
    if "%ERRORLEVEL%" EQU "0" (
        goto good
    )
    if "%ERRORLEVEL%" NEQ "0" (
        goto bad
    )
:good
    echo.
    xcopy !target_exe! ..\build /i /y
    echo Running !target_exe!...
    echo.
    !target_exe!
    goto done
:bad
    echo FAILED
    goto done
:done

popd

:end
