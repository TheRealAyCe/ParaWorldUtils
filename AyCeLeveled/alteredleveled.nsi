;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "PW altered leveled v7"
  ;!insertmacro MUI_DEFAULT MUI_ICON "sicon.ico"
  OutFile "pwaycesdk.exe"

Function .onInit
   ClearErrors
   ReadRegStr $INSTDIR HKLM "SOFTWARE\Sunflowers\ParaWorld" "InstallDir"
   IfErrors nopw
   Goto nopwend
   nopw:
   MessageBox MB_OK|MB_ICONEXCLAMATION "The installer could not detect an installation of ParaWorld. You have to set the ParaWorld-path yourself."
   StrCpy $INSTDIR "[insert ParaWorld directory here]"
   nopwend:
   ClearErrors
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

  !insertmacro MUI_PAGE_LICENSE "note.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"
;--------------------------------
;Installer Sections

Section "" Basic
  SetOutPath "$INSTDIR\Data\leveled"
  File /r "data\"

SectionEnd