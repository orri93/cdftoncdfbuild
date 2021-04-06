@ECHO OFF

SETLOCAL ENABLEEXTENSIONS

SET PROJECT_ROOT_DIR=..
CALL:MakeAbsolute PROJECT_ROOT_DIR "%~dp0"

SET PROJECT_NAME=CDF to NetCDF dependencies

SET EXE_CMAKE=cmake.exe
SET EXE_CTEST=ctest.exe

REM Set build variables
SET BUILD_CONFIG=RelWithDebInfo

IF "%1" == "noclean" GOTO not_clean
IF "%1" == "notclean" GOTO not_clean
IF "%1" == "Noclean" GOTO not_clean
IF "%1" == "Notclean" GOTO not_clean
IF "%1" == "noClean" GOTO not_clean
IF "%1" == "notClean" GOTO not_clean
IF "%1" == "NoClean" GOTO not_clean
IF "%1" == "NotClean" GOTO not_clean
GOTO check_not_clean_done
:not_clean
ECHO Not Clean detected
SET NOT_CLEAN=NotClean
SHIFT
:check_not_clean_done

IF "%1" == "nobuild" GOTO not_build
IF "%1" == "nobuilds" GOTO not_build
IF "%1" == "notbuild" GOTO not_build
IF "%1" == "notbuilds" GOTO not_build
IF "%1" == "noBuild" GOTO not_build
IF "%1" == "noBuilds" GOTO not_build
IF "%1" == "notBuild" GOTO not_build
IF "%1" == "notBuilds" GOTO not_build
IF "%1" == "NoBuild" GOTO not_build
IF "%1" == "NoBuilds" GOTO not_build
IF "%1" == "NotBuild" GOTO not_build
IF "%1" == "NotBuilds" GOTO not_build
SET BUILDING=ON
GOTO no_build_done
:not_build
ECHO No Build detected
SET BUILDING=OFF
SHIFT
:no_build_done

IF "%1" == "" GOTO no_build_number
SET BUILD_NUMBER=%1
GOTO build_number_done
:no_build_number
SET BUILD_NUMBER=0
:build_number_done
SHIFT

SET CMAKE_SYSTEM=Visual Studio 16 2019
REM SET CMAKE_SYSTEM=MinGW Makefiles
REM SET CMAKE_PLATFORM=x64

ECHO ---------------------------------------------------------------------------
ECHO Build script for the %PROJECT_NAME% hdf5
ECHO %PROJECT_NAME% root directory is defined as %PROJECT_ROOT_DIR%

SET PROJECT_SRC_DIR=%PROJECT_ROOT_DIR%\extern\hdf5

SET PROJECT_BUILD_DIR=%PROJECT_ROOT_DIR%\build\hdf5\%BUILD_CONFIG%
SET PROJECT_ARTIFACTS_DIR=%PROJECT_ROOT_DIR%\artifacts\hdf5\%BUILD_CONFIG%

SET CMAKE_CREATE_OPTIONS=^
-DCMAKE_INSTALL_PREFIX:PATH="%PROJECT_ARTIFACTS_DIR%" ^
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=On ^
-G "%CMAKE_SYSTEM%" ^
"%PROJECT_SRC_DIR%"

ECHO - Build number is defined as %BUILD_NUMBER%
ECHO - Install path is defined as "%PROJECT_ARTIFACTS_DIR%"
ECHO - CMake buld system is defined as "%CMAKE_SYSTEM%"
ECHO - CMake buld directory is defined as "%PROJECT_BUILD_DIR%"
ECHO - CMake buld configuration is defined as "%BUILD_CONFIG%"

SET CMAKE_BUILD_OPTIONS=--build "%PROJECT_BUILD_DIR%" --config %BUILD_CONFIG%
SET CMAKE_INSTALL_OPTIONS=--build "%PROJECT_BUILD_DIR%" --target install --config %BUILD_CONFIG%

SET CTEST_OPTIONS=--build-config %BUILD_CONFIG%

IF "%NOT_CLEAN%" == "NotClean" GOTO do_not_clean
IF EXIST "%PROJECT_BUILD_DIR%" (
  ECHO The build folder already exists so deleting the old
  "%EXE_CMAKE%" -E remove_directory "%PROJECT_BUILD_DIR%"
)
IF EXIST "%PROJECT_ARTIFACTS_DIR%" (
  ECHO The artifacts folder already exists so deleting the old
  "%EXE_CMAKE%" -E remove_directory "%PROJECT_ARTIFACTS_DIR%"
)
:do_not_clean

ECHO Creating a build folder %PROJECT_BUILD_DIR%
"%EXE_CMAKE%" -E make_directory "%PROJECT_BUILD_DIR%"

ECHO *** Creating a Build
SET CMAKE_CREATE_BUILD_CMD="%EXE_CMAKE%" -E chdir "%PROJECT_BUILD_DIR%" "%EXE_CMAKE%" %CMAKE_CREATE_OPTIONS%
ECHO %CMAKE_CREATE_BUILD_CMD%
%CMAKE_CREATE_BUILD_CMD%

IF "%BUILDING%" == "OFF" GOTO do_not_build
ECHO *** Building
SET CMAKE_BUILD_CMD="%EXE_CMAKE%" %CMAKE_BUILD_OPTIONS%
ECHO %CMAKE_BUILD_CMD%
%CMAKE_BUILD_CMD%

ECHO *** Testing
SET CMAKE_CTEST_CMD="%EXE_CMAKE%" -E chdir "%PROJECT_BUILD_DIR%" "%EXE_CTEST%" %CTEST_OPTIONS%
ECHO %CMAKE_CTEST_CMD%
%CMAKE_CTEST_CMD%
:do_not_build

ECHO *** Installing
SET CMAKE_INSTALL_CMD="%EXE_CMAKE%" %CMAKE_INSTALL_OPTIONS%
ECHO %CMAKE_INSTALL_CMD%
%CMAKE_INSTALL_CMD%

ECHO ---------------------------------------------------------------------------

REM Done
GOTO:EOF


::----------------------------------------------------------------------------------
:: Function declarations
:: Handy to read http://www.dostips.com/DtTutoFunctions.php for how dos functions
:: work.
::----------------------------------------------------------------------------------
:MakeAbsolute file base -- makes a file name absolute considering a base path
::                      -- file [in,out] - variable with file name to be converted, or file name itself for result in stdout
::                      -- base [in,opt] - base path, leave blank for current directory
:$created 20060101 :$changed 20080219 :$categories Path
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set "src=%~1"
if defined %1 set "src=!%~1!"
set "bas=%~2"
if not defined bas set "bas=%cd%"
for /f "tokens=*" %%a in ("%bas%.\%src%") do set "src=%%~fa"
( ENDLOCAL & REM RETURN VALUES
    IF defined %1 (SET %~1=%src%) ELSE ECHO.%src%
)
EXIT /b
