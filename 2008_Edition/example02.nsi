; NSIS Music player using BASS Sound system (BASS.DLL) called
; using System::Call
;--------------------------------
!define BASS_LOCATION ".\bass.dll"
Name "NSISBASS Example"
ShowInstDetails "show"
CompletedText "Playing..."
OutFile "example02.exe"
SetCompressor /SOLID lzma

; nsisbass.nsh also includes bass.nsh, so you don't need to include this.
!include "nsisbass.nsh"

;--------------------------------

ReserveFile "VOY.MP3"

Function .onInit

  !insertmacro NSISBASS_INIT
  File /oname=$PLUGINSDIR\VOY.MP3 "VOY.MP3"
  !insertmacro NSISBASS_PLAY "$PLUGINSDIR\VOY.MP3" 0 ${BASS_SAMPLE_LOOP}

FunctionEnd

Function .onGUIInit
FunctionEnd

Function .onGUIEnd
  !insertmacro NSISBASS_FREE
FunctionEnd

Section ""
  !insertmacro NSISBASS_GETTAGS ${BASS_TAG_ID3}
  DetailPrint $0
SectionEnd
