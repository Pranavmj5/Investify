@echo off
REM ============================================================
REM  Investify Build & Deploy Script
REM  Compiles Java sources and deploys to Tomcat
REM ============================================================

SET TOMCAT_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1
SET WEBAPP=%TOMCAT_HOME%\webapps\investify
SET SRC_DIR=%~dp0src
SET LIB_DIR=%~dp0WEB-INF\lib
SET CLASSES_DIR=%WEBAPP%\WEB-INF\classes

echo ============================================
echo  Investify - Build ^& Deploy
echo ============================================

REM 1. Create webapp directory structure
echo [1/4] Creating deployment directories...
if not exist "%WEBAPP%" mkdir "%WEBAPP%"
if not exist "%WEBAPP%\WEB-INF\classes" mkdir "%WEBAPP%\WEB-INF\classes"
if not exist "%WEBAPP%\WEB-INF\lib" mkdir "%WEBAPP%\WEB-INF\lib"
if not exist "%WEBAPP%\uploads" mkdir "%WEBAPP%\uploads"

REM 2. Compile Java sources
echo [2/4] Compiling Java sources...
SET CLASSPATH=%TOMCAT_HOME%\lib\servlet-api.jar;%TOMCAT_HOME%\lib\jakarta.servlet-api.jar;%LIB_DIR%\*

javac -d "%CLASSES_DIR%" -cp "%CLASSPATH%" ^
  %SRC_DIR%\com\investify\db\*.java ^
  %SRC_DIR%\com\investify\servlet\*.java
if errorlevel 1 (
    echo [ERROR] Compilation failed! Make sure javac and Tomcat libs are available.
    pause
    exit /b 1
)
echo    Compilation successful!

REM 3. Copy web resources
echo [3/4] Copying web resources...
xcopy /Y /E /I "%~dp0WEB-INF" "%WEBAPP%\WEB-INF" >nul 2>&1
xcopy /Y /E /I "%~dp0investor" "%WEBAPP%\investor" >nul 2>&1
xcopy /Y /E /I "%~dp0founder" "%WEBAPP%\founder" >nul 2>&1
xcopy /Y /E /I "%~dp0government" "%WEBAPP%\government" >nul 2>&1
xcopy /Y /E /I "%~dp0admin" "%WEBAPP%\admin" >nul 2>&1
copy /Y "%~dp0*.jsp" "%WEBAPP%\" >nul 2>&1
copy /Y "%~dp0*.html" "%WEBAPP%\" >nul 2>&1
copy /Y "%~dp0*.css" "%WEBAPP%\" >nul 2>&1
copy /Y "%~dp0*.js" "%WEBAPP%\" >nul 2>&1

REM Copy MySQL JDBC driver
if exist "%LIB_DIR%\mysql-connector*.jar" (
    copy /Y "%LIB_DIR%\mysql-connector*.jar" "%WEBAPP%\WEB-INF\lib\" >nul 2>&1
) else (
    echo [WARN] MySQL Connector JAR not found in WEB-INF\lib\
    echo        Download from: https://dev.mysql.com/downloads/connector/j/
)

echo    Resources copied!

REM 4. Done
echo [4/4] Deployment complete!
echo ============================================
echo.
echo  Deployed to: %WEBAPP%
echo.
echo  Next steps:
echo    1. Make sure MySQL is running with 'investify' database
echo    2. Start Tomcat:  %TOMCAT_HOME%\bin\startup.bat
echo    3. Open:  http://localhost:8080/investify/
echo ============================================
pause
