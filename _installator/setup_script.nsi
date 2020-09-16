;NSIS Modern User Interface
;Basic Example Script
;Written by Joost Verburg

;--------------------------------
;Подключаемый модуль )

  !include "MUI.nsh"
  !include "Sections.nsh"
  !include "FileAssociation.nsh"

!define MUI_ICON "SpriteMaker.ico"

!define MUI_UNICON "SpriteMaker.ico"

;--------------------------------
;Главные параметры
!define TEMP1 $R0 ;

  ;Name and file
  Name "SpriteMaker"
  OutFile "SpriteMakerSetup.exe"
  RequestExecutionLevel admin 

Function .onInit
UserInfo::GetAccountType
pop $0

${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}

FunctionEnd



  ;Default installation folder
  InstallDir "$PROGRAMFILES\SpriteMaker"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\SpriteMaker" ""

ReserveFile "${NSISDIR}\Plugins\x86-unicode\InstallOptions.dll"
ReserveFile "testlink.ini"
 
;--------------------------------
;Объявление переменных

  Var STARTMENU_FOLDER 
  Var MUI_TEMP
;  Var PLUGINS_FOLDER
  Var SHOW_SERIAL

;--------------------------------
;Настройки интерфейса

  !define MUI_ABORTWARNING1

;--------------------------------
;Страницы инсталляции

  ; Приглашение
  !define MUI_WELCOMEPAGE_TITLE "SpriteMaker"
  !define MUI_WELCOMEPAGE_TEXT "This program will install SpriteMaker on your computer. Please press 'Next' to continue program installation."
  !insertmacro MUI_PAGE_WELCOME

  ; Лицензия
  !define MUI_LICENSEPAGE_RADIOBUTTONS
  !insertmacro MUI_PAGE_LICENSE "lic.txt"


  ; При выходе со страницы компонентов определяем показывать ли серийник или нет
  !define MUI_PAGE_CUSTOMFUNCTION_LEAVE myGuiInit

  !define MUI_PAGE_COMPONENTS_VARIABLE1 $PLUGINS_FOLDER
  ; Компоненты установки
  !insertmacro MUI_PAGE_COMPONENTS

  ; Ввод серийного номера
;  !if $SHOW_SERIAL >= 1

;    Page custom CreateSerialPage LeaveSerialPage ": sadasd"

;  !endif
    
  ; Папка для установки
  !insertmacro MUI_PAGE_DIRECTORY

  ; Меню программы
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\SpriteMaker" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "SpriteMaker"
  !insertmacro MUI_PAGE_STARTMENU "Application" $STARTMENU_FOLDER

  ; Меню выбора папки для установки 
  !insertmacro MUI_PAGE_INSTFILES

  ; Меню выбора папки для установки 
;  !insertmacro MUI_PAGE_INSTFILES
  
  ; Всякая фигня 
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
;Выбираем язык для установки
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections


