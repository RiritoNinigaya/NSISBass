Name "NSISBASS Example"
ShowInstDetails "show"
CompletedText "Playing..."
OutFile "example07.exe"

SetCompressor /SOLID lzma

ReserveFile "${NSISDIR}\Plugins\system.dll"
ReserveFile "bass.dll"

Var BF_MUSICHANDLE
Var BF_STREAMHANDLE

!define BASS_DLL "$PLUGINSDIR\bass.dll"
!define BASS_URL "http://radioparadise.steadyhost.com:8032"
;!define BASS_URL "http://www.radioparadise.com/musiclinks/rp_16.m3u"

!define bf_Init "${BASS_DLL}::BASS_Init(i,i,i,i,i) b"
;!define bf_StreamCreateURL "${BASS_DLL}::BASS_StreamCreateURL(t,i,i,i,i) i"
!define bf_Start "${BASS_DLL}::BASS_Start() b"
!define bf_ChannelPlay "${BASS_DLL}::BASS_ChannelPlay(i,b) b"
!define bf_Stop "${BASS_DLL}::BASS_Stop() b"
!define bf_StreamFree "${BASS_DLL}::BASS_StreamFree(i) v"
!define bf_MusicFree "${BASS_DLL}::BASS_MusicFree(i) v"
!define bf_Free "${BASS_DLL}::BASS_Free() v"
!define bf_SetConfig "${BASS_DLL}::BASS_SetConfig(i,i) i"

;!define bf_StreamCreateURL "${BASS_DLL}::BASS_StreamCreateURL(t,i,i,n,i) i"

!define bf_StreamCreateURL "${BASS_DLL}::BASS_StreamCreateURL(t,i,i,k,i) i"

!define DOWNLOADPROC "(v,i,i) v"

!define bf_ChannelGetTags "${BASS_DLL}::BASS_ChannelGetTags(i,i) t"

;!define bf_ChannelGetInfo "${BASS_DLL}::BASS_ChannelGetInfo(i,*${BASS_CHANNELINFO}) b"

!define BASS_CONFIG_NET_PREBUF		15
!define BASS_CONFIG_NET_PLAYLIST	21


!include "WordFunc.nsh"
!insertmacro WordFind2X
Var cur_title
Var cur_url

Function .onInit
	!verbose push
	!verbose 3
	InitPluginsDir
	File "/oname=${BASS_DLL}" "bass.dll"
	System::Call /NOUNLOAD '${bf_Init} (-1,44100,0,0,0) .r0'
	System::Call /NOUNLOAD '${bf_SetConfig} (BASS_CONFIG_NET_PLAYLIST,1) .r0'
	System::Call /NOUNLOAD '${bf_SetConfig} (BASS_CONFIG_NET_PREBUF,0) .r0'

;System::Get "(i.r1, i) iss"
;System::Get "(i .r0, i .r1) isR0"
;!define DOWNLOADPROC "(v,i,i) v"

System::Get "*(v, i, i) vR0"
Pop $0
DetailPrint $0
	System::Call /NOUNLOAD '${bf_StreamCreateURL} (s,0,0,r0,0) .r1' ${BASS_URL}
	StrCpy $BF_STREAMHANDLE $1
	StrCmp $1 "0" BASS_FAIL
	System::Call /NOUNLOAD '${bf_Start} .r0'
	System::Call /NOUNLOAD '${bf_ChannelPlay} (r1,1) .r0'
	Goto BASS_EXIT

	BASS_FAIL:
	StrCmp $1 "0" 0 +2
	System::Call /NOUNLOAD "${bf_StreamFree} (r1)"
	System::Call /NOUNLOAD "${bf_Stop} () .r0"
	Push "failed"
	BASS_EXIT:
	!verbose pop
FunctionEnd

Function .onGUIInit
FunctionEnd

Function .onGUIEnd
	!verbose push
	!verbose 3
	Push $0
	Push $1
	System::Call /NOUNLOAD "${bf_Stop} () .r0"
	StrCpy $1 $BF_STREAMHANDLE
	System::Call /NOUNLOAD "${bf_StreamFree} (r1)"
	StrCpy $1 $BF_MUSICHANDLE
	System::Call /NOUNLOAD "${bf_MusicFree} (r1)"
	System::Call "${bf_Free} ()?u"
	Pop $1
	Pop $0
	!verbose pop
FunctionEnd

Section ""
	StrCpy $1 $BF_STREAMHANDLE
	System::Call /NOUNLOAD "${bf_ChannelGetTags} (r1,5) .r0"
  	${WordFind2X} $0 "StreamTitle='" "';StreamUrl='" "+1" $cur_title
  	${WordFind2X} $0 "StreamUrl='" "';" "+1" $cur_url
	;DetailPrint $0
  	DetailPrint "Now playing: $cur_title"
  	DetailPrint "From: $cur_url"

SectionEnd
