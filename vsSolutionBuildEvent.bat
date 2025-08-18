::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool

:: Visual Studio IDE plugin: https://github.com/3F/vsSolutionBuildEvent/releases/latest
@.tools\hMSBuild ~x -GetNuTool vsSolutionBuildEvent & if "%~1"=="" packages\vsSolutionBuildEvent\GUI