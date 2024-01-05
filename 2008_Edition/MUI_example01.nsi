;comment this out for comptibility or if you do not have upx, otherwise go download it!
!packhdr "tmp.dat" "c:\upx\upx.exe -9 tmp.dat"

!include "MUI2.nsh"

Name "NSISBASS MUI Example"
Caption "NSISBASS Example"
OutFile "MUI_example01.exe"
SetCompressor /SOLID lzma

!include "nsisbass.nsh"

!include "WordFunc.nsh"
!insertmacro WordFind
!insertmacro WordFind2X
!insertmacro StrFilter

!include "LogicLib.nsh"

!include "nsDialogs.nsh"

!Include "WinMessages.nsh"

RequestExecutionLevel user

!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-blue.ico"

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "logo_bass.bmp"
!define MUI_HEADERIMAGE_RIGHT
!define MUI_FINISHPAGE_NOAUTOCLOSE

Page custom BassRadio

!insertmacro MUI_LANGUAGE "English"

Function .onInit
  ${NSISBASS_Init}
FunctionEnd

Function .onGUIEnd
  ${NSISBASS_Free}
FunctionEnd

Section "main"
SectionEnd


LangString PAGE_TITLE ${LANG_ENGLISH} "NSISBASS Radio"
LangString PAGE_SUBTITLE ${LANG_ENGLISH} "Example usage of NSISBASS with MUI2 and nsDialogs"


