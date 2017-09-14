;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg


;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !insertmacro MUI_DEFAULT MUI_ICON "icon.ico"

;--------------------------------
;General

; ===============================================
; this file was generated with NSISDialogDesigner
; ===============================================

;Name and file
Name "ParaWorld ProcessKiller"
OutFile "paraworld_processkiller.exe"
Caption "ProcessKiller"

Function .onInit
  SetSilent silent
  StrCpy $0 "PWServer.exe"
  KillProc::KillProcesses
  StrCpy $0 "PWClient.exe"
  KillProc::KillProcesses
  StrCpy $0 "Paraworld.exe"
  KillProc::KillProcesses
  ;Processes::KillProcess "PWServer"
  ;Processes::KillProcess "PWClient"
  ;Processes::KillProcess "Paraworld"
  SendMessage $HWNDPARENT ${WM_CLOSE} 0 0"
FunctionEnd


  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Default installation folder
  ;InstallDir $INSTDIR

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "German"

;--------------------------------
;Installer Sections

Section "unused"
SectionEnd
