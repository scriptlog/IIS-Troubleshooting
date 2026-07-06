@echo off
color 0B
title IIS Troubleshooting Script

echo === IIS Troubleshooting Script (CMD/Batch) ===
echo.

echo [1] Cek versi IIS...
reg query HKLM\SOFTWARE\Microsoft\InetStp
echo.

set BASE=C:\inetpub\wwwroot\scriptlog

echo [2] Ambil alih kepemilikan folder...
takeown /f "%BASE%\public\log" /r /d y
takeown /f "%BASE%\public\cache" /r /d y
takeown /f "%BASE%\public\themes" /r /d y
takeown /f "%BASE%\admin\plugins" /r /d y
echo.

echo [3] Grant full control ke Administrator...
icacls "%BASE%\public\log" /grant Administrators:(OI)(CI)F
icacls "%BASE%\public\cache" /grant Administrators:(OI)(CI)F
icacls "%BASE%\public\themes" /grant Administrators:(OI)(CI)F
icacls "%BASE%\admin\plugins" /grant Administrators:(OI)(CI)F
echo.

echo [4] Hapus atribut read-only...
attrib -r "%BASE%\public\log" /s /d
attrib -r "%BASE%\public\cache" /s /d
attrib -r "%BASE%\public\themes" /s /d
attrib -r "%BASE%\admin\plugins" /s /d
echo.

echo [5] Grant Modify ke App Pool Scriptlog...
icacls "%BASE%\public\log" /grant "IIS AppPool\Scriptlog:(OI)(CI)M"
icacls "%BASE%\public\cache" /grant "IIS AppPool\Scriptlog:(OI)(CI)M"
icacls "%BASE%\public\themes" /grant "IIS AppPool\Scriptlog:(OI)(CI)M"
icacls "%BASE%\admin\plugins" /grant "IIS AppPool\Scriptlog:(OI)(CI)M"
echo.

echo [6] Restart IIS...
iisreset
echo.

echo === Selesai ===
pause
