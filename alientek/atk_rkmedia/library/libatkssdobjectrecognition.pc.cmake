prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}/@CMAKE_INSTALL_BINDIR@
libdir=${prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@

Name: atkssdobjectrecognition
Description: atkssdobjectrecognition interface library
Version: @LIBRARY_VERSION@
Libs: -L${libdir} -latk_ssd_object_recognition
Libs.private:
Cflags: -I${includedir}
