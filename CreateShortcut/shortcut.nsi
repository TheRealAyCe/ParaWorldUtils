;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "Paraworld Boosterpack ShortCutMaker"
  !insertmacro MUI_DEFAULT MUI_ICON "${NSISDIR}\createshortcut\scicon.ico"
  OutFile "pw_bp_shortcut.exe"

Function .onInit
 ClearErrors
 ReadRegStr $INSTDIR HKLM "SOFTWARE\Sunflowers\ParaWorld" "InstallDir"
 IfErrors nopw
 StrCpy $INSTDIR "$INSTDIR"
 ClearErrors
 CreateShortCut "$DESKTOP\ParaWorld Boosterpack.lnk" "$INSTDIR\bin\Paraworld.exe" "-enable boosterpack1" "$INSTDIR\bin\Paraworld.exe" 0
 IfErrors scerror
 MessageBox MB_OK|MB_ICONEXCLAMATION "Successfully created shortcut on the Desktop."
 Goto donef
  scerror:
   MessageBox MB_OK|MB_ICONEXCLAMATION "Program failed to create shortcut..."
   Goto donef
  nopw:
   MessageBox MB_OK|MB_ICONEXCLAMATION "Installer can't find Paraworld installation. Program aborted."
  donef:
  quit
FunctionEnd

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Default installation folder
  InstallDir $INSTDIR

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------
;Installer Sections

Section "" Basic

SectionEnd