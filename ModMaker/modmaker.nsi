;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg


;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "ReplaceInFile.nsh"
  !include "Trim.nsh"
  !insertmacro MUI_DEFAULT MUI_ICON "icon.ico"

;--------------------------------
;General

Var hCtl_test
Var hCtl_test_Font
;Var hCtl_test_Button1
;Var hCtl_test_Button1_Font
Var hCtl_test_TextBox1
Var hCtl_test_TextBox1_Font
Var hCtl_test_Label1
Var hCtl_test_Label1_Font

Var MODNAME

;Name and file
Name "Paraworld Mod Maker"
OutFile "paraworld_modmaker.exe"

Function .onInit
   StrCpy $MODNAME "SampleMod";
   ClearErrors
   ReadRegStr $INSTDIR HKLM "SOFTWARE\Sunflowers\ParaWorld" "InstallDir"
   IfErrors nopw
   ;StrCpy $INSTDIR "$INSTDIR"
   Goto nopwend
   nopw:
   MessageBox MB_OK|MB_ICONEXCLAMATION "The installer could not detect an installation of ParaWorld. You have to set the install directory yourself."
   StrCpy $INSTDIR "[insert ParaWorld dircetory here]"
   nopwend:
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

  !insertmacro MUI_PAGE_LICENSE "desc_mod.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom fnc_test_Create
  !insertmacro MUI_PAGE_INSTFILES
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Function fnc_test_Create
  
  ; === test (type: Dialog) ===

  GetFunctionAddress $1 onBack
  GetFunctionAddress $2 onChange

  nsDialogs::Create 1018
  Pop $hCtl_test

  nsDialogs::OnBack $1

  ${If} $hCtl_test == error
    Abort
  ${EndIf}
  CreateFont $hCtl_test_Font "Microsoft Sans Serif" "8.25" "400"
  SendMessage $hCtl_test ${WM_SETFONT} $hCtl_test_Font 0
  !insertmacro MUI_HEADER_TEXT "Name of the mod" "Please specify the name for the mod."
  
  ; === TextBox1 (type: Text) ===
  ${NSD_CreateText} 12 85 426 20 "$MODNAME"
  Pop $hCtl_test_TextBox1
  CreateFont $hCtl_test_TextBox1_Font "Microsoft Sans Serif" "8.25" "400"
  SendMessage $hCtl_test_TextBox1 ${WM_SETFONT} $hCtl_test_TextBox1_Font 0
  SetCtlColors $hCtl_test_TextBox1 0x000000 0xFFFFFF
  nsDialogs::OnChange $hCtl_test_TextBox1 $2

  ; === Button1 (type: Button) ===
  ;${NSD_CreateButton} 62 127 328 25 "Done, create mod"
  ;Pop $hCtl_test_Button1
  ;CreateFont $hCtl_test_Button1_Font "Microsoft Sans Serif" "8.25" "400"
  ;SendMessage $hCtl_test_Button1 ${WM_SETFONT} $hCtl_test_Button1_Font 0
  ;nsDialogs::OnClick $hCtl_test_Button1 $1
  
  ; === Label1 (type: Label) ===
  ${NSD_CreateLabel} 12 22 426 33 "Type in the name for your mod. It should only have a-z, A-Z, 0-9, _-. in its name! NO WHITESPACES!"
  Pop $hCtl_test_Label1
  CreateFont $hCtl_test_Label1_Font "Microsoft Sans Serif" "8.25" "400"
  SendMessage $hCtl_test_Label1 ${WM_SETFONT} $hCtl_test_Label1_Font 0
  
  ; === HLine1 (type: HLine) ===
  ${NSD_CreateHLine} 12 64 426 2 ""


  Call onChange
  nsDialogs::Show
  
FunctionEnd

Function onBack
  Pop $0
  ${NSD_GetText} $hCtl_test_TextBox1 $MODNAME
  Push $MODNAME
  Call Trim
  Pop $MODNAME
FunctionEnd

Function onChange
  Pop $0
  ${NSD_GetText} $hCtl_test_TextBox1 $MODNAME
  Push $MODNAME
  Call Trim
  Pop $MODNAME
  StrCmp $MODNAME "" notok
  GetDlgItem $0 $HWNDPARENT 1
  EnableWindow $0 1
  goto theend
  notok:
  GetDlgItem $0 $HWNDPARENT 1
  EnableWindow $0 0
  theend:
FunctionEnd

Section "" Basic

  SetOutPath "$INSTDIR\data\info\"

  ;ADD YOUR OWN FILES HERE...
  File /oname=$MODNAME.info "mmdata\modinfo.info"

  !insertmacro ReplaceInFile "$INSTDIR\data\info\$MODNAME.info" "[MOD]" "$MODNAME"

  SetOutPath "$INSTDIR\data\$MODNAME\"

  ;ADD YOUR OWN FILES HERE...
  File /r "mmdata\modfolder\"

  ; --->>>
  ; For the shortcuts!
  SetOutPath "$INSTDIR\bin"
  ; <<<---
  CreateShortCut "$DESKTOP\ParaWorld $MODNAME.lnk" "$INSTDIR\bin\Paraworld.exe" "-enable $MODNAME" "$INSTDIR\bin\Paraworld.exe" 0
  CreateShortCut "$DESKTOP\ParaWorld $MODNAME SDK.lnk" "$INSTDIR\bin\PWClient.exe" "-leveled -enable $MODNAME" "$INSTDIR\bin\Paraworld.exe" 0

  Exec "$INSTDIR\Tools\ClearCache.exe"

SectionEnd
