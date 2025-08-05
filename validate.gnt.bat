@echo off

set input=gnt.bat
if not exist %input% exit /B2

set /p sha1=<%input%.sha1
echo %input% ?= %sha1%
call svc.gnt -sha1-cmp %input% %sha1% -package-as-path

if "%~1"=="" pause