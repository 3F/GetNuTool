@echo off

compress & msbuild embedded/.packer /p:core="../minified/gnt.core" /p:output="gnt.bat" /nologo /v:m /m:4