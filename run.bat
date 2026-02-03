@echo off
REM FiveM Sunucu Başlatma Scripti (Windows)

cls
echo.
echo ╔═══════════════════════════════════════╗
echo ║  FİVEM SUNUCU BAŞLATILIYOR...         ║
echo ╚═══════════════════════════════════════╝
echo.

REM Sunucu yazılımını kontrol et
if not exist "FXServer.exe" (
    if not exist "txAdmin.exe" (
        echo ❌ FiveM sunucu yazılımı bulunamadı!
        echo.
        echo Lütfen şunları yapın:
        echo 1. FiveM sunucu yazılımını indirin
        echo 2. Bu klasöre çıkartın
        echo 3. Tekrar run.bat dosyasını çalıştırın
        echo.
        pause
        exit /b 1
    )
)

echo ✓ Sistem bilgisi yükleniyor...
echo   - Port: 30120
echo   - Max Oyuncu: 32
echo   - Sunucu Adı: Turkiye Roleplay Sunucusu
echo.

echo ✓ Kaynaklar yükleniyor...
echo   - [core] resources
echo   - [jobs] resources
echo   - [bank] resources
echo.

echo ✓ Sistemler başlatılıyor...
echo   - Para Sistemi
echo   - Banka Sistemi
echo   - Meslek Sistemi
echo   - Tırcılık
echo   - Çiftçilik
echo   - Balıkçılık
echo.

echo ╔═══════════════════════════════════════╗
echo ║  SUNUCU BAŞLATILIYOR...               ║
echo ╚═══════════════════════════════════════╝
echo.

REM Sunucu başlat
if exist "FXServer.exe" (
    FXServer.exe +exec server.cfg
) else if exist "txAdmin.exe" (
    txAdmin.exe
) else (
    echo Sunucu yazılımı başlatılamadı!
    pause
    exit /b 1
)
