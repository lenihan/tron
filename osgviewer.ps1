.  "$PSScriptRoot\Set-Env.ps1"
Start-Process -FilePath "$PSScriptRoot\third_party\vcpkg\installed\x64-windows\tools\osg\osgviewer.exe" -ArgumentList $args

# TODO: HOW TO MAKE .PS1 WRAPPER THAT I CAN ASSOCIATE WITH .osgb OR make environment work by changing path (may be simpler)