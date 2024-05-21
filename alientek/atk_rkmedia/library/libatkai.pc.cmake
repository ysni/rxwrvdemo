prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}/@CMAKE_INSTALL_BINDIR@
libdir=${prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@

Name: easyai
Description: easy Audio inout interface library
Version: @LIBRARY_VERSION@
Libs: -L${libdir} -leasyai
Libs.private:
Cflags: -I${includedir}
