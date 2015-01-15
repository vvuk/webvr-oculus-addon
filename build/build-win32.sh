set -e

SOURCES=$(find ../Src -name \*.cpp -or -name \*.mm -or -name \*.c )
#echo $SOURCES

# Strip some stuff that shouldn't get built out
SOURCES=`echo $SOURCES | sed 's,[^ ]*API_D3D1X[^ ]*.cpp,,g'`

# Convert line endings
#SOURCES=`echo $SOURCES | sed 's,/,\\,g'`

if [ "$PLATFORM" == "X64" ] ; then
  echo Detected 64-bit build environment
  SUFFIX=64
else
  echo Detected 32-bit build environment
  SUFFIX=32
fi

# We need to manually define OVR_OS_WIN32, because OVR_CAPI.h doesn't
# include OVR_Types.h early enough to get it defined for the
# declspec(dllexport) to kick in.
# Ignore the redefinition errors.
CPPFLAGS="-DOVR_OS_WIN32=1 -DUNICODE=1 -D_UNICODE=1 -I../../3rdParty/glext"

rm -f *.obj

cl -O2 $CPPFLAGS $SOURCES -Zi -Fdlibovr$SUFFIX.pdb -Felibovr$SUFFIX.dll -LD -MT opengl32.lib setupapi.lib winmm.lib ws2_32.lib gdi32.lib shell32.lib

rm -f *.obj
