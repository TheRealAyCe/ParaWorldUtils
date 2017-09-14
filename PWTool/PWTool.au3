#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pwicon.ico
#AutoIt3Wrapper_Outfile=PWTool.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=2012 © Para-Welt.com
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

Opt('MustDeclareVars', 1)
Opt('TrayIconHide', 1)

Const $PWTOOLVERSION = "1.0.1";
Global $mod = GetMod()
Global $errorcode
Const $pwsettingsdir = @AppDataDir&"\SpieleEntwicklungsKombinat\Paraworld\"
Const $backupfile = "Settings_SSSS_backup.cfg"

; Check the command line
If($CmdLine[0] > 0)Then
	Select
		Case $CmdLine[1] == "SSSOn"
			SSSOn()
		Case $CmdLine[1] == "SSSOff"
			SSSOff()
		Case $CmdLine[1] == "Kill"
			KillPW()
		Case $CmdLine[1] == "Wait"
			If($CmdLine[0] < 2) Then
				$mod = ""
			EndIf
			WaitForEnd()
		Case $CmdLine[1] == "Restore"
			RestoreSettings()
		Case $CmdLine[1] == "Create"
			CreateBackup()
		Case $CmdLine[1] == "Start"
			StartPW()
		Case $CmdLine[1] == "SDK"
			SDKPW()
		Case $CmdLine[1] == "Dedicated"
			DedicatedPW()
		Case Else
			DisplayHelp()
	EndSelect
Else
	DisplayHelp()
	DefaultUI()
Endif

Func GetMod()
	If($CmdLine[0] < 2 Or $CmdLine[2] == "") Then
		Return "CEP"
	Else
		Return $CmdLine[2]
	EndIf
EndFunc

; No parameters. Display a window
Func DefaultUI()
	ConsoleWrite("Displaying default UI"&@LF)
    Local $inputMod, $buttonStart, $buttonSDK, $buttonDedicated, $buttonOn, $buttonOff, $buttonCache, $buttonKill, $buttonMakeBackup, $buttonBackup, $buttonSettings, $msg
    GUICreate("PWTool "&$PWTOOLVERSION, 200, 460)
	GUICtrlCreateLabel ( "Mod:", 20, 22, 40, 16)
	$inputMod = GUICtrlCreateInput("CEP", 60, 20, 120, 20)
    $buttonStart = GUICtrlCreateButton("Start Game", 20, 50, 160, 25)
    $buttonSDK = GUICtrlCreateButton("Level Editor", 20, 80, 160, 25)
    $buttonDedicated = GUICtrlCreateButton("Dedicated Server", 20, 110, 160, 25)
    $buttonOn = GUICtrlCreateButton("SSS on", 20, 160, 160, 25)
    $buttonOff = GUICtrlCreateButton("SSS off", 20, 190, 160, 25)
    $buttonCache = GUICtrlCreateButton("Clear Cache", 20, 240, 160, 25)
    $buttonKill = GUICtrlCreateButton("Kill PW processes", 20, 270, 160, 25)
    $buttonMakeBackup = GUICtrlCreateButton("Create settings backup", 20, 300, 160, 25)
    $buttonBackup = GUICtrlCreateButton("Restore settings backup", 20, 330, 160, 25)
    $buttonSettings = GUICtrlCreateButton("Open settings folder", 20, 360, 160, 25)
	GUICtrlCreateLabel ( "2012 © by Para-Welt.com"&@LF&"ParaWorld © by SEK (Ubi)", 20, 410, 160, 40, $SS_CENTER);
	GUICtrlSetState ( $buttonStart, $GUI_DEFBUTTON )
    GUISetState()

    While 1
        $msg = GUIGetMsg()
        Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
            Case $msg = $buttonStart
				$mod = GUICtrlRead ($inputMod)
				StartPW()
				ExitLoop
            Case $msg = $buttonSDK
				$mod = GUICtrlRead ($inputMod)
				SDKPW()
				ExitLoop
            Case $msg = $buttonDedicated
				$mod = GUICtrlRead ($inputMod)
				DedicatedPW()
				ExitLoop
            Case $msg = $buttonOn
				SSSOn()
            Case $msg = $buttonOff
				SSSOff()
            Case $msg = $buttonCache
				Run ("ClearCache.exe")
            Case $msg = $buttonKill
				KillPW()
            Case $msg = $buttonBackup
				RestoreSettings()
            Case $msg = $buttonMakeBackup
				CreateBackup()
            Case $msg = $buttonSettings
				ShellExecute(@AppDataDir&"/SpieleEntwicklungsKombinat/Paraworld")
        EndSelect
    WEnd
EndFunc

; Unreleveant parameters. Display console help
Func DisplayHelp()
	ConsoleWrite("PWTool "&$PWTOOLVERSION&" by AyCe"&@LF)
	ConsoleWrite("------------------"&@LF)
	ConsoleWrite("Available command line arguments:"&@LF)
	ConsoleWrite("(None) - Displays a window and this."&@LF)
	ConsoleWrite("SSSOn - Calls mod_conf.exe and switches on SSS"&@LF)
	ConsoleWrite("SSSOff - Calls mod_conf.exe and switches off SSS"&@LF)
	ConsoleWrite("Kill - Kills the PW processes"&@LF)
	ConsoleWrite("Wait [optional command line] - Waits for the PW processes to end and executes the command line, or, if not specified, kills PWKiller.exe and calls SSSOff"&@LF)
	ConsoleWrite("Start [mod]* - Activates SSS, starts Paraworld with the given mod, opens the Killer, and executes Wait"&@LF)
	ConsoleWrite("SDK [mod]* - Activates SSS, starts Paraworld SDK with the given mod, opens the Killer, and executes Wait"&@LF)
	ConsoleWrite("Dedicated [mod]* - Activates SSS, starts Paraworld Dedicated Server with the given mod, opens the Killer, and executes Wait"&@LF)
	ConsoleWrite("(Anything else) - Displays this"&@LF)
	ConsoleWrite("(* if no mod is specified, CEP will be used)"&@LF)
	ConsoleWrite("--- WILL DISPLAY A MESSAGE IF ANY ERROR OCCURS ---"&@LF)
