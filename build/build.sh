set -e

export TMP=`pwd`/tmp
mkdir -p $TMP

SOURCES=$(find ../Src -name \*.cpp -or -name \*.mm -or -name \*.c )

# Strip some junk out
SOURCES=`echo $SOURCES | sed 's,[^ ]*OVR_OSX_FocusObserver.mm,,g' | sed 's,[^ ]*OVR_OSX_FocusReader.mm,,g'`

echo $SOURCES

#`/home/vladimir/proj/osxcross/target/bin/osxcross-env`

#OBJS=""
#for src in $SOURCES ; do
# echo $src
# o32-clang++ -O2 -c $src -o x86/`basename $src`.o
# OBJS="$OBJS x86/`basename $src`.o"
#done
#echo o32-clang++ -O2 -dynamiclib $OBJS -o x86/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics
#o32-clang++ -O2 -dynamiclib $OBJS -o x86/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics
#
#exit 0

#echo Building 32-bit..
#o32-clang++ -O2 -dynamiclib $SOURCES -o x86/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics -framework Cocoa -lobjc

echo Building 64-bit..
clang++ -O2 -dynamiclib $SOURCES -o x64/libovr.dylib -framework OpenGL -framework CoreServices -framework IOKit -framework CoreGraphics -framework Cocoa -lobjc

echo Combining...
lipo -create x86/libovr.dylib x64/libovr.dylib -output libovr.dylib

echo Done

#OBJS=""
#
#for src in $SOURCES ; do
#    OBJ=`basename $src .cpp`.o
#    OBJS="$OBJS $OBJ"
#    o64-clang++ -c $src -o $OBJ -O3
#    echo $src $OBJ
#done
