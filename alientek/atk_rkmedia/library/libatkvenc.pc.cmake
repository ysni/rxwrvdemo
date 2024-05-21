prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}/@CMAKE_INSTALL_BINDIR@
libdir=${prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@

Name: atkvdec
Description: atk venc interface library
Version: @LIBRARY_VERSION@
Libs: -L${libdir} -latk_venc
Libs.private:
Cflags: -I${includedir}