EndFunc

Func AskBackup()
	Local $reply
	$reply = MsgBox(0x14, "Error", "An error occured while trying to switch SSS. Do you want to try to use the backup file?")
	If($reply == 6) Then
		RestoreSettings()
		Return True
	EndIf
	Return False
EndFunc

Func CreateBackup()
	If(FileCopy ($pwsettingsdir&"settings.cfg", $pwsettingsdir&$backupfile, 1))Then
		MsgBox(0x40, "Success", "Created "&$backupfile&" from settings.cfg."&@LF&"This one will be used when settings.cfg becomes corrupt.")
	Else
		MsgBox(0x10, "Error", "Backup file ("&$backupfile&") couldn't be created. It might be currently in use or write protected.")
	Endif
EndFunc

Func RestoreSettings()
	If(FileExists ($pwsettingsdir&$backupfile))Then
		If(FileCopy ($pwsettingsdir&$backupfile, $pwsettingsdir&"settings.cfg", 1))Then
			MsgBox(0x40, "Success", "Replaced settings.cfg with "&$backupfile&"."&@LF&"Some options might have been reset to an old state!"&@LF&"Open the settings folder ("&$pwsettingsdir&") in order to manually delete the backup, so a new one can be created.")
		Else
			MsgBox(0x10, "Error", "Backup file ("&$backupfile&") couldn't be renamed or settings.cfg is currently in use or write protected!")
		Endif
	Else
		MsgBox(0x30, "Sorry...", "No backup file ("&$backupfile&") could be found!")
	Endif
EndFunc

Func SSSOn()
	ConsoleWrite("Trying to switch on SSS..."&@LF)
	; Must be here. Otherwise backup gets SSS on!
	If(NOT FileExists ($pwsettingsdir&$backupfile))Then
		ConsoleWrite("No backup file. Creating new one..."&@LF)
		CreateBackup()
	Endif
	$errorcode = RunWait ("mod_conf.exe SSSOn """&@AppDataDir&"""")
	If($errorcode == 0 And @error == 0) Then
		ConsoleWrite("Success!"&@LF)
	Else
		ConsoleWrite("An error occured!"&@LF)
		If(AskBackup()) Then
			SSSOn()
		EndIf
	EndIf
EndFunc

Func SSSOff()
	ConsoleWrite("Trying to switch off SSS..."&@LF)
	$errorcode = RunWait ("mod_conf.exe SSSOff """&@AppDataDir&"""")
	If($errorcode == 0 And @error == 0) Then
		ConsoleWrite("Success!"&@LF)
	Else
		ConsoleWrite("An error occured!"&@LF)
		If(AskBackup()) Then
			SSSOff()
		EndIf
	EndIf
EndFunc

Func KillPW()
	ConsoleWrite("Killing PW..."&@LF)
	ProcessClose ( "Paraworld.exe" )
	ProcessClose ( "PWClient.exe" )
	ProcessClose ( "PWServer.exe" )
EndFunc

Func WaitForEnd()
	ConsoleWrite("Waiting for PW to terminate..."&@LF)
    Local $return
	While(1)
		$return = ProcessWaitClose ("Paraworld.exe", 1)
		if($return == 1) Then
			$return = ProcessWaitClose ("PWClient.exe", 1)
			if($return == 1) Then
				$return = ProcessWaitClose ("PWServer.exe", 1)
				if($return == 1) Then
					ExitLoop
				EndIf
			EndIf
		EndIf
	WEnd
	ConsoleWrite("Terminated! Executing..."&@LF)
	If($mod=="") Then
		ProcessClose ( "PWKiller.exe" )
		SSSOff()
	Else
		ShellExecute($mod)
	EndIf
EndFunc

Func StartPW()
	ConsoleWrite("Starting ParaWorld with mod '"&$mod&"'"&@LF)
	SSSOn()
	Run ("../bin/Paraworld.exe -enable "&$mod, "../bin/")
	Run ("PWKiller.exe")
	Run ("PWTool.exe Wait")
EndFunc

Func SDKPW()
	ConsoleWrite("Starting ParaWorld SDK with mod '"&$mod&"'"&@LF)
	SSSOn()
	Run ("../bin/PWClient.exe -leveled -enable "&$mod, "../bin/")
	Run ("PWKiller.exe")
	Run ("PWTool.exe Wait")
EndFunc

Func DedicatedPW()
	ConsoleWrite("Starting ParaWorld dedicated server with mod '"&$mod&"'"&@LF)
	SSSOn()
	Run ("../bin/Paraworld.exe -dedicated -enable "&$mod, "../bin/")
	Run ("PWKiller.exe")
	Run ("PWTool.exe Wait")
EndFunc
