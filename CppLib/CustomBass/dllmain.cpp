// dllmain.cpp : Defines the entry point for the DLL application.
#include "includes.h"
using namespace NSIS_SDK; 
#define EXPORT_DLL extern "C" __declspec(dllexport)
void NSISCALL PlayMusic(const char* filename) {
    BASSLib::BASS_Start();
    if (BASSLib::BASS_Init(-1, 48000, 0, 0, 0)) {
        BASSLib::HSTREAM stream_line = BASSLib::BASS_StreamCreateFile(false, (const WCHAR*)filename, 0, 0, BASS_SAMPLE_LOOP);
        if (stream_line)
        {
            BASSLib::BASS_ChannelPlay(stream_line, true);
        }
    }

}
BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

