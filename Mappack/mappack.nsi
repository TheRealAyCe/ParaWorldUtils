;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "ParaWorld BIG Community Mappack v5.0"
    !insertmacro MUI_DEFAULT MUI_ICON "pwinstaller2.ico"
  OutFile "mappack.exe"

Function .onInit
   InitPluginsDir
   File /oname=$PLUGINSDIR\splash.bmp "mappack.bmp"
   splash::show 60000 $PLUGINSDIR\splash
   ClearErrors
   ReadRegStr $INSTDIR HKLM "SOFTWARE\Sunflowers\ParaWorld" "InstallDir"
   IfErrors nopw
   StrCpy $INSTDIR "$INSTDIR\Data\Base\Maps\Multiplayer\"
   Goto nopwend
   nopw:
   MessageBox MB_OK|MB_ICONEXCLAMATION "The installer could not detect an installation of ParaWorld. You have to set the install directory yourself."
   StrCpy $INSTDIR "[insert multiplayer-maps directory here]"
   nopwend:
FunctionEnd

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Default installation folder
  InstallDir "$INSTDIR"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "desc.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "" Map

  SetOutPath "$INSTDIR"

  ; Remove old maps
  Delete "$INSTDIR\ParaLeague-Gauntlet-1on1-Standard.ula"
  Delete "$INSTDIR\ParaLeague-Vesuv-1on1-Standard.ula"

  ;ADD YOUR OWN FILES HERE...
  File /r "maps\"

SectionEnd