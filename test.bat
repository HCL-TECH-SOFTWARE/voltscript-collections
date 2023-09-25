@echo off
setlocal
setlocal enableDelayedExpansion

set CLEAN=0

:parse_arguments
  if "%1" == "" goto main

  if "%1" == "--clean" set CLEAN=1 & goto ok
  if "%1" == "-c"      set CLEAN=1 & goto ok

  if "%1" == "--help"  goto show_help
  if "%1" == "-h"      goto show_help

  echo Unknown parameter: %1
  exit /b 1
:ok
  shift
  goto parse_arguments

:main
rem Initialize the building environment
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsx86_amd64.bat"

if %CLEAN% == 1 (
  if exist bin\VoltScript del /S /Q bin\VoltScript
  if exist bin\JsonVSE del /S /Q bin\JsonVSE
  if exist bin\seti.ini del bin\seti.ini
)

if not exist bin\VoltScript md bin\VoltScript
if not exist bin\JsonVSE md bin\JsonVSE

set VOLTSCRIPT_LATEST=Develop

rem Download VoltScript binary from Nexus
if not exist bin\VoltScript\VoltScript.exe (
  echo Checking for latest version of VoltScript on Nexus...
  curl -o bin\VoltScript\LATEST-develop.win64 https://nexus.qs.hcllabs.net/repository/labs-binary/BaliAlone/LATEST-develop.win64
  set /P VOLTSCRIPT_LATEST=<bin\VoltScript\LATEST-develop.win64
)
if not exist bin\VoltScript\VoltScript.exe (
  echo Downloading %VOLTSCRIPT_LATEST%...
  curl -o bin\VoltScript\voltscript-develop-latest.zip https://nexus.qs.hcllabs.net/repository/labs-binary/BaliAlone/%VOLTSCRIPT_LATEST%
  powershell -nologo -noprofile Expand-Archive bin\VoltScript\voltscript-develop-latest.zip -DestinationPath bin\VoltScript\
)

rem Download JsonVSE binary from Nexus
if not exist bin\JsonVSE\JsonVSE.dll (
  echo Checking for latest version of JsonVSE on Nexus...
  curl -o bin\JsonVSE\LATEST-develop.win64 https://nexus.qs.hcllabs.net/repository/labs-binary/JsonLSX/LATEST-develop.win64
  set /P JSONVSE_LATEST=<bin\JsonVSE\LATEST-develop.win64
)
if not exist bin\JsonVSE\JsonVSE.dll (
  echo Downloading %JSONVSE_LATEST%...
  curl -o bin\JsonVSE\jsonvse-develop-latest.zip https://nexus.qs.hcllabs.net/repository/labs-binary/JsonLSX/%JSONVSE_LATEST%
  powershell -nologo -noprofile Expand-Archive bin\JsonVSE\jsonvse-develop-latest.zip -DestinationPath bin\JsonVSE\
)

rem Add VSE dependencies to seti.ini
if not exist bin\seti.ini (
  echo [VoltScriptExtensions\2.0\Windows]>bin\seti.ini
  echo JsonVSE=%cd%\bin\JsonVSE\JsonVSE.dll>>bin\seti.ini
)

rem Run tests
set PATH=%cd%\bin\VoltScript;%PATH%
cd test
set VOLTSCRIPT_CMD=..\bin\VoltScript\VoltScript.exe

if not exist %VOLTSCRIPT_CMD% (
  echo Extracting VoltScript binary failed, exiting.
  exit /b 1
)

echo VoltScript version:
%VOLTSCRIPT_CMD% --version

echo Running unit tests...
%VOLTSCRIPT_CMD% -v --seti ..\bin\seti.ini runAllTests.vss

cd ..

goto exit_script

:show_help
  echo test.bat [--clean]

:exit_script
  exit /b 0
