@echo off
set path=
setlocal enabledelayedexpansion
set "ver=1.0"
"%SystemRoot%\System32\mode.com" 120,31
for /f %%a in ('"prompt $H&for %%b in (1) do rem"') do set "BS=%%a"
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "ESC=%%b"
)
set "file=%~1"
set "fileTitle=%~nx1"
set "highlight[red]=%ESC%[1;31m"
set "highlight[green]=%ESC%[38;2;122;153;28m"
set "highlight[cyan]=%ESC%[38;2;44;161;152m"
::::::::::::::::
set "cursor=enable"
set "highlighting=true"
set "lastlinetext=true"
set "syntaxhighlighting=batchfile.highlighting"
set "linespace= "
set "mode=classic"
set "split=false"
::::::::::::::::
if not defined file (
	echo(
	for %%A in (
	"              _       _           _   "
	"  _ __   ___ | |_ ___| |__   __ _| |_ "
	" | '_ \ / _ \| __/ _ \ '_ \ / _` | __|"
	" | | | | (_) | ||  __/ |_) | (_| | |_ "
	" |_| |_|\___/ \__\___|_.__/ \__,_|\__|"
	) do echo(     %%~A
	echo(
	set /p "file=File name and extension: "
	echo(>>"!file!"
)
if "%~1"=="" for /f "tokens=*" %%A in ("!file!") do (
	set "fileTitle=%%~nxA"
)
set reset=%ESC%[0m
set "topBar=%ESC%[106;93m"
set "fileNameBar=%ESC%[106;97m"
if exist "!syntaxhighlighting!" set "highlighting=true"
for /f "delims=" %%A in ("!syntaxhighlighting!") do set "hl=%%~nA"
set "maximumLines=2800"
set "topBar=%ESC%[106;93m"
set "fileNameBar=%ESC%[106;97m"
set "lineSelect=%ESC%[93m"
set "numberOverlay=%ESC%[7m%ESC%[40m"
set "textcolor=%ESC%[0m"
:reload
cls
echo(
for %%A in (
"              _       _           _   "
"  _ __   ___ | |_ ___| |__   __ _| |_ "
" | '_ \ / _ \| __/ _ \ '_ \ / _` | __|"
" | | | | (_) | ||  __/ |_) | (_| | |_ "
" |_| |_|\___/ \__\___|_.__/ \__,_|\__|"
) do echo(     %%~A
echo(
echo(
<nul set /P="     Loading NoteBAT"
for /l %%a in (1,1,!maximumlines!) do (
	set "line[%%a]="
)
<nul set /p="."
for %%A in (cls len start key sve prevline) do set "%%A="
set linenum=1
set /a startline=0
<nul set /p="."
setlocal DisableDelayedExpansion
if exist tempset.txt 2>nul del /f /q "tempset.txt"
for /f "delims=" %%# in ('type "%file%"') do (
	set /a startline+=1
	set "multiplepercenttmp=%%#"
	call :setL
)
<nul set /p="."
setlocal enabledelayedexpansion
if exist "tempset.txt" (
	for /f "delims=" %%A in ('type "tempSet.txt"') do (
		set "%%~A"
	)
	2>nul del /f /q "tempset.txt"
) 
<nul set /p="."
set "scriptline=%startline%"
set startline=28
set "editline=!line[%lineNum%]!"
set cls=true
set start=1
set /a start=29
<nul set /p="."
call :strLen editline len
<nul set /p="."
set len+=6
<nul set /p="."
cls
:loop
if "!lastlinetext!"=="true" <nul set /p="!ESC![97m!ESC![31;6HTo save, press CTRL+S, to turn off highlighting press CTRL+A, to go DOWN, press {Enter}, to go UP press ^^.!ESC![1;1H!Reset!"
if !cursor! equ enable (
	<nul set /p="!ESC![?25h"
) else (
	<nul set /p="!ESC![?25l"
)	
set /a start=!startline! - 28
for /l %%a in (0,28,!maximumLines!) do (
	if !lineNum! LSS %%a (
		if !start! equ %%a (
			cls
			set startline=%%a
		)
	)	
	if !lineNum! equ %%a (
			cls
			set /a start=%%a
			set /a startline=!start! + 28
		)
	)


rem <nul set /p="!ESC![1;1H"
if "!save!"=="true" (
	title *!fileTitle! - NoteBAT !ver!
) else (
	title !fileTitle! - NoteBAT !ver!
)
for /l %%a in (!start!,1,!startline!) do (
	if %%a lss 10000 set "linespace=!ESC![0m"
	if %%a lss 1000 set "linespace= !ESC![0m"
	if %%a lss 100 set "linespace=  !ESC![0m"
	if %%a lss 10 set "linespace=   !ESC![0m"
	if %%a lss 1 set "linespace=    !ESC![0m"
	if not defined fullstrlen (
		call :fullstrlen editline
		set /a fullstrlen+=6
		set "linepos=!fullstrlen!"
	)
	set "showeditline=        "
	if "!split!"=="true" (
		set "editline=!line[split]!!line[end]!"
	)
	if "%%a"=="!lineNum!" (
		if "!highlighting!"=="true" (
			if not "!editline!"=="" (
				call :lrepl "!line[%%a]!"
			)
		) else (
			set "showeditline=!editline!"
		)
			:: LESS THAN 10
			if %%a lss 10 if not "!line[%%a]!"=="" (
				<nul set /p="!numberOverlay!!lineSelect!%%a!linespace! !textcolor!!showeditline!!reset!"
		) else (
				<nul set /p="!numberOverlay!!lineSelect!%%a!linespace! !textcolor!!showeditline!!reset!"
		)
			:: MORE THAN 10
			if %%a geq 10 if not "!line[%%a]!"=="" (
				<nul set /p="!numberOverlay!!lineSelect!%%a!linespace! !textcolor!!showeditline!!reset!"
		) else (
				<nul set /p="!numberOverlay!!lineSelect!%%a!linespace! !textcolor!!showeditline!!reset!"
		)
			echo(!ESC![0m
		) else (
			if not %%a leq 0 if %%a lss 10 if not "!line[%%a]!"=="" (
				echo(!numberOverlay!%%a!linespace!!reset! !textcolor!!line[%%a]!!reset!
		) else (
				echo(!numberOverlay!%%a!linespace!!reset! !textcolor!!line[%%a]!!reset!
		)
			if not %%a leq 0 if %%a geq 10 if not "!line[%%a]!"=="" (
				echo(!numberOverlay!%%a!linespace!!reset! !textcolor!!line[%%a]!!reset!
		) else (
				echo(!numberOverlay!!ESC![90m%%a!linespace!!reset! !textcolor!!line[%%a]!!reset!
		)
			if %%a equ 0 call :header
			
		)
)
set "line=!editline!"
call :inp
goto loop

:lrepl
if "!editline!"=="" exit /b 1
set "showeditline=!editline!"
for /f "tokens=1,2 delims=:" %%A in ('2^>nul type "!syntaxhighlighting!"') do (
    if not "!showeditline:%%A=!"=="!showeditline!" set "showeditline=!showeditline:%%A=%%B%%AEND!"
)
set "showeditline=!showeditline:red=%ESC%[1;31m!"
set "showeditline=!showeditline:green=%ESC%[38;2;122;153;28m!"
set "showeditline=!showeditline:cyan=%ESC%[38;2;44;161;152m!"
set "showeditline=!showeditline:end=%ESC%[0m!"
set "showeditline=!showeditline:gold=%ESC%[33m!"
set "showeditline=!showeditline:blue=%ESC%[96m!"
exit /b 0

:inp
set /a temp=!linenum! - !start! + 1
if !cursor! equ enable (
	call :strLen editline len
	if !len! equ 4101 set "len=0"
	set /a len+=6
	rem if "!intext!"=="true" set /a len=len - linepos - 2
	<nul set /p="!ESC![!temp!;!len!H"
)
if "!mode!"=="arrow" if not "!intext!"=="true" <nul set /p="!ESC![!temp!;!linepos!H"
if "!intext!"=="true" (
	<nul set /p="!ESC![!temp!;!linepos!H"
)

)
set "key="
setlocal DisableDelayedExpansion
for /f "delims=" %%C in ('2^>nul "%SystemRoot%\System32\xcopy.exe" /w /l "%~f0" "%~f0"') do if not defined key set "key=%%C"
(  
endlocal
set "key=^%key:~-1%" !
)
:: ctrl + d cz
if "!key!"=="" (
	if "!mode!"=="classic" (
		call :fullstrlen editline
		set /a fullstrlen+=6
		set "linepos=!fullstrlen!"
		set "mode=arrow"
		exit /b 0
	) else (
		set "mode=classic"
		set "split=false"
		set "line[split]="
		set "line[end]="
		set "linepos="
		set "intext=false"
		exit /b 0
	)
)
if "!mode!"=="arrow" (
	if "!Key!"=="a" (
		if !linepos! gtr 6 set /a linepos-=1
	)
	if "!Key!"=="d" (
		if !linepos! lss !fullstrlen! set /a linepos+=1
	)
	if "!key!"=="" (
		set "split=true"
		set "mode=classic"
		set "line=!editline!"
		echo !line!
		call :strlen line
		set /a linepos-=6
		for /l %%a in (0,1,!fullstrlen!) do (
			if %%a lss !linepos! (
				set "line[split]=!line[split]!!line:~%%a,1!"
			) else (
			set "line[end]=!line[end]!!line:~%%a,1!"
				)
			)
	cls
	set "intext=true"
	set /a linepos+=6
	)
exit /b 0
)
if "!key!"==" " set "key= "
if not "!editline!"==""  (
	if "!key!"=="!BS!" (
		if "!split!"=="false" (
			set "editline=!editline:~0,-1!"
		) else (
			if not "!line[split]!"=="" set "line[split]=!line[split]:~0,-1!"
		)
		set /A tmplen=len - 1
		set /a linepos-=1
		<nul set /p="!ESC![!temp!;!tmplen!H "
		set "save=true"
		exit /b 0
	)
)
if "!key!"=="!BS!" exit /b 0
if "!key!"=="	" set "key=    "
if "!key!"=="" (
	if !linenum! gtr !startline! (
		set "line[!lineNum!]=!editline!"
		set /a startline+=1
		set /a lineNum+=1
		set "fullstrlen="
		call :set
		exit /b 0
	)
	set "line[!lineNum!]=!editline!"
	if not !linenum! gtr !startline! set /a lineNum+=1
	call :set
	exit /b 0
)
if "!key!"=="^" (
	if "!linenum!"=="1" exit /b 0
	set "line[!lineNum!]=!editline!"
	set /a lineNum-=1
	set "fullstrlen="
	call :set
	exit /b 0
)
rem ctrl a cz
if "!key!"=="" (
	if "!highlighting!"=="true" (
		if exist "!syntaxhighlighting!" set "highlighting=false"
		set "hl=None"
	) else (
		if exist "!syntaxhighlighting!" set "highlighting=true"
		for /f "delims=" %%A in ("!syntaxhighlighting!") do set "hl=%%~nA"
	)
	exit /b 0
)
rem ctrl a eng
if "!key!"=="" (
	if "!highlighting!"=="true" (
		if exist "!syntaxhighlighting!" set "highlighting=false"
		set "hl=None"
	) else (
		if exist "!syntaxhighlighting!" set "highlighting=true"
		for /f "delims=" %%A in ("!syntaxhighlighting!") do set "hl=%%~nA"
	)
	exit /b 0
)



rem ctrl s
if "!key!"=="" (
	set "mode=classic"
	set "split=false"
	set "line[split]="
	set "line[end]="
	set "linepos="
	set "intext=false"
	set save=false
	2>nul del /f /q "!file!"
	set "line[!lineNum!]=!editline!"
	for /l %%a in (1,1,!maximumlines!) do (
		if not "!line[%%a]!"=="" call :print "%%a" "!file!"
	)
	set editline=
	cls
	goto :reload
	exit /b 0
)
if "!key!"=="" (
	set "mode=classic"
	set "split=false"
	set "line[split]="
	set "line[end]="
	set "linepos="
	set "intext=false"
	rem set save=false
	2>nul del /f /q "!file!"
	set "line[!lineNum!]=!editline!"
	for /l %%a in (1,1,!maximumlines!) do (
		if "!line[%%a]!"=="" (
			set "line[%%a]="
		) else (
			call :print "%%a" "!file!"
			)
		)
	set editline=
	cls
	goto :reload
	exit /b 0
)


	
set save=true
if "!split!"=="true" (
	set "line[split]=!line[split]!!key!"
	set /a linepos+=1
) else (
	set "editline=!editline!!key!"
)
exit /b 0

:header
call :strlen editline
if !len! equ 4101 set "len=0"
echo(!topBar!!ESC![1;1H     !fileNameBar!Highlighting: !hl!                                                                                                !reset!
echo(!fileNameBar!!ESC![1;55H!fileTitle!!reset!
echo(!ESC![1;90H!topBar!!fileNameBar!Ln: !lineNum!  Cl: !len!!reset!
exit /b 0

:set
set "editline=!line[%lineNum%]!"
exit /b 0

:print
echo(!line[%~1]!>>"%~2"
exit /b 0

:strLen
set "_tmp=!%1!"
set len=0
for %%A in (4096,2048,1024,512,256,128,64,32,16,8,4,2,1) do (
    if not "!_tmp:~%%A,1!"=="" (
        set /a "len+=%%A"
        set "_tmp=!_tmp:~%%A!"
    )
)
set /a len+=1
if !len! equ 4100 set len=0
exit /b

:fullstrLen
set "_tmp=!%1!"
set fullstrlen=0
for %%A in (4096,2048,1024,512,256,128,64,32,16,8,4,2,1) do (
    if not "!_tmp:~%%A,1!"=="" (
        set /a "fullstrlen+=%%A"
        set "_tmp=!_tmp:~%%A!"
    )
)
set /a fullstrlen+=1
if !fullstrlen! equ 4100 set len=0
exit /b

:setL
setlocal EnableDelayedExpansion
set "result=!multiplepercenttmp!"
set "result=!result:^=^^^^!"
set "result=!result:&=^&!"
set "result=!result:|=^|!"
set "result=!result:>=^>!"
set "result=!result:<=^<!"
set "result=!result:)=^)!"
set "result=!result:(=^(!"
setlocal disabledelayedexpansion
(
    endlocal
    set result=%result:!=^^^^^^^^^^^^^^!%
)
setlocal EnableDelayedExpansion
echo("line[!startline!]=%result%">>"tempset.txt"
exit /b 0


