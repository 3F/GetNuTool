@echo off

compress & msbuild wrapper/.packer /p:core="../compact/gnt.core" /p:output="gnt.bat" /nologo /v:m /m:4