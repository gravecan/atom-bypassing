@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Atomic License Key Generator
echo ========================================
echo.
echo Generating 10 random license keys...
echo.

set "chars=ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
set "output=generated_keys.txt"

:: Clear output file
> %output% echo Atomic License Keys - Generated: %date% %time%
>> %output% echo ========================================
>> %output% echo.

for /L %%i in (1,1,10) do (
    set "key=ATOMIC"
    
    :: Generate 4 segments of 4 characters each
    for /L %%s in (1,1,4) do (
        set "segment="
        for /L %%c in (1,1,4) do (
            set /a "rand=!random! %% 33"
            for /F %%a in ("!rand!") do (
                set "segment=!segment!!chars:~%%a,1!"
            )
        )
        set "key=!key!-!segment!"
    )
    
    echo Key %%i: !key!
    >> %output% echo !key!
)

echo.
echo ========================================
echo Keys saved to: %output%
echo ========================================
echo.
echo To add these keys to MongoDB, run:
echo   ssh -i "C:\Users\Opsec\Downloads\atomickey.pem" ubuntu@44.195.19.197
echo   Then copy paste the commands from: mongodb_insert.txt
echo.

:: Generate MongoDB insert commands
set "mongofile=mongodb_insert.txt"
> %mongofile% echo // MongoDB Insert Commands
>> %mongofile% echo // Copy and paste these into mongosh after connecting
>> %mongofile% echo.
>> %mongofile% echo use atomic
>> %mongofile% echo.

for /F "skip=4 tokens=*" %%k in (%output%) do (
    >> %mongofile% echo db.keys.insertOne({key: "%%k", username: "User", hwid: null, expired: false, banned: false, createdAt: new Date(), failedHwids: [], failedAttempts: 0});
)

echo MongoDB commands saved to: %mongofile%
echo.
pause
