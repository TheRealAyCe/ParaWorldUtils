#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
_ProcessCloseEx("PWServer.exe")
_ProcessCloseEx("PWClient.exe")
_ProcessCloseEx("Paraworld.exe")

Func _ProcessCloseEx($sPID)
    If IsString($sPID) Then $sPID = ProcessExists($sPID)
    If Not $sPID Then Return SetError(1, 0, 0)

    Return Run(@ComSpec & " /c taskkill /F /PID " & $sPID & " /T", @SystemDir, @SW_HIDE)
EndFunc