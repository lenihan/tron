# Dynamic (.so) version of vcpkg/triplet/x64-osx.cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Darwin)
set(VCPKG_OSX_ARCHITECTURES x86_64)

# Fix for OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY"
set(OpenGL_GL_PREFERENCE GLVND)         