Function BassRadio

  Var /GLOBAL hndComboBox
  Var /GLOBAL hndButPlay
  Var /GLOBAL hndButPause
  Var /GLOBAL hndButStop
  Var /GLOBAL hndLabelCombo
  Var /GLOBAL hndButBrowse
  Var /GLOBAL hndLabelStreamTitle
  Var /GLOBAL hndLabelStreamUrl
  Var /GLOBAL hndLinkStreamUrl 
  Var /GLOBAL hndTextSetVol
  Var /GLOBAL hndButSetVol
  Var /GLOBAL hndButUpdateInfo
  Var /GLOBAL hndLabelCPU
  Var /GLOBAL hndLabelHTTPTags
  Var /GLOBAL hndCheckBoxRepeat
  ;Var /GLOBAL hndVLineLeft
  ;Var /GLOBAL hndVLineRight
  Var /GLOBAL hndLabelChanLev


  Var /GLOBAL BassRadioFlags
  StrCpy $BassRadioFlags "0"

  !insertmacro MUI_HEADER_TEXT $(PAGE_TITLE) $(PAGE_SUBTITLE)

  nsDialogs::Create /NOUNLOAD 1018


  ; Select Stream/File label, combobox and browse
  
  ${NSD_CreateLabel} 0% 0% 100% 12u "Enter or select a file or internet radio stream:"
  Pop $hndLabelCombo

  ${NSD_CreateComboBox} 0% 10% 87% 12u
  Pop $hndComboBox
  SendMessage $hndComboBox ${CB_ADDSTRING} 0 "STR:http://207.111.214.243:8032" ; Radio Paradise 16k
  SendMessage $hndComboBox ${CB_ADDSTRING} 0 "STR:http://208.122.59.30:7064" ; Sky FM Classical Low
  SendMessage $hndComboBox ${CB_ADDSTRING} 0 "STR:http://steady.somafm.com:8082" ; SomaFM: Secret Agent 24k

  ;${NSD_OnChange} $hndComboBox BassRadioPlayNet

  ${NSD_CreateButton} 89% 10% 10% 12u "Browse"
  Pop $hndButBrowse
  ${NSD_OnClick} $hndButBrowse BassRadioSelectFile


  ; Play, Pause and Stop

  ${NSD_CreateButton} 0% 25% 10% 12u "Play"
  Pop $hndButPlay
  ${NSD_OnClick} $hndButPlay BassRadioPlay

  ${NSD_CreateButton} 15% 25% 10% 12u "Pause"
  Pop $hndButpause
  ${NSD_OnClick} $hndButpause BassRadioPauseResume

  ${NSD_CreateButton} 30% 25% 10% 12u "Stop"
  Pop $hndButStop
  ${NSD_OnClick} $hndButStop BassRadioStop


  ; Volume Controls

  ${NSD_CreateButton} 45% 25% 10% 12u "Volume:"
  Pop $hndButSetVol
  ${NSD_OnClick} $hndButSetVol BassRadioSetVol
  ${NSD_CreateText} 57% 25% 8% 12u "100"
  Pop $hndTextSetVol
  ${NSD_CreateLabel} 68% 25% 5% 12u "%"

  ;Repeat
  ${NSD_CreateCheckBox} 75% 25% 15% 12u "Repeat"
  Pop $hndCheckBoxRepeat
  ${NSD_OnClick} $hndCheckBoxRepeat BassRadioRepeat


  ; Status and Info controls

  ${NSD_CreateHLine} 0% 40% 100% 1u
  ${NSD_CreateVLine} 0% 40% 1u 50%


  ${NSD_CreateLabel} 2% 45% 80% 12u "Now playing: "
  Pop $hndLabelStreamTitle
  ${NSD_CreateLabel} 2% 55% 10% 12u "From: "
  Pop $hndLabelStreamUrl
  ${NSD_CreateLink} 12% 55% 56% 12u ""
  Pop $hndLinkStreamUrl
  ${NSD_OnClick} $hndLinkStreamUrl BassRadioLinkClick
  ;${NSD_OnClick} $hndLabelStreamUrl BassRadioLinkClick

  ${NSD_CreateLabel} 2% 65% 80% 12u "Shoutcast - HTTP tags: "
  Pop $hndLabelHTTPTags

  ${NSD_CreateLabel} 2% 75% 80% 12u "BASS CPU usage: "
  Pop $hndLabelCPU

  ${NSD_CreateLabel} 82% 57% 15% 12u "Lev: "
  Pop $hndLabelChanLev

  ${NSD_CreateButton} 82% 77% 15% 12u "Update Info"
  Pop $hndButUpdateInfo
  ${NSD_OnClick} $hndButUpdateInfo BassRadioUpdateInfo

  ${NSD_CreateHLine} 0% 88% 100% 1u
  ${NSD_CreateVLine} 99% 40% 1u 50%

  ;${NSD_CreateVLine} 86% 45% 2% 20%
  ;Pop $hndVLineRight
  ;${NSD_CreateVLine} 84% 45% 2% 20%
  ;Pop $hndVLineLeft

  nsDialogs::Show

FunctionEnd

Function BassRadioPlay
  Var /GLOBAL txtComboBox
  Var /Global SourceType
  Call BassRadioStop
  Call BassRadioClearInfo
  ${NSD_GetText} $hndComboBox $txtComboBox
  ${WordFind} $txtComboBox "://" "+01{" $SourceType
  ${StrFilter} $SourceType "-" "" "" $SourceType
  ${If} $SourceType == "http" 
    Call BassRadioPlayNet
  ${ElseIf} $SourceType == "ftp"
    Call BassRadioPlayNet
  ${Else}
    ${WordFind} $txtComboBox "." "-01}" $SourceType
    ${StrFilter} $SourceType "-" "" "" $SourceType
    ${Switch} $SourceType
      ${Case} 'mo3'
        Call BassRadioPlayMusic
        ${Break}
      ${Case} 'mod'
        Call BassRadioPlayMusic
        ${Break}
      ${Case} 'xm'
        Call BassRadioPlayMusic
        ${Break}
      ${Case} 'it'
        Call BassRadioPlayMusic
        ${Break}
      ${Case} 'mp3'
        Call BassRadioPlayFile
        ${Break}
      ${Case} 'ogg'
        Call BassRadioPlayFile
        ${Break}
      ${Case} 'wav'
        Call BassRadioPlayFile
        ${Break}
      ${Default}
        Call BassRadioPlayFile
        ${Break}
    ${EndSwitch}
  ${EndIf}
