# GetNuTool

The lightweight non-binary tool for work with NuGet packages via basic MSBuild Tool (msbuild.exe without additional extensions etc.)

```bash
> msbuild.exe gnt.core
```

## Main features

* Getting the all selected `.nupkg` packages from NuGet server from user list with formats below.
    * Two formats: list from `.config` files or direct from string.
* Extracting the all data from `.nupkg` into path by default or specific for each package.
    * +Custom naming for each package with ignoring for already downloaded packages.
* Dependencies are not considered! get it manually as other packages above.
* [NuGet events](http://docs.nuget.org/create/Creating-and-Publishing-a-Package#automatically-running-powershell-scripts-during-package-installation-and-removal) *(Init.ps1, Install.ps1, Uninstall.ps1)* currently are not considered. Call it manually from `/tools`.
* Packing packages as `.nupkg` by using `.nuspec`

### For what 

Firstly, **it's not for** adding libraries for your projects (use standard nuget clients). This to providing tools for additional maintenance of your projects and libraries, building processes, debugging, and similar. For all that should be used as a tool for all projects (solution-level) or for each.

#### Restoring packages inside Visual Studio IDE

The GetNuTool can't use events from Visual Studio by default. However, it can be combined with other our tool for complex work with **a lot of events** of VS IDE & MSBuild:

* [vsSolutionBuildEvent](http://vssbe.r-eg.net) - [0d1dbfd7-ed8a-40af-ae39-281bfeca2334](https://visualstudiogallery.msdn.microsoft.com/0d1dbfd7-ed8a-40af-ae39-281bfeca2334/)

So you can use this as you want, for example, to automatically getting tool above for work with complex scripts with MSBuild Tool and Visual Studio as unified engine., etc.

### Getting & Extracting packages

*The `get` command is used by default. You can also call it as `/t:get`*

Settings:

Property | Description
---------|------------
ngconfig | Where to look the packages.config files.
ngserver | NuGet server.
ngpackages | List of packages. Uses first if defined, otherwise find packages.config
ngpath | Common path for all packages.

Samples:

```bash
> msbuild.exe gnt.core /p:ngpath="special-packages/new"
```
```bash
> msbuild.exe gnt.core /p:ngconfig=".nuget/packages.config" /p:ngpath="../packages"
```

#### Format of packages list

Attribute | Description
----------|-------------
id        | Identifier of package.
version   | Version of package.
output    | Optional path for getting package.

Property: 

```bash
/p:ngpackages="id[/version][:output]"
```

```bash
/p:ngpackages="id[/version][:output];id2[/version][:output];..."
```

packages.config:
    
```xml

<packages>
  <package id="ident" version="1.2.0" />
  <package id="ident.second" version="15.0" output="path" />
</packages>
```
**Note:** Attributes for v1.2+ is now are case sensitive. Use lowercase for `id`, `version`, `output` ...

#### Format of ngconfig

```bash
/p:ngconfig=".nuget/packages.config"
```
multiple:
```bash
/p:ngconfig=".nuget/packages.config|project1/packages.config|project2/packages.config|..."
```

### Packing

The `pack` command. Call it as `/t:pack`

Settings:

Property | Description
---------|------------
ngin     | To select path to directory for packing with `.nuspec` file.
ngout    | Optional path to output the final `.nupkg` package.

```bash
> msbuild.exe gnt.core /t:pack /p:ngin="path to .nuspec"
> msbuild.exe gnt.core /t:pack /p:ngin="path to .nuspec" /p:ngout="path for .nupkg"
```

## Examples

```bash

> msbuild.exe gnt.core
> msbuild.exe gnt.core /p:ngpackages="7z.Libs/15.12.0;vsSBE.CI.MSBuild/1.5.1:../packages/CI.MSBuild"
```

```bash
> msbuild.exe gnt.core /t:pack /p:ngin="D:\tmp\7z.Libs"
> msbuild.exe gnt.core /t:pack /p:ngin="D:\tmp\7z.Libs" /p:ngout="newdir/"
```

### Paths to msbuild.exe

*just a note where to find the msbuild tool by default:*

```bash

"C:\Program Files (x86)\MSBuild\14.0\bin\msbuild.exe"
"C:\Program Files (x86)\MSBuild\12.0\bin\msbuild.exe"
C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe
```

+GAC_32, GAC_64, ...

## Compact version

Use our compressor from [here](https://github.com/3F/GetNuTool/tree/master/compact) if needed. 

Currently compact version ~4 Kb for `get` command and ~4 Kb for `pack` command, i.e. ~8 Kb in total.

```bash
> msbuild.exe .compressor
> msbuild.exe .compressor /p:core="path to core" /p:output="output file"
```

## License

The MIT License (MIT)
