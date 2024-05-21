prefix=@CMAKE_INSTALL_PREFIX@
exec_prefix=${prefix}/@CMAKE_INSTALL_BINDIR@
libdir=${prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@

Name: sample_common_isp
Description: sample common isp interface library
Version: @LIBRARY_VERSION@
Libs: -L${libdir} -lsample_common_isp
Libs.private:
Cflags: -I${includedir}
