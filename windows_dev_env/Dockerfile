# escape=`

FROM mcr.microsoft.com/windows/servercore:1803-amd64 as installer


SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman
COPY qt-installer-noninteractive.qs C:\TEMP\

# Download and install Build Tools for Visual Studio 2017 for native desktop workload.
RUN  powershell -Command "Invoke-WebRequest 'https://aka.ms/vs/16/release/vs_buildtools.exe' -OutFile 'C:\TEMP\vs_buildtools.exe'" `
  && powershell -Command "Invoke-WebRequest 'http://releases.llvm.org/8.0.0/LLVM-8.0.0-win64.exe' -OutFile 'C:\TEMP\llvm.exe'" `
  && powershell -Command "Invoke-WebRequest 'http://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe' -OutFile 'C:\Temp\qt.exe'" `
  && (C:\Temp\qt.exe --script C:\Temp\qt-installer-noninteractive.qs --platform=minimal --logging-rules "ifw.*=true" --verbose || echo "Qt installed failed") `
  && C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Workload.VCTools `
    --add Microsoft.VisualStudio.Component.Windows10SDK `
    --add Microsoft.VisualStudio.Component.Windows10SDK.17763 `
    --add Microsoft.VisualStudio.Component.VC.Redist.14.Latest `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.Component.VC.Runtime.UCRTSDK `
    --add Microsoft.Component.MSBuild `
    --installPath C:\BuildTools `
  && powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" `
  && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin `
  && (RD /S /Q "C:\Users\%USERNAME%\AppData\Local\Temp" C:\Qt\Docs C:\Qt\Examples C:\Qt\Tools "C:\ProgramData\Package Cache" 2>nul || echo "Unable to remove file!") `
  && C:\ProgramData\chocolatey\choco.exe feature disable --name showDownloadProgress `
  && C:\ProgramData\chocolatey\choco.exe install git.install -y --params "'/GitAndUnixToolsOnPath /NoAutoCrlf'" `
  && C:\ProgramData\chocolatey\choco.exe install choco-cleaner nodejs ninja nsis -y --ignoredetectedreboot -ignore-package-exit-codes `
  && C:\ProgramData\chocolatey\choco.exe install cmake -y --ignoredetectedreboot -ignore-package-exit-codes --installargs 'ADD_CMAKE_TO_PATH=System' `
  && setx PATH "%path%;C:\\Program Files (x86)\\NSIS" `
  && "C:\Program Files\Git\bin\git" clone https://github.com/Microsoft/vcpkg.git C:\vcpkg `
  && C:\BuildTools\Common7\Tools\VsDevCmd.bat `
  && C:\vcpkg\bootstrap-vcpkg.bat -Verbose `
  && C:\BuildTools\Common7\Tools\VsDevCmd.bat && C:\vcpkg\vcpkg.exe install `
    boost-beast:x64-windows-static `
    boost-filesystem:x64-windows-static `
    boost-interprocess:x64-windows-static `
    boost-endian:x64-windows-static `
    boost-container-hash:x64-windows-static`
    boost-endian:x64-windows-static `
    boost-lexical-cast:x64-windows-static `
    boost-program-options:x64-windows-static `
    boost-scope-exit:x64-windows-static `
    boost-signals2:x64-windows-static `
    boost-utility:x64-windows-static  `
    boost-uuid:x64-windows-static `
    boost-bind:x64-windows-static `
    boost-chrono:x64-windows-static `
    boost-date-time:x64-windows-static `
    boost-type-traits:x64-windows-static `
    boost-static-assert:x64-windows-static `
    boost-function:x64-windows-static `
    boost-smart-ptr:x64-windows-static `
    boost-optional:x64-windows-static `
    openssl:x64-windows `
  && C:\ProgramData\chocolatey\tools\7z x C:\Temp\llvm.exe -oC:\LLVM `
  && (RD /S /Q C:\vcpkg\downloads C:\vcpkg\buildtrees C:\vcpkg\packages C:\Temp || echo "Unable to remove files!") `
  && C:\ProgramData\chocolatey\lib\choco-cleaner\tools\Choco-Cleaner-manual.bat

FROM mcr.microsoft.com/windows/nanoserver:1803

COPY --from=installer ["/BuildTools", "/BuildTools/"]
COPY --from=installer ["/Program Files/CMake", "/Program Files/CMake"]
COPY --from=installer ["/Program Files/nodejs", "/Program Files/nodejs"]
COPY --from=installer ["/Program Files/Git", "/Program Files/Git"]
COPY --from=installer ["/ProgramData/Git", "/ProgramData/Git"]
COPY --from=installer ["/ProgramData/chocolatey", "/ProgramData/chocolatey"]
COPY --from=installer ["/Program Files (x86)/Windows Kits", "/Program Files (x86)/Windows Kits"]
COPY --from=installer ["/Program Files (x86)/NSIS", "/Program Files (x86)/NSIS"]
COPY --from=installer ["/Program Files (x86)/Microsoft Visual Studio/Installer/", "/Program Files (x86)/Microsoft Visual Studio/Installer/"]
COPY --from=installer ["/vcpkg/", "/vcpkg/"]
COPY --from=installer ["/Qt/5.12.3", "/Qt/5.12.3" ]
COPY --from=installer ["/llvm", "/llvm" ]

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\ProgramData\chocolatey;C:\ProgramData\chocolatey\bin\;C:\ProgramData\chocolatey\tools\;C:\Program Files (x86)\Microsoft Visual Studio\Installer;C:\Program Files\CMake\bin;C:\Program Files\nodejs;C:\Program Files (x86)\NSIS;C:\Program Files\Git\bin"



# Use developer command prompt and start PowerShell if no other command specified.
#ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&
#CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]