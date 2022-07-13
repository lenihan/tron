# Same as vcpkg/triplet/x64-windows-static.cmake, which is tested by continuous integration
# according to https://vcpkg.io/en/docs/users/triplets.html
#   > Triplets contained in the triplets\community folder are not tested by continuous integration, 
#   > but are commonly requested by the community.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)   

# Fix for vcpkg changed osg default to GL3, which breaks examples
set(osg_OPENGL_PROFILE GL2)          