FunctionEnd

Function BassRadioPlayNet
  ${NSISBASS_PlayNet} $txtComboBox 0 0 0 0
  Call BassRadioComboBoxAdd
  Call BassRadioUpdateInfo
FunctionEnd

Function BassRadioPlayMusic
  ${NSISBASS_PlayMusic} $txtComboBox 0 $BassRadioFlags
  Call BassRadioComboBoxAdd
  Call BassRadioUpdateInfo
FunctionEnd

Function BassRadioPlayFile
  ${NSISBASS_Play} $txtComboBox 0 $BassRadioFlags
  Call BassRadioComboBoxAdd
  Call BassRadioUpdateInfo
FunctionEnd

Function BassRadioComboBoxAdd
  ${NSISBASS_ErrorGetCode}
  ${If} $0 = 0
    SendMessage $hndComboBox ${CB_FINDSTRING} 0 "STR:$txtComboBox" $0
    ${If} $0 = -1
      SendMessage $hndComboBox ${CB_ADDSTRING} 0 "STR:$txtComboBox" ; Add file/url to combobox list
    ${EndIf}
  ${EndIf}
FunctionEnd

Function BassRadioSetVol
  Var /GLOBAL txtSetVol
  ${NSD_GetText} $hndTextSetVol $txtSetVol
  ${NSISBASS_SetVolume} $txtSetVol
  ${NSISBASS_GetVolume}
  SendMessage $hndTextSetVol ${WM_SETTEXT} 0 "STR:$0"
FunctionEnd

Function BassRadioUpdateInfo
    ${Switch} $SourceType
      ${Case} 'http'
        Call BassRadioUpdateInfoNet
        ${Break}
      ${Case} 'ftp'
        Call BassRadioUpdateInfoNet
        ${Break}
      ${Case} 'mo3'
        Call BassRadioUpdateInfoMod
        ${Break}
      ${Case} 'mod'
        Call BassRadioUpdateInfoMod
        ${Break}
      ${Case} 'xm'
        Call BassRadioUpdateInfoMod
        ${Break}
      ${Case} 'it'
        Call BassRadioUpdateInfoMod
        ${Break}
      ${Case} 'mp3'
        Call BassRadioUpdateInfoMpeg
        ${Break}
      ${Case} 'ogg'
        Call BassRadioUpdateInfoOgg
        ${Break}
      ${Case} 'wav'
        Call BassRadioUpdateInfoWav
        ${Break}
      ${Default}

        ${Break}
    ${EndSwitch}

  ${NSISBASS_ChanGetLevel}
  SendMessage $hndLabelChanLev ${WM_SETTEXT} 0 "STR:$0"
FunctionEnd


Function BassRadioUpdateInfoNet
  Var /GLOBAL cur_title
  Var /GLOBAL cur_url
  Var /GLOBAL scasthttp
  ${NSISBASS_GetTags} ${BASS_TAG_ICY}
  StrCpy $scasthttp $0
  StrCpy $scasthttp "$scasthttp - "
  ${NSISBASS_GetTags} ${BASS_TAG_HTTP}
  StrCpy $scasthttp "$scasthttp$0"
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:Shoutcast - HTTP tags: $scasthttp"
  ${NSISBASS_GetTags} ${BASS_TAG_META}
  ${WordFind2X} $0 "StreamTitle='" "';StreamUrl='" "+1" $cur_title
  ${WordFind2X} $0 "StreamUrl='" "';" "+1" $cur_url
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: $cur_title"
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:$cur_url"
  Call BassRadioGetCPU
FunctionEnd

Function BassRadioUpdateInfoMpeg
  Var /GLOBAL BassRadioID3Tag
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:"
  ${NSISBASS_GetTags} ${BASS_TAG_ID3}
  ${WordFind} $0 "TAG" "+01}" $BassRadioID3Tag
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: $BassRadioID3Tag"
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:$txtComboBox"
  Call BassRadioGetCPU
