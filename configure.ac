AC_INIT([<package>],[<version>])

# Find the compiler and compiler flags used by R.
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi
CC=`"${R_HOME}/bin/R" CMD config CC`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`

have_rdkafka=no
RDKAFKALIB_CPPFLAGS=""
RDKAFKALIB_LIBS="-lrdkafka++"

PKG_PROG_PKG_CONFIG

if test [ -n "$PKG_CONFIG" ] ; then
  AC_MSG_CHECKING([pkg-config for rdkafka])
  if $PKG_CONFIG --exists rdkafka++; then
    have_rdkafka=yes
    RDKAFKALIB_CPPFLAGS=`"${PKG_CONFIG}" --cflags rdkafka++`
    RDKAFKALIB_LIBS=`"${PKG_CONFIG}" --libs rdkafka++`
  fi
  AC_MSG_RESULT([${have_rdkafka}])
fi

if test "x${have_rdkafka}" = xno; then
  AC_MSG_FAILURE([
  ---------------------------------------------
   'rdkafka' and its header files are required.

   Please install:

   * librdkafka-dev (on Debian and Ubuntu)
   * librdkafka-devel (on Fedora, CentOS and RHEL)
   * librdkafka (via Homebrew on macOS)
   * librdkafka_dev (on Solaris)

   and try again.

   If you believe this library is installed on your system but
   this script is simply unable to find it, you can specify the
   include and lib paths manually:

   R CMD INSTALL ${PACKAGE_NAME} \\
     --configure-vars='LIBS=-L/path/to/libs CPPFLAGS=-I/path/to/headers'
  ---------------------------------------------])
fi

AC_SUBST([PKG_LIBS], ["${LIBS} ${PKG_LIBS} ${RDKAFKALIB_LIBS}"])

# Write the flags into the src/Makevars file.
AC_SUBST([PKG_CPPFLAGS], ["${PKG_CPPFLAGS} ${RDKAFKALIB_CPPFLAGS}"])
AC_SUBST([PKG_LIBS], ["${LIBS} ${PKG_LIBS} ${ac_cv_search_deflate}"])
AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

echo "
  --------------------------------------------------
  Configuration for ${PACKAGE_NAME} ${PACKAGE_VERSION}

    cppflags: ${CPPFLAGS} ${PKG_CPPFLAGS}
    libs:     ${PKG_LIBS}

  --------------------------------------------------
"