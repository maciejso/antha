@ECHO off
REM Patch eventmachine.rb to enable Jekyll livereload (jekyll serve -l)
REM Resolves the following error on Windows 10: 
REM "Unable to load the EventMachine C extension; To use the pure-ruby reactor, require 'em/pure_ruby'"
REM Tested on Ruby2.7, might also work on earlier versions.
REM See https://github.com/tabler/tabler/issues/155

REM Find eventmachine.rb

FOR /F "delims=" %%i IN ('gem environment gemdir') DO set gemdir=%%i
set gemdir=%gemdir:/=\%\gems\

FOR /F "delims=" %%i IN ('dir /b %gemdir%\eventmachine*') DO set emrb=%gemdir%%%i\lib\eventmachine.rb

REM Add "require 'em/pure_ruby'" to the beginning of eventmachine.rb if it isn't there already.

set /p firstline=< %emrb%

IF "require 'em/pure_ruby'"=="%firstline:~0,22%" (
 	echo eventmachine.rb is already patched. Jekyll livereload should work.
) else (
	echo require 'em/pure_ruby' > tmpfile.txt
	type %emrb% >> tmpfile.txt
	move /y tmpfile.txt %emrb%
	echo eventmachine.rb successfully patched. Go ahead and enjoy Jekyll live reload. 
)
