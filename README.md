# GetNuTool

The lightweight non-binary tool for getting the NuGet packages via basic MSBuild Tool (msbuild.exe without additional extensions etc.)

```bash
> msbuild.exe gnt.core
```

## Main features

* Getting the all selected .nupkg packages from NuGet server from user list with formats below.
    * Two formats: list from .config files or direct from string.
* Extracting the all data from .nupkg 'as is' into path by default or specific for each package.
    * +Custom naming for each package with ignoring for already downloaded packages.
* Dependencies are not considered! get it manually as other packages above.

### Settings

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

Property: 

```bash
/p:ngpackages="id[/version][:path]"
```

```bash
/p:ngpackages="id[/version][:path];id2[/version][:path];..."
```

packages.config:
    
```xml

<packages>
  <package id="ident" version="1.2.0" />
  <package id="ident.second" version="15.0" output="path" />
</packages>
```

#### Format of ngconfig

```bash
/p:ngconfig=".nuget/packages.config"
```
multiple:
```bash
/p:ngconfig=".nuget/packages.config|project1/packages.config|project2/packages.config|..."
```

## Examples

```bash

> msbuild.exe gnt.core
> msbuild.exe gnt.core /p:ngpackages="7z.Libs/15.12.0;vsSBE.CI.MSBuild/1.5.1:../packages/CI.MSBuild"
```

### Paths to msbuild.exe

Sample locations:

```bash

"C:\Program Files (x86)\MSBuild\14.0\bin\msbuild.exe"
"C:\Program Files (x86)\MSBuild\12.0\bin\msbuild.exe"
C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe
```

+GAC_32, GAC_64, ...

## Compact version

Simply use compressor from [here](https://github.com/3F/GetNuTool/tree/master/compact) if needed. Currently compact version ~4 Kb.

## License

The MIT License (MIT)