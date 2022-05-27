rem dir /a:-d /s /b "LOAD\*.shp" | find /c ":\"> output.txt
set CPL_LOG=shapelogs.txt
@echo off
@setlocal enabledelayedexpansion enableextensions

echo processing > bat_status.txt

for /F "eol=| delims=" %%I in ('dir "LOAD\*.shp" /A-D /B 2^>nul') do for /F "eol=| delims=_" %%J in ("%%~nI") do (
	set "filename=LOAD\%%I"
	call :esri_contains %filename%
	rem echo !cont_type!
	if NOT "!cont_type!" == "non" (
		ogr2ogr -sql "select OBJECTID, GLOBALID, '%%J' as BI_SEG_CODE, '0' as STATUS from %%~nI" -f OCI OCI:username/password@ip:port/database "LOAD\%%I" -nln !cont_type! -append -update -lco GEOMETRY_NAME=GEOMETRY
		if '%ERRORLEVEL%'=='0' (
			echo !filename! processed
		) else (
			echo %ERRORLEVEL% >> errors.txt
		)
	)
	rem echo %%I,%%J,done >> output.txt
)

rem pause
rem echo all,-,done >> output.txt
echo done > bat_status.txt

REM ********* function ***********
:esri_contains
(
	set "passed_name=%filename%"
	set "contain_var=false"
	set "cont_type=non"

	set arg[1]=F_BUILDING_BLOCKS
        set arg[2]=F_BUILDING_LINE
        set arg[3]=F_BUNGALOW_LOT
        set arg[4]=F_COMMERCIAL_AREA
        set arg[5]=F_COMMERCIAL_LINE
        set arg[6]=F_GREENARY_AREA
        set arg[7]=F_GREENARY_LINE
        set arg[8]=F_HYDROGRAPHIC
        set arg[9]=F_HYDROGRAPHIC_LINE
        set arg[10]=F_INDUSTRIAL_AREA
        set arg[11]=F_INDUSTRIAL_LINE
        set arg[12]=F_MAJOR_ROAD_CENTERLINE
        set arg[13]=F_MAJOR_ROAD_OUTLINE
        set arg[14]=F_MAJOR_ROAD_POLYGON
        set arg[15]=F_MINOR_ROAD_CENTERLINE
        set arg[16]=F_MINOR_ROAD_OUTLINE
        set arg[17]=F_MINOR_ROAD_POLYGON
        set arg[18]=F_PARKING_LOT
        set arg[19]=F_PARKING_LOT_POLYGON
        set arg[20]=F_POWER_CENTERLINE
        set arg[21]=F_POWER_OUTLINE
        set arg[22]=F_RAIL
        set arg[23]=F_RAIL_UNDERGROUND
        set arg[24]=F_REGION
        set arg[25]=F_RESIDENTIAL_LINE
        set arg[26]=F_RESIDENTIAL_LOT
        set arg[27]=F_SHOP_LOT
        set arg[28]=F_UNDERGHWAY_RD_CNTRLINE
        set arg[29]=F_UNDERGHWAY_RD_OUTLINE
        set arg[30]=F_UNDERGHWAY_RD_POLYGON
        set arg[31]=F_UNDERG_MJR_RD_CNTRLINE
        set arg[32]=F_UNDERG_MJR_RD_OUTLINE
        set arg[33]=F_UNDERG_MJR_RD_POLYGON
        set arg[34]=F_UNDERG_MNR_RD_CNTRLINE
        set arg[35]=F_UNDERG_MNR_RD_OUTLINE
        set arg[36]=F_UNDERG_MNR_RD_POLYGON
        set arg[37]=F_UNDERHYDROGRAPHIC
        set arg[38]=F_UNDERHYDROGRAPHIC_LINE
        set arg[39]=F_LOT_BOUNDARY
        set arg[40]=F_LOT_BOUNDARY_POLYGON
        set arg[41]=MSIA_STATE_REGION
        set arg[42]=SECURED_LANDBASE

	for /L %%i in (1,1,42) do (
		set tmp_arg=!arg[%%i]!
		rem set tmp_arg=%filename:!tmp_arg!=%
		call :esri_compare !tmp_arg! !passed_name!
		rem if "!exist!" == "1" echo !tmp_arg!
		if "!exist!" == "1" set "cont_type=!tmp_arg!"
	)
	rem echo ----
	rem if /I %filename% equ !arg[%%i]! SET "contain_var=!arg[%%i]!"	
	exit /b
)

:esri_compare
(	
	set "str1=%tmp_arg%"
	set "str2=%~2"
	set "str3=!str2:%tmp_arg%=!"

	if not "!str3!"=="!str2!" (
		set "exist=1"
	) else (
		set "exist=0"
	)
)