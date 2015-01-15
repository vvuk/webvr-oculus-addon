set -e

export TMP=`pwd`/tmp
mkdir -p $TMP x86 x64

SOURCES=$(find ../Src -name \*.cpp -or -name \*.mm -or -name \*.c )

# Strip some junk out
SOURCES=`echo $SOURCES | sed 's,[^ ]*OVR_OSX_FocusObserver.mm,,g' | sed 's,[^ ]*OVR_OSX_FocusReader.mm,,g'`

echo $SOURCES

if [ -f /home/vladimir/proj/osxcross/target/bin/osxcross-env ] ; then
  `/home/vladimir/proj/osxcross/target/bin/osxcross-env`
  echo Building using OSX cross-compile env
  CC_X86="o32-clang++"
  CC_X64="o64-clang++"
  LIPO="x86_64-apple-darwin12-lipo"
else
  echo Building native OSX
  CC_X86="clang++ -arch i386"
  CC_X64="clang++ -arch x86_64"
  LIPO="lipo"
fi

echo Building 32-bit..
$CC_X86 -O2 -dynamiclib $SOURCES -o x86/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics -framework Cocoa -lobjc

echo Building 64-bit..
$CC_X64 -O2 -dynamiclib $SOURCES -o x64/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics -framework Cocoa -lobjc

echo Combining...
$LIPO -create x86/libovr.dylib x64/libovr.dylib -output libovr.dylib

echo Done
