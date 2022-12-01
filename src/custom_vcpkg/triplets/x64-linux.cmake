# Same as vcpkg/triplet/x64-linux.cmake, which is tested by continuous integration
# according to https://vcpkg.io/en/docs/users/triplets.html
#   > Triplets contained in the triplets\community folder are not tested by continuous integration, 
#   > but are commonly requested by the community.
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

# Fix for vcpkg changed osg default to GL3, which breaks examples
# set(osg_OPENGL_PROFILE GL2)      

# Fix for OpenGL_GL_PREFERENCE has not been set to "GLVND" or "LEGACY"
set(OpenGL_GL_PREFERENCE GLVND)    


# NOTE 1: The name of this file is important. Originally it was custom-linux.cmake.
#         But the ninja build used "x64-windows" as a directory name for 
#         installed includes instead of "custom-linux" and include files could not
#         be found during builds. Changing name to "x64-linux" fixed the problem.
#
# NOTE 2: I tried building this with set(VCPKG_LIBRARY_LINKAGE dynamic) but I
#         ran into issues with `proj` not building (SQLite error). Switching
#         to static builds without error, but no examples.
 