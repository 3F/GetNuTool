@echo off

set msbuild=msbuild.bat

call compress || goto err
call %msbuild% embedded/.packer /p:core="../minified/gnt.core" /p:output="gnt.bat" /nologo /v:m /m:4 %* || goto err

embedded/sha1

goto exit

:err

echo. Build failed. 1>&2

:exit