# Prerequisites
Write-Host "Prerequisites..." -ForegroundColor Green
if ($IsWindows) {
    $null = winget list cmake
    if (!$?) {
        $cmd = "winget install cmake"
        Write-Host $cmd -ForegroundColor Cyan
        Invoke-Expression $cmd
    }
    $cmd = "winget upgrade cmake"
    Write-Host $cmd -ForegroundColor Cyan
    Invoke-Expression $cmd
}
elseif ($IsLinux) {
    # Get latest versions of software
    sudo apt update
        
    # for WSL build from Visual Studio
    sudo apt install -y g++
    sudo apt install -y gdb 
    sudo apt install -y make 
    sudo apt install -y ninja-build 
    sudo apt install -y rsync 
    sudo apt install -y zip
    
    # needed by osg
    sudo apt install -y gperf

    # Needed by qt5
    sudo apt install -y bison
    sudo apt install -y python

    # Needed for qt5 https://doc.qt.io/qt-5/linux-requirements.html
    sudo apt install -y libfontconfig1-dev
    sudo apt install -y libfreetype6-dev
    sudo apt install -y libx11-dev
    sudo apt install -y libx11-xcb-dev
    sudo apt install -y libxext-dev
    sudo apt install -y libxfixes-dev
    sudo apt install -y libxi-dev
    sudo apt install -y libxrender-dev
    sudo apt install -y libxcb1-dev
    sudo apt install -y libxcb-glx0-dev
    sudo apt install -y libxcb-keysyms1-dev
    sudo apt install -y libxcb-image0-dev
    sudo apt install -y libxcb-shm0-dev
    sudo apt install -y libxcb-icccm4-dev
    sudo apt install -y libxcb-sync0-dev
    sudo apt install -y libxcb-xfixes0-dev
    sudo apt install -y libxcb-shape0-dev
    sudo apt install -y libxcb-randr0-dev
    sudo apt install -y libxcb-render-util0-dev
    sudo apt install -y libxcd-xinerama-dev
    sudo apt install -y libxkbcommon-dev
    sudo apt install -y libxkbcommon-x11-dev

    # Needed for qt5 https://github.com/microsoft/vcpkg/blob/master/scripts/azure-pipelines/linux/provision-image.sh
    sudo apt install -y libxcb-util0-dev
    sudo apt install -y libxcb-xinerama0-dev
    sudo apt install -y libxcb-xkb-dev
    sudo apt install -y libxcb-xinput-dev
}
