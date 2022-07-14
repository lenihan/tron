Remove-Item $HOME/repos/tron/build -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $env:LOCALAPPDATA/vcpkg -Recurse -Force -ErrorAction SilentlyContinue  
Remove-Item $HOME/repos/tron/third_party -Recurse -Force -ErrorAction SilentlyContinue