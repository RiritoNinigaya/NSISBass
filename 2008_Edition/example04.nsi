; NSIS Music player using BASS Sound system (BASS.DLL) called
; using System::Call
;--------------------------------
!define BASS_LOCATION ".\bass.dll"
Name "NSISBASS Example"
ShowInstDetails "show"
CompletedText "Playing..."
OutFile "example04.exe"
SetCompressor /SOLID lzma

; nsisbass.nsh also includes bass.nsh, so you don't need to include this.
!include "nsisbass.nsh"

;--------------------------------

ReserveFile "theyear.xm"

Function .onInit

  !insertmacro NSISBASS_INIT
  File /oname=$PLUGINSDIR\theyear.xm "theyear.xm"
  !insertmacro NSISBASS_PLAYMUSIC "$PLUGINSDIR\theyear.xm" 0 ${BASS_SAMPLE_LOOP}

FunctionEnd

Function .onGUIInit
FunctionEnd

Function .onGUIEnd
  !insertmacro NSISBASS_FREE
FunctionEnd

Section ""
SectionEnd
