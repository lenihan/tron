# Dynamic (.so) version of vcpkg/triplet/x64-linux.cmake
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

####################################

# Fix for vcpkg changed osg default to GL3, which breaks examples
set(osg_OPENGL_PROFILE GL2)

# Fix for OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY"
set(OpenGL_GL_PREFERENCE GLVND)     