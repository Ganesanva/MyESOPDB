@echo off
cls
set /p SName=Server Name :
set /p UName=User Name :
set /p Pwd=Password :
set /p DbName=Database Name :
set /p Opath=Objects Path :
set /p choice=ARE YOU SURE TO EXECUTE SCRIPTS in %DbName% (y/n) ?
if '%choice%'=='y' goto begin
goto end
:begin
@echo on
call %Opath%\TABLE\Table.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\VIEW\VIEW.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\TRIGGER\Trigger.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\FUNCTION\FUNCTION.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\Procedure\Procedure.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\TABLETYPE\TABLETYPE.bat %SName% %UName% %Pwd% %DbName% %Opath%
call %Opath%\User\User.bat %SName% %UName% %Pwd% %DbName% %Opath%

:end