@echo off

msbuild compact/.compressor /p:core="../gnt.core" /p:output="gnt.core" /nologo /v:m /m:4