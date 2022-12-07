# Same as vcpkg/triplet/x64-windows.cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# Fix for OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY"
set(OpenGL_GL_PREFERENCE GLVND)          
