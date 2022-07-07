@echo off
REM *******************************************************************************
REM ********************* DEPLOIEMENT DU CLIENT RG SUPERVISION ********************
REM *******************************************************************************
 
REM **********Teste la presence du service et quitte s'il existe deja**************
sc query RG-Supervision > NUL
if not errorlevel 1060 exit
 
REM *******Determine le chemin d'installation en fonction de l'architecture********
set InstallPath=%ProgramFiles%
if exist "%ProgramFiles(x86)%" set InstallPath=%ProgramFiles(x86)%
 
REM ********************* Copie des binaires depuis un serveur source *************
REM ******* Ces 2 binaires sont dans le fichier zip téléchargeable de l'agent *****
xcopy /I /Y "\\SERVEURSOURCE\PARTAGE\RG-Setup.exe" "%temp%"
xcopy /I /Y "\\SERVEURSOURCE\PARTAGE\vcredist_x86.exe" "%temp%"
 
REM **********************Installation du package C++ redistribuable***************
"%temp%\vcredist_x86.exe" /q:a /c:"msiexec /i vcredist.msi /qn /l*v %temp%\vcredist_x86.log"
 
REM **********************Installation de l'agent**********************************
"%temp%\RG-Setup.exe" --action register --login token@token.tk --password 1f8684c703b73d0e4c2d8c87febcec65e4ef8914 --node 146016

REM **********************Nettoyage************************************************
Del "%temp%\vcredist_x86.exe" /F /Q
Del "%temp%\RG-Setup.exe" /F /Q
 
:QUIT
exit
