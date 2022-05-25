echo off
echo battleMETAL v4.0.0 COMPILE ALL
echo ------------------------------

echo COMPILE PROGS.DAT
echo ------------------------------
fteqcc64.exe -Wno-mundane -Fkce -Fwasm -Fifvector -Fvectorlogic -Ffastarrays -Fno-boundchecks

echo =====================================================================
cd client
echo -
echo -
echo COMPILE CSPROGS.DAT
echo ------------------------------
fteqcc64.exe -Wno-mundane -Fkce -Fwasm -Fifvector -Fvectorlogic -Ffastarrays -Fno-boundchecks
echo =====================================================================
cd ..

cd menu
echo -
echo -
echo COMPILE MENU.DAT
echo ------------------------------
fteqcc64.exe -Wno-mundane -Fkce -Fwasm -Fifvector -Fvectorlogic -Ffastarrays -Fno-boundchecks
echo =====================================================================
cd ..

pause