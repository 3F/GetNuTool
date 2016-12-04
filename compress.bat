@echo off

msbuild minified/.compressor /p:core="../gnt.core" /p:output="gnt.core" /nologo /v:m /m:4