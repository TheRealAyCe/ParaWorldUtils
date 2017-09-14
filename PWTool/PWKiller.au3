#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pwicon.ico
#AutoIt3Wrapper_Outfile=PWKiller.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=2012 © Para-Welt.com
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)
Opt('TrayIconHide', 1)

PWKiller()

Func PWKiller()
    Local $button, $msg, $label
    GUICreate("PW Un-Crasher", 300, 300)
	$label = GUICtrlCreateLabel("If ParaWorld crashes or does not terminate, press this button!", 10, 10, 280, 150, $SS_CENTER)
	GUICtrlSetFont ($label, 21, 1000)
    $button = GUICtrlCreateButton("End processes", 10, 170, 280, 120)
	GUICtrlSetFont ($button, 20, 1000)
	GUICtrlSetState ( $button, $GUI_DEFBUTTON )
    GUISetState()

    While 1
        $msg = GUIGetMsg()
        Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
            Case $msg = $button
				ProcessClose ( "Paraworld.exe" )
				ProcessClose ( "PWClient.exe" )
				ProcessClose ( "PWServer.exe" )
        EndSelect
    WEnd
EndFunc