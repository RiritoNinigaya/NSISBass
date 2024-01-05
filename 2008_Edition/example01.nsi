; NSIS Music player using BASS Sound system (BASS.DLL) called
; using System::Call
;--------------------------------
!define BASS_LOCATION ".\bass.dll"
Name "NSISBASS Example"
ShowInstDetails "show"
CompletedText "Playing..."
OutFile "example01.exe"
SetCompressor /SOLID lzma

; nsisbass.nsh also includes bass.nsh, so you don't need to include this.
!include "nsisbass.nsh"

;--------------------------------

ReserveFile "bf_p3.mo3"

Function .onInit

  !insertmacro NSISBASS_INIT
  File /oname=$PLUGINSDIR\bf_p3.mo3 "bf_p3.mo3"
  !insertmacro NSISBASS_PLAYMUSIC "$PLUGINSDIR\bf_p3.mo3" 0 ${BASS_SAMPLE_LOOP}

FunctionEnd

Function .onGUIInit
FunctionEnd

Function .onGUIEnd
  !insertmacro NSISBASS_FREE
FunctionEnd

Section ""
DetailPrint "Title: Fate's Motion - Black F"
DetailPrint "File: bf_p3.mo3"
DetailPrint "Size: 215035 bytes"
DetailPrint "Format: Impulse Tracker - MO3"
DetailPrint "Sample ratio: 10.7%"
DetailPrint "Channels: 26"
DetailPrint "Patterns: 128"
DetailPrint "Samples: 14 - 1x8 bit 13x16 bit"
DetailPrint "Length: 5:47 - 40 orders"
SectionEnd
