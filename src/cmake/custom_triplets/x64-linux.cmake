set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)   # dlenihan: was static, make consistent with windows
set(osg_OPENGL_PROFILE GL2)          # dlenihan: vcpkg changed default to GL3, which breaks examples

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

