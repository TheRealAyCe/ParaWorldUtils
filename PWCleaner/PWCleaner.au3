#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pwicon.ico
#AutoIt3Wrapper_Outfile=PWCleaner.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=AyCe © 2012
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_File_Add=clean_bin.txt, rt_rcdata, BIN_INFO
#AutoIt3Wrapper_Res_File_Add=clean_maps.txt, rt_rcdata, MAPS_INFO
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <resources.au3>
#include <Misc.au3>
#include <String.au3>

Opt('MustDeclareVars', 1)
Opt('TrayIconHide', 1)

; the program should be located in the tools folder
Const $bindir = @ScriptDir&"\..\bin\"
Const $mapdir = @ScriptDir&"\..\data\base\maps\multiplayer\"

; Check the command line
If($CmdLine[0] > 0)Then
	Select
		Case $CmdLine[1] == "bin"
			CleanBin()
		Case $CmdLine[1] == "maps"
			CleanMaps()
	EndSelect
Else
	Launcher()
Endif

Func Launcher()
    Local $buttonCleanBin, $buttonCleanMaps, $msg
    GUICreate("PWCleaner 1.0.1", 400, 300)
	GUICtrlCreateLabel("The PWCleaner utility can delete old files which are not removed by uninstallers. It currently supports removing unused files from Paraworlds 'bin' folder as well as deleting the old and now unused maps from the maps folder."&@LF&@LF&"Removing the 'bin' files is not mandatory, but it helps keeping order in the folder."&@LF&@LF&"Removing the old maps is heavily encouraged. Mappacks prior to v4.0 contained many bugged, unplayable, and duplicate maps. This tool removes them, so the maps appear only once in their correct version after installing the new mappack.", 10, 10, 380, 150, $SS_LEFT)
    $buttonCleanBin = GUICtrlCreateButton("Clean 'bin' folder", 15, 155, 150, 50)
	GUICtrlCreateLabel("Deletes 15 files from '[PW-folder]/bin/'. However, outdated versions of certain mods might depend on these files.", 175, 155, 215, 50, $SS_LEFT)
	$buttonCleanMaps = GUICtrlCreateButton("Clean maps folder", 15, 215, 150, 50)
		GUICtrlCreateLabel("Deletes 124 files from '[PW-folder]/Data/Base/Maps/Multiplayer/'. All remaining community-maps will be overwritten by the mappack.", 175, 210, 215, 60, $SS_LEFT)
	GUICtrlSetState ( $buttonCleanBin, $GUI_DEFBUTTON )
	GUICtrlCreateLabel ( "2012 © by Para-Welt.com - ParaWorld © by SEK (Ubi)", 10, 280, 380, 20, $SS_CENTER);
    GUISetState()

    While 1
        $msg = GUIGetMsg()
        Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
            Case $msg = $buttonCleanBin
				CleanBin()
            Case $msg = $buttonCleanMaps
				CleanMaps()
        EndSelect
    WEnd
EndFunc

Func CleanBin()
	Local $string = _ResourceGetAsString("BIN_INFO")
	Dim $files = _StringExplode($string, "?")
	CleanFiles($files, "..\bin\")
EndFunc

Func CleanMaps()
	Local $string = _ResourceGetAsString("MAPS_INFO")
	Dim $files = _StringExplode($string, "?")
	CleanFiles($files, "..\Data\Base\Maps\Multiplayer\", ".ula")
EndFunc

Func CleanFiles($filelist, $path, $suffix = "")
	Local $iC = UBound($filelist)-1
	Local $num = 0;
	For $i = 0 To $iC Step 1
		If(FileDelete($path&$filelist[$i]&$suffix)==1)Then
			$num = $num+1
			;MsgBox(0, "Information", $path&$filelist[$i]&$suffix&" deleted!")
		EndIf
	Next
	MsgBox(0, "Done!", ""&$num&" file(s) have been deleted!")
EndFunc
