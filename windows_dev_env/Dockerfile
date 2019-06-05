# escape=`

FROM mcr.microsoft.com/windows/servercore:1803-amd64


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
  && (RD /S /Q "C:\Users\%USERNAME%\AppData\Local\Temp" C:\Qt\Docs C:\Qt\Examples C:\Qt\Tools "C:\ProgramData\Package Cache" 2>nul || echo "Unable to remove file!")

RUN powershell choco feature disable --name showDownloadProgress && choco install git.install -y --params "'/GitAndUnixToolsOnPath /NoAutoCrlf'" `
  && choco install nodejs ninja 7zip nsis -y --ignoredetectedreboot -ignore-package-exit-codes `
  && powershell choco install cmake -y --ignoredetectedreboot -ignore-package-exit-codes --installargs 'ADD_CMAKE_TO_PATH=System' `
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
  && 7z x C:\Temp\llvm.exe -oC:\LLVM && setx PATH "%path%;C:\\llvm\\bin" && setx LLD_LINK "C:\\llvm\\bin\\lld-link.exe" `
  && (RD /S /Q C:\vcpkg\downloads C:\vcpkg\buildtrees C:\vcpkg\packages C:\Temp || echo "Unable to remove filees!") `

# Use developer command prompt and start PowerShell if no other command specified.
#ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&
#CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]