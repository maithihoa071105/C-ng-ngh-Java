@echo off
setlocal
cd /d "%~dp0"
chcp 65001 >nul

echo =====================================================
echo        CNJ02 - HE THONG QUAN LY HO SO XET TUYEN
echo =====================================================

if not exist "pom.xml" (
    echo [LOI] Khong tim thay pom.xml.
    echo Hay chay file RUN_CNJ02.bat tai thu muc CNJ02_Mai Thi Hoa.
    pause
    exit /b 1
)

if not exist "target\xettuyen-0.0.1-SNAPSHOT.jar" (
    echo [1/2] Chua co file JAR. Dang build CNJ02...
    call mvn clean package -DskipTests
    if errorlevel 1 (
        echo.
        echo [LOI] Build that bai. Kiem tra Java 21, Maven va MySQL.
        pause
        exit /b 1
    )
)

echo [2/2] Dang mo CNJ02 Desktop...
java -Djava.awt.headless=false -jar "target\xettuyen-0.0.1-SNAPSHOT.jar"

if errorlevel 1 (
    echo.
    echo [LOI] CNJ02 khong khoi dong duoc.
    pause
)
endlocal
