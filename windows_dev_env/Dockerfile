# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2016-amd64


SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017 for native desktop workload.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
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
    && RD /S /Q "C:\Program Files (x86)\Microsoft Visual Studio\Installer" "C:\ProgramData\Package Cache" "C:\TEMP"


# Tools
RUN @powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
RUN powershell choco feature disable --name showDownloadProgress
RUN choco install git.install -y --params "'/GitAndUnixToolsOnPath /NoAutoCrlf /NoCredentialManager'"
RUN powershell choco install nodejs ninja 7zip nsis cmake -y --ignoredetectedreboot -ignore-package-exit-codes

# VCPKG
RUN git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
RUN C:\BuildTools\Common7\Tools\VsDevCmd.bat && C:\vcpkg\bootstrap-vcpkg.bat -Verbose
RUN C:\BuildTools\Common7\Tools\VsDevCmd.bat && C:\vcpkg\vcpkg.exe install `
    boost-beast:x64-windows-static boost-beast:x86-windows-static `
    boost-filesystem:x64-windows-static boost-filesystem:x86-windows-static `
    boost-endian:x64-windows-static boost-endian:x86-windows-static `
    boost-container-hash:x64-windows-static boost-container-hash:x86-windows-static `
    boost-endian:x64-windows-static boost-endian:x86-windows-static `
    boost-lexical-cast:x64-windows-static boost-lexical-cast:x86-windows-static `
    boost-program-options:x64-windows-static boost-program-options:x86-windows-static `
    boost-scope-exit:x64-windows-static boost-scope-exit:x86-windows-static `
    boost-signals2:x64-windows-static boost-signals2:x86-windows-static `
    boost-utility:x64-windows-static boost-utility:x86-windows-static `
    boost-uuid:x64-windows-static boost-uuid:x86-windows-static `
    boost-bind:x64-windows-static boost-bind:x86-windows-static `
    boost-chrono:x64-windows-static boost-chrono:x86-windows-static `
    boost-date-time:x64-windows-static boost-date-time:x86-windows-static `
    boost-type-traits:x64-windows-static boost-type-traits:x86-windows-static `
    boost-static-assert:x64-windows-static boost-static-assert:x86-windows-static `
    boost-function:x64-windows-static boost-function:x86-windows-static `
    boost-smart-ptr:x64-windows-static boost-smart-ptr:x86-windows-static `
    boost-optional:x64-windows-static boost-optional:x86-windows-static `
    openssl:x64-windows openssl:x86-windows `
    && RD /S /Q C:\vcpkg\downloads C:\vcpkg\buildtrees

# LLVM
ADD http://releases.llvm.org/8.0.0/LLVM-8.0.0-win64.exe C:\Temp\llvm.exe
RUN 7z x C:\Temp\llvm.exe -oC:\LLVM
RUN setx PATH "%path%;C:\\llvm\\bin"
RUN setx LLD_LINK "C:\\llvm\\bin\\lld-link.exe"

# QT
COPY qt-installer-noninteractive.qs C:\TEMP\
ADD https://download.qt.io/official_releases/online_installers/qt-unified-windows-x86-online.exe C:\Temp\qt.exe
RUN C:\Temp\qt.exe --script C:\Temp\qt-installer-noninteractive.qs --logging-rules "ifw.*=true" --verbose


COPY bonjoursdksetup.exe C:\TEMP\
RUN 7z x "C:\TEMP\\bonjoursdksetup.exe"  -oC:\TEMP
RUN msiexec /i C:\TEMP\deps\Bonjour64.msi /qb /quiet
RUN msiexec /i C:\TEMP\deps\BonjourSDK64.msi /qb /quiet

# Use developer command prompt and start PowerShell if no other command specified.
ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]