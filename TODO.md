 TRON TODO

* [ ] Add Support for Qt types to debugger via .natvis. See https://onedrive.live.com/view.aspx?resid=26FAEC54F2C84ED5%211344089&id=documents&wd=target%28Visual%20Studio%20Code.one%7C02851C1E-5F6C-4384-8097-879FF57EE24A%2FGetting%20QString%20to%20show%20in%20VS%20Code%20Debugger%7C460FF699-BEF2-4E2A-995F-750561792881%2F%29
* [ ] Linux: fix qt debug libraries to have different name than release so that we can support release/debug executable from a single LD_LIBRARY_PATH. 
  * ~~FIX: patch third_party\vcpkg\buildtrees\qt5-base\src\5.15.4-2d510dee77.clean\mkspecs\features\create_cmake.prf to use debug_suffix like windows does for mac/linux via third_party\vcpkg\ports\qt5-base\patches\create_cmake.patch~~
  * NEW FIX: above patch didn't work, too complex. Think this can be fixed by fixing RPATH of executable so you don't have to specify LD_LIBRARY_PATH
* [ ] Linux: why is qt source not showing up in debugger (but osg source does). Works on Windows
* [ ] Linux: why is there a var directory created by fontconfig in root? Does not happen on mac/windows
* [ ] Mac: teapot in bottom right corner, red background. Saw this go away, now back...no idea why.
* [ ] Mac: debugger break not working
* [ ] Tag
* [ ] Use latest powershell 7.3.0
* [ ] osgEarth
* [ ] hello_library
* [ ] hello_app
* [ ] hello_precompiled_headers
* [ ] hello_massive_files
* [ ] hello_massive_symbols
* [ ] Setup git lfs
* [ ] Setup microsoft-git

* [x] osgconv, osgviewer verified on mac, windows, linux
* [x] Mac: hello_qt: missing libicuuc.71.dylib
* [x] Mac: hello_osg: why is background red, teapot in bottom left corner?
* [x] Add osgconv, osgviewer tools: fixed via `vcpkg install osg[tools] --recurse`
* [x] Why is Windows hello_osg help ('h') crashing in hyper-v, but not outside of VM (related towing text)? My guess is first error message: "wglChoosePixelFormatARB extension not foundying GDI.....so....don't worry about this...going to assume this is because VM is runningopengl.
* [x] Win: hello_osg: after 'h' to show help: Error reading file \Users\david\repos\tron\third_party\OpenSceneGraph-Data\fonts\arial.ttf: file not handled
* [x] Fix hello_osg to not crash
* [x] Remove all other non-useful projects
* [x] Verify builds/runs on clean windows
* [x] Verify builds/runs on clean linux
* [x] Get PDB's to work in debugger, document fix in CMakeLists.txt
* [x] Make sure no problems in headers
* [x] Why does vcpkg install qt5 work static, but not dynamic on mac?
* [x] Fix teapot not an outline? Test on workstation (which should be built now)...could be drivesue
* [x] Put vcpkg include in global cmakelists.txt, remove include docs, remove from hello_osg
* [x] Verify builds/runs on clean MacOS (later)
* [x] Root CMakeLists.txt: Document variable names like was done with Qt. 
* [x] Root CMakeLists.txt: Put all osg find_package in root cmakelists.txt.
* [x] Cleanup hello_osg CMakeLists.txt (how do you do include? remove find_package)
* [x] Add hello_cmake as first test in readme.md
* [x] Remove examples from readme.md.