Section ""



  SetOutPath "$INSTDIR"

  ;File dogbase.mde


  ;Store installation folder
  WriteRegStr HKCU "Software\SpriteMaker" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SpriteMaker" "DisplayName" "SpriteMaker (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SpriteMaker" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"


  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Удалить программу.lnk" "$INSTDIR\uninstall.exe" \
  		   "" "$INSTDIR\uninstall.exe" 2 SW_SHOWNORMAL \
		   ALT|CTRL|SHIFT|F5 ""

  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

;Section !Required
;  SectionIn RO
;SectionEnd

Section "SpriteMaker" INSTSECTION

  SetOutPath "$INSTDIR"

  
  ;ADD YOUR OWN FILES HERE...
  
  File SpriteMaker.exe
  File spritemaker.ico
  File libwebp32.dll
  File libwebp64.dll
  
  CreateDirectory "$INSTDIR\examples"
  SetOutPath "$INSTDIR\examples"

  File "examples\brick1.tgx"
  File "examples\brick2.tgx"
  File "examples\brick3.tgx"
  File "examples\brick4.tgx"
  File "examples\brick5.tgx"

  setOutPath "$INSTDIR"

  File SpriteMaker.ico	

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\SpriteMaker.lnk" "$INSTDIR\SpriteMaker.exe" \
  		 "" "$INSTDIR\SpriteMaker.exe" 2 SW_SHOWNORMAL \
		  ALT|CTRL|SHIFT|F5 ""
  !insertmacro MUI_STARTMENU_WRITE_END
  ;ExecWait "$INSTDIR\SpriteMaker.exe 1425EF2A63A7E26D0D3CEB36430C5652"
  ;ExecShell "open" "$INSTDIR\SpriteMaker.exe" "1425EF2A63A7E26D0D3CEB36430C5652" SW_HIDE

  ${registerExtension} "$INSTDIR\SpriteMaker.exe" ".tgx" "Sprite Maker File"  

SectionEnd

;Section "Клиент просмотра данных" INSTSECTIONLITE

  ;SetOutPath "$INSTDIR"
  
  ;ADD YOUR OWN FILES HERE...
  
  ;File dogbaselite.exe

 
  ;!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    ;CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\База данных договоров просмотр.lnk" "$INSTDIR\dogbaselite.exe" \
	;	 "" "$INSTDIR\dogbaselite.exe" 2 SW_SHOWNORMAL \
	;	  ALT|CTRL|SHIFT|F6 ""
  ;!insertmacro MUI_STARTMENU_WRITE_END
  
  ;Exec "$INSTDIR\dogbaselite.exe 6A8BE86F4042D78EE0D4CC9683F2CD83" 
  
;SectionEnd


;--------------------------------
;Descriptions
  
  LangString DESC_Section1 ${LANG_RUSSIAN} "Полнофункциональный модуль."
  LangString DESC_Section2 ${LANG_RUSSIAN} "Модуль с ограничениями на изменение данных."

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${INSTSECTION} $(DESC_Section1)
    !insertmacro MUI_DESCRIPTION_TEXT ${INSTSECTIONLITE} $(DESC_Section2)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ${unregisterExtension} ".tgx" "Sprite Maker File"  

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\SpriteMaker.exe"

  Delete "$INSTDIR\config.cfg"

  Delete "$INSTDIR\Uninstall.exe"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP
  
  StrCmp $MUI_TEMP "" startMenuDeleteLoopDone
  RMDir /r "$SMPROGRAMS\$MUI_TEMP"

startMenuDeleteLoopDone:


  RMDir /r "$INSTDIR"

  DeleteRegKey HKLM "Software\SpriteMaker"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\SpriteMaker"

SectionEnd


; Создаем страницу с серийником
Function CreateSerialPage

;  Push ${TEMP1}
 ; MessageBox MB_OK $SHOW_SERIAL

  IntCmp $SHOW_SERIAL 1 NOSKIP

  Abort

NOSKIP:
    InstallOptions::dialog "$PLUGINSDIR\test.ini"
  ;  Pop ${TEMP1}
  
  Pop ${TEMP1}

FunctionEnd

; Нажатие кнопки далее на странице с серийником
Function LeaveSerialPage

  ReadINIStr $0 "$PLUGINSDIR\test.ini" "Field 5" "State"
  MessageBox MB_OK $0
  Abort
	
;  StrCmp ${TEMP1} 1 done
  
;done:

FunctionEnd


Function .onSelChange


  !insertmacro StartRadioButtons $1
    !insertmacro RadioButton ${INSTSECTION}
;    !insertmacro RadioButton ${INSTSECTIONLITE}
  !insertmacro EndRadioButtons

 ; SectionGetFlags 1 $0

 ; MessageBox MB_OK "$0"
	
FunctionEnd

Function myGUIInit
   
  SectionGetFlags 1 $SHOW_SERIAL

;    Abort
FunctionEnd