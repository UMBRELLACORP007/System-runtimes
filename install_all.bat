@echo off
setlocal EnableExtensions EnableDelayedExpansion
CD /d "%~dp0"

echo.
echo Installing all runtime packages and prerequisites...
echo.

set "EXITCODE=0"

set "IS_X64=0"
if /i "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "IS_X64=1"
if /i "%PROCESSOR_ARCHITEW6432%"=="AMD64" set "IS_X64=1"

call :RunInstaller "dxwebsetup.exe" "/q"
call :RunInstaller "NDP481-Web.exe" "/q /norestart"
call :RunInstaller "dotnet-sdk-9.0.314-win-x64.exe" "/install /quiet /norestart"

if "%IS_X64%"=="1" (
  call :RunInstaller "vcredist2005_x86.exe" "/q"
  call :RunInstaller "vcredist2005_x64.exe" "/q"
  call :RunInstaller "vcredist2008_x86.exe" "/qb"
  call :RunInstaller "vcredist2008_x64.exe" "/qb"
  call :RunInstaller "vcredist2010_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2010_x64.exe" "/passive /norestart"
  call :RunInstaller "vcredist2012_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2012_x64.exe" "/passive /norestart"
  call :RunInstaller "vcredist2013_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2013_x64.exe" "/passive /norestart"
  call :RunInstaller "vcredist2015_2017_2019_2022_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2015_2017_2019_2022_x64.exe" "/passive /norestart"
) else (
  call :RunInstaller "vcredist2005_x86.exe" "/q"
  call :RunInstaller "vcredist2008_x86.exe" "/qb"
  call :RunInstaller "vcredist2010_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2012_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2013_x86.exe" "/passive /norestart"
  call :RunInstaller "vcredist2015_2017_2019_2022_x86.exe" "/passive /norestart"
)

echo.
if "%EXITCODE%"=="0" (
  echo Installation completed successfully
) else (
  echo Installation completed with errors. Exit code: %EXITCODE%
)
exit /b %EXITCODE%

:RunInstaller
set "FILE=%~1"
set "ARGS=%~2"
if not exist "%FILE%" (
  echo Skipping missing installer: %FILE%
  if %EXITCODE%==0 set "EXITCODE=2"
  goto :eof
)
echo Running %FILE%...
start /wait "" "%FILE%" %ARGS%
set "RC=%ERRORLEVEL%"
if not "%RC%"=="0" (
  echo Failed: %FILE% (exit code %RC%)
  if %EXITCODE%==0 set "EXITCODE=%RC%"
)
goto :eof