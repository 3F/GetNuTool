@call :GetNuTool vsSolutionBuildEvent/%v% || ( echo Please contact support>&2 & exit /B1 )
if "%~1"=="" packages\vsSolutionBuildEvent.%v%\GUI
:GetNuTool
