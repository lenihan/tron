# Same as vcpkg/triplet/x64-windows.cmake, which is tested by continuous integration
# according to https://vcpkg.io/en/docs/users/triplets.html
#   > Triplets contained in the triplets\community folder are not tested by continuous integration, 
#   > but are commonly requested by the community.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

# Fix for vcpkg changed osg default to GL3, which breaks examples
set(osg_OPENGL_PROFILE GL2)          


# NOTE 1: The name of this file is important. Originally it was custom-windows.cmake.
#         But the visual studio solution used "x64-windows" as a directory name for 
#         installed includes instead of "custom-windows" and include files could not
#         be found during builds. Changing name to "x64-windows" fixed the problem.
# 
# NOTE 2: x64-windows-static.cmake builds, but examples do not get built for some reason. 
#         It had these settings that are different from this file:
#         set(VCPKG_CRT_LINKAGE static)
#         set(VCPKG_LIBRARY_LINKAGE static)
