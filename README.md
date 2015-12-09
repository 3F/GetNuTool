# GetNuTool

The lightweight non-binary tool for getting the NuGet packages via basic MSBuild Tool (msbuild.exe without additional extensions etc.)

```bash
> msbuild.exe gnt.core
```

## Main features

* Getting the all selected .nupkg packages from NuGet server from user list with formats below.
* Extracting the all data from .nupkg 'as is' into path by default or specific for each package.
* Dependencies are not considered! get it manually.

### Settings

Property | Description
---------|------------
ngconfig | Where to look the packages.config of solution-level.
ngserver | NuGet server.
ngpackages | List of packages. Uses first if defined, otherwise find packages.config
ngpath | Common path for all packages.

Sample:

```bash

> msbuild.exe gnt.core /p:ngpath="special-packages/new"
```

#### Format of list

Property: 

```bash
/p:ngpackages="id/version[:path];id2/version[:path];..."
```

.nuget\packages.config:
    
```xml

<packages>
  <package id="ident" version="1.2.0" />
  <package id="ident.second" version="15.0" output="path" />
</packages>
```

## Examples

```bash

> msbuild.exe gnt.core
> msbuild.exe gnt.core /p:ngpackages="7z.Libs/15.12.0;vsSBE.CI.MSBuild/1.5.1:../packages/CI.MSBuild"
```

## License

The MIT License (MIT)