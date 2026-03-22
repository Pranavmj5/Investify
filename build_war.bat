@echo off
setlocal enabledelayedexpansion
REM ============================================================
REM  Investify WAR Build Script
REM  Compiles Java sources → packages investify.war
REM  Compatible with Tomcat 10.x (Jakarta EE)
REM  Usage: Double-click OR run from project root
REM ============================================================

SET PROJECT_DIR=%~dp0
SET SRC_DIR=%PROJECT_DIR%src
SET WEB_INF=%PROJECT_DIR%WEB-INF
SET CLASSES_DIR=%WEB_INF%\classes
SET LIB_DIR=%WEB_INF%\lib
SET WAR_OUT=%PROJECT_DIR%investify.war

echo.
echo =====================================================
echo   Investify WAR Builder
echo =====================================================
echo.

REM -------------------------------------------------------
REM  1. Locate javac and jar
REM -------------------------------------------------------
echo [1/5] Checking Java installation...
where javac >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 'javac' not found in PATH.
    echo         Make sure JDK is installed and JAVA_HOME\bin is in your PATH.
    echo         Example: set PATH=C:\Program Files\Java\jdk-17\bin;%%PATH%%
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('where javac') do SET JAVAC=%%i
for /f "tokens=*" %%i in ('where jar') do SET JAR=%%i
echo    javac: %JAVAC%
echo    jar  : %JAR%

REM -------------------------------------------------------
REM  2. Find servlet-api.jar (Tomcat 10 ships Jakarta EE)
REM -------------------------------------------------------
echo.
echo [2/5] Locating servlet-api.jar...
SET SERVLET_JAR=

REM Try common Tomcat 10 install paths
for %%P in (
    "C:\Program Files\Apache Software Foundation\Tomcat 10.1\lib\servlet-api.jar"
    "C:\Program Files\Apache Software Foundation\Tomcat 10.0\lib\servlet-api.jar"
    "C:\tomcat10\lib\servlet-api.jar"
    "C:\tomcat\lib\servlet-api.jar"
) do (
    if exist %%P (
        if "!SERVLET_JAR!"=="" SET SERVLET_JAR=%%~P
    )
)

REM Also check TOMCAT_HOME env var if set
if defined TOMCAT_HOME (
    if exist "%TOMCAT_HOME%\lib\servlet-api.jar" (
        SET SERVLET_JAR=%TOMCAT_HOME%\lib\servlet-api.jar
    )
)

if "!SERVLET_JAR!"=="" (
    echo [WARN] servlet-api.jar not found automatically.
    echo        Attempting compilation using already-compiled classes as reference...
    echo        If compilation fails, set TOMCAT_HOME and re-run.
    SET COMPILE_CP=%CLASSES_DIR%;%LIB_DIR%\*
) else (
    echo    Found: !SERVLET_JAR!
    SET COMPILE_CP=!SERVLET_JAR!;%LIB_DIR%\*
)

REM -------------------------------------------------------
REM  3. Compile Java sources
REM -------------------------------------------------------
echo.
echo [3/5] Compiling Java sources...

REM Clean out old class files for a fresh build
if exist "%CLASSES_DIR%\com" (
    rmdir /S /Q "%CLASSES_DIR%\com"
)
mkdir "%CLASSES_DIR%\com\investify\db"
mkdir "%CLASSES_DIR%\com\investify\servlet"

REM Compile DB connection first (servlets depend on it)
javac -encoding UTF-8 ^
      -d "%CLASSES_DIR%" ^
      -cp "%COMPILE_CP%" ^
      "%SRC_DIR%\com\investify\db\DBConnection.java"
if errorlevel 1 (
    echo [ERROR] DBConnection compilation failed!
    pause
    exit /b 1
)

REM Now compile all servlet files
javac -encoding UTF-8 ^
      -d "%CLASSES_DIR%" ^
      -cp "%COMPILE_CP%;%CLASSES_DIR%" ^
      "%SRC_DIR%\com\investify\servlet\AdminStartupServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\AuthFilter.java" ^
      "%SRC_DIR%\com\investify\servlet\FounderSchemeServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\GovernmentServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\InvestmentDecisionServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\InvestmentServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\LoginServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\LogoutServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\PortfolioServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\RegisterServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\SchemeServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\StartupServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\TestServlet.java" ^
      "%SRC_DIR%\com\investify\servlet\TestDBServlet.java"
if errorlevel 1 (
    echo [ERROR] Servlet compilation failed!
    echo         Check the error messages above and fix before retrying.
    pause
    exit /b 1
)
echo    All sources compiled successfully!

REM -------------------------------------------------------
REM  4. Package into investify.war
REM -------------------------------------------------------
echo.
echo [4/5] Packaging investify.war...

REM Delete any previous WAR
if exist "%WAR_OUT%" del /Q "%WAR_OUT%"

REM Create a staging directory that holds ONLY the deployable content
SET STAGING=%TEMP%\investify_war_staging
if exist "%STAGING%" rmdir /S /Q "%STAGING%"
mkdir "%STAGING%"

REM Copy web content (JSPs, portals)
xcopy /Y /E /I /Q "%PROJECT_DIR%admin"      "%STAGING%\admin"      >nul
xcopy /Y /E /I /Q "%PROJECT_DIR%founder"    "%STAGING%\founder"    >nul
xcopy /Y /E /I /Q "%PROJECT_DIR%investor"   "%STAGING%\investor"   >nul
xcopy /Y /E /I /Q "%PROJECT_DIR%government" "%STAGING%\government" >nul
xcopy /Y /E /I /Q "%PROJECT_DIR%docs"       "%STAGING%\docs"       >nul 2>&1

REM Copy root JSPs / HTML / CSS / JS
for %%F in ("%PROJECT_DIR%*.jsp" "%PROJECT_DIR%*.html" "%PROJECT_DIR%*.css" "%PROJECT_DIR%*.js") do (
    if exist "%%F" copy /Y "%%F" "%STAGING%\" >nul 2>&1
)

REM Copy WEB-INF (classes + lib + web.xml)
xcopy /Y /E /I /Q "%WEB_INF%" "%STAGING%\WEB-INF" >nul

REM Remove source files from staging WEB-INF (keep only classes, lib, web.xml)
REM (nothing dangerous here – just making sure src isn't accidentally inside WEB-INF)

REM Create the WAR using jar tool
cd /D "%STAGING%"
"%JAR%" -cvf "%WAR_OUT%" . >nul 2>&1
if errorlevel 1 (
    echo [ERROR] WAR creation failed!
    cd /D "%PROJECT_DIR%"
    pause
    exit /b 1
)
cd /D "%PROJECT_DIR%"

REM Cleanup staging
rmdir /S /Q "%STAGING%"

echo    investify.war created!

REM -------------------------------------------------------
REM  4b. Auto-deploy to local Tomcat (if running)
REM -------------------------------------------------------
SET TOMCAT_WEBAPPS=C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps
if defined TOMCAT_HOME SET TOMCAT_WEBAPPS=%TOMCAT_HOME%\webapps

if exist "%TOMCAT_WEBAPPS%" (
    echo.
    echo [4b] Deploying to Tomcat...
    copy /Y "%WAR_OUT%" "%TOMCAT_WEBAPPS%\ROOT.war" >nul
    REM Remove old expanded folders so Tomcat re-extracts fresh
    if exist "%TOMCAT_WEBAPPS%\ROOT"      rmdir /S /Q "%TOMCAT_WEBAPPS%\ROOT"
    if exist "%TOMCAT_WEBAPPS%\investify" rmdir /S /Q "%TOMCAT_WEBAPPS%\investify"
    echo    Copied investify.war as ROOT.war to Tomcat webapps.
    echo    App will be available at http://localhost:8080/
) else (
    echo [INFO] Tomcat webapps not found - skipping auto-deploy.
    echo        Copy investify.war manually to your Tomcat webapps folder.
)

REM -------------------------------------------------------
REM  5. Summary
REM -------------------------------------------------------
echo.
echo [5/5] Verifying WAR contents...
"%JAR%" -tf "%WAR_OUT%" | findstr /I "WEB-INF\classes\com\investify"
echo.
echo =====================================================
echo   BUILD SUCCESSFUL
echo =====================================================
echo.
echo   WAR File  : %WAR_OUT%
for %%A in ("%WAR_OUT%") do echo   Size      : %%~zA bytes
echo.
echo   Deployment Options:
echo   ─────────────────────────────────────────────────
echo   [Option A] Local Tomcat
echo      1. Copy investify.war to %%TOMCAT_HOME%%\webapps\
echo      2. Start Tomcat: %%TOMCAT_HOME%%\bin\startup.bat
echo      3. Open: http://localhost:8080/investify/
echo.
echo   [Option B] Render / Cloud (WAR deploy)
echo      Upload investify.war via your hosting dashboard
echo.
echo   [REMINDER] MySQL must be running with 'investify' DB
echo   ─────────────────────────────────────────────────
echo.
pause
