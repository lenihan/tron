# Same as vcpkg/triplet/x64-osx.cmake, which is tested by continuous integration
# according to https://vcpkg.io/en/docs/users/triplets.html
#   > Triplets contained in the triplets\community folder are not tested by continuous integration, 
#   > but are commonly requested by the community.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)

set(VCPKG_CMAKE_SYSTEM_NAME Darwin)
set(VCPKG_OSX_ARCHITECTURES x86_64)


# Fix for vcpkg changed osg default to GL3, which breaks examples
set(osg_OPENGL_PROFILE GL2)          
