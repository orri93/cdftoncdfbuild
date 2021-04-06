@ECHO OFF

SETLOCAL ENABLEEXTENSIONS

SET PROJECT_ROOT_DIR=..
CALL:MakeAbsolute PROJECT_ROOT_DIR "%~dp0"

SET PROJECT_NAME=CDF to NetCDF Build

SET EXE_WGET=wget
SET EXE_TAR=tar

ECHO ---------------------------------------------------------------------------
ECHO Initialize script for the %PROJECT_NAME%
ECHO %PROJECT_NAME% root directory is defined as %PROJECT_ROOT_DIR%

SET WD=%PROJECT_ROOT_DIR%\tmp
ECHO Entering %WD%
PUSHD "%WD%"
"%EXE_WGET%" https://spdf.gsfc.nasa.gov/pub/software/cdf/conversion_tools/source/cdf-to-netcdf.tar.gz
ECHO Leaving %WD%
POPD

SET CDF_TAR_PATH=%PROJECT_ROOT_DIR%\tmp\cdf-to-netcdf.tar.gz

SET WD=%PROJECT_ROOT_DIR%\cdf-to-netcdf
PUSHD "%WD%"
"%EXE_TAR%" xzf "%CDF_TAR_PATH%"
ECHO Leaving %WD%
POPD


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