FunctionEnd

Function BassRadioUpdateInfoMod
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:"
  ${NSISBASS_GetTags} ${BASS_TAG_MUSIC_NAME}
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: $0"
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:$txtComboBox"
  Call BassRadioGetCPU
FunctionEnd

Function BassRadioUpdateInfoOgg
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:"
  ${NSISBASS_GetTags} ${BASS_TAG_OGG}
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: $0"
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:$txtComboBox"
  Call BassRadioGetCPU
FunctionEnd

Function BassRadioUpdateInfoWav
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:"
  ${NSISBASS_GetTags} ${BASS_TAG_RIFF_INFO}
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: $0"
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:$txtComboBox"
  Call BassRadioGetCPU
FunctionEnd

Function BassRadioSelectFile
  Var /GLOBAL txtSelectedFile
  nsDialogs::SelectFileDialog /NOUNLOAD "open" "" "All Playable Files|*.mp3;*.wav;*.ogg;*.mod;*.mo3;*.xm;*.it;*.stm;*.s3m|MPEG Audio (*.mp3)|*.mp3|WAVE audio (*.wav)|*.wav|OGG Vorbis (*.ogg)|*.ogg|Protracker (*.mod)|*.mod|MO3 modules (*.mo3)|*.mo3|FastTracker (*.xm)|*.xm|ImpulseTracker (*.it)|*.it|ScreamTracker v2 (*.stm)|*.stm|ScreamTracker v3 (*.s3m)|*.s3m|All Files (*.*)|*.*"
  Pop $txtSelectedFile
  IfFileExists $txtSelectedFile FileFound FileNotFound
  FileFound:
    SendMessage $hndComboBox ${WM_SETTEXT} 0 "STR:$txtSelectedFile"
  FileNotFound:
FunctionEnd

Function BassRadioLinkClick
  Var /GLOBAL txtLinkClicked
  ${NSD_GetText} $hndLinkStreamUrl $txtLinkClicked
  ${IfNot} $txtLinkClicked == ""
    ExecShell "open" $txtLinkClicked
  ${EndIf}
FunctionEnd

Function BassRadioClearInfo
  SendMessage $hndLabelHTTPTags ${WM_SETTEXT} 0 "STR:Shoutcast - HTTP tags: "
  SendMessage $hndLabelStreamTitle ${WM_SETTEXT} 0 "STR:Now playing: "
  SendMessage $hndLabelStreamUrl ${WM_SETTEXT} 0 "STR:From: "
  ; note the next long line of spaces - a hack to clear the wonky link control
  SendMessage $hndLinkStreamUrl ${WM_SETTEXT} 0 "STR:                                                                                                              "
  SendMessage $hndLabelCPU ${WM_SETTEXT} 0 "STR:BASS CPU usage: "
FunctionEnd

Function BassRadioPauseResume
  ${NSISBASS_IsPaused}
  Pop $0
  ${If} $0 = 1
    ${NSISBASS_Resume}
    SendMessage $hndButpause ${WM_SETTEXT} 0 "STR:Pause"
  ${Else}
    ${NSISBASS_Pause}
    SendMessage $hndButpause ${WM_SETTEXT} 0 "STR:Resume"
  ${EndIf}
FunctionEnd

Function BassRadioGetCPU
  ${NSISBASS_GetCPU}
  SendMessage $hndLabelCPU ${WM_SETTEXT} 0 "STR:BASS CPU usage: $0%"
FunctionEnd

Function BassRadioRepeat
  ${NSD_GetState} $hndCheckBoxRepeat $0
  ${If} $0 = 1
    StrCpy $BassRadioFlags ${BASS_SAMPLE_LOOP}
  ${Else}
    StrCpy $BassRadioFlags "0"
  ${EndIf}
FunctionEnd

Function BassRadioStop
  ${NSISBASS_Stop}
  SendMessage $hndButpause ${WM_SETTEXT} 0 "STR:Pause"
FunctionEnd