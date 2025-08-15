echo off
echo battleMETAL v6.0.0 COMPILE ALL
echo ------------------------------

echo =====================================================================
cd client
echo COMPILE CSPROGS.DAT
echo ------------------------------
fteqcc64.exe -Wno-mundane -Fkce -Fwasm -Fifvector -Fvectorlogic -Ffastarrays -Fno-boundchecks

