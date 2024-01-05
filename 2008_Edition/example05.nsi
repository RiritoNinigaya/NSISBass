; NSIS Music player using BASS Sound system (BASS.DLL) called
; using System::Call
;--------------------------------
!define BASS_LOCATION ".\bass.dll"
Name "NSISBASS Example"
ShowInstDetails "show"
CompletedText "Playing..."
OutFile "example05.exe"
SetCompressor /SOLID lzma


; nsisbass.nsh also includes bass.nsh, so you don't need to include this.
!include "nsisbass.nsh"

!include "WordFunc.nsh"
!insertmacro WordFind2X

;--------------------------------


Function .onInit

  !insertmacro NSISBASS_INIT
  !insertmacro NSISBASS_PLAYNET "http://radioparadise.steadyhost.com:8032" 0 0 0 0

FunctionEnd

Function .onGUIInit
FunctionEnd

Function .onGUIEnd
  !insertmacro NSISBASS_FREE
FunctionEnd

Section ""

  Var /GLOBAL cur_title
  Var /GLOBAL cur_url

  !insertmacro NSISBASS_GETTAGS ${BASS_TAG_ICY}
  ;MessageBox MB_OK $0
  DetailPrint "Shoutcast header: $0"


  !insertmacro NSISBASS_GETTAGS ${BASS_TAG_META}

  ${WordFind2X} $0 "StreamTitle='" "';StreamUrl='" "+1" $cur_title
  ${WordFind2X} $0 "StreamUrl='" "';" "+1" $cur_url

  DetailPrint "Now playing: $cur_title"
  DetailPrint "From: $cur_url"

 ;!insertmacro NSISBASS_GETVOLUME
 ; DetailPrint "BASS Volume: $0%"

 !insertmacro NSISBASS_SETVOLUME 25
 !insertmacro NSISBASS_GETVOLUME
  DetailPrint "BASS Volume: $0%"
  Sleep 3000
 !insertmacro NSISBASS_SETVOLUME 50
 !insertmacro NSISBASS_GETVOLUME
  DetailPrint "BASS Volume: $0%"
  Sleep 3000
 !insertmacro NSISBASS_SETVOLUME 100
 !insertmacro NSISBASS_GETVOLUME
  DetailPrint "BASS Volume: $0%"

 !insertmacro NSISBASS_GETTCPU
  DetailPrint "BASS CPU usage: $0%"

 ;!insertmacro NSISBASS_CHANNELSETFX ${BASS_FX_REVERB} 1

SectionEnd